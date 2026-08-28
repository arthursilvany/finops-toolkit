# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

& "$PSScriptRoot/../Initialize-Tests.ps1"

InModuleScope FinOpsToolkit {
    Describe 'Add-FinOpsHubBillingReader' {
        BeforeAll {
            function Get-AzContext {}
            function Get-FinOpsHub {}
            function Get-AzDataFactoryV2 {}
        }

        BeforeEach {
            Mock Get-AzContext { @{ Tenant = @{ Id = 'tenant-id' } } }
            Mock Get-FinOpsHub {
                @{
                    Resources = @(
                        @{
                            ResourceType = 'Microsoft.DataFactory/factories'
                            ResourceGroupName = 'hub-rg'
                            Name = 'hub-engine'
                        }
                    )
                }
            }
            Mock Get-AzDataFactoryV2 {
                @{ Identity = @{ PrincipalId = 'principal-id' } }
            }
            Mock Invoke-Rest -ParameterFilter { $Uri -like '*billingRoleDefinitions*' } {
                @{
                    Success = $true
                    Content = @{
                        value = @(
                            @{
                                id = '/providers/Microsoft.Billing/billingAccounts/billing-id/billingRoleDefinitions/reader'
                                properties = @{ roleName = 'Billing account reader' }
                            }
                        )
                    }
                }
            }
            Mock Invoke-Rest -ParameterFilter { $Method -eq 'GET' -and $Uri -like '*billingRoleAssignments*' } {
                @{
                    Success = $true
                    Content = @{ value = @() }
                }
            }
            Mock Invoke-Rest -ParameterFilter { $Method -eq 'PUT' -and $Uri -like '*billingRoleAssignments*' } {
                @{
                    Success = $true
                    Content = @{ id = 'assignment-id' }
                }
            }
        }

        It 'assigns Billing Reader and returns a status object' {
            $result = Add-FinOpsHubBillingReader -BillingAccountId 'billing-id' -HubName 'hub' -ResourceGroupName 'hub-rg' -Confirm:$false

            Should -Invoke Invoke-Rest -Times 1 -ParameterFilter { $Method -eq 'PUT' -and $Uri -like '*billingRoleAssignments*' }
            $result.Command | Should -Be 'Add-FinOpsHubBillingReader'
            $result.Status | Should -Be 'Assigned'
            $result.Role | Should -Be 'Billing Reader'
            $result.BillingAccountId | Should -Be 'billing-id'
            $result.RoleAssignmentId | Should -Be 'assignment-id'
        }

        It 'does not create an assignment when Billing Reader already exists' {
            Mock Invoke-Rest -ParameterFilter { $Method -eq 'GET' -and $Uri -like '*billingRoleAssignments*' } {
                @{
                    Success = $true
                    Content = @{
                        value = @(
                            @{
                                id = 'existing-assignment-id'
                                properties = @{
                                    principalId = 'principal-id'
                                    roleDefinitionId = '/providers/Microsoft.Billing/billingAccounts/billing-id/billingRoleDefinitions/reader'
                                }
                            }
                        )
                    }
                }
            }

            $result = Add-FinOpsHubBillingReader -BillingAccountId '/providers/Microsoft.Billing/billingAccounts/billing-id' -Confirm:$false

            Should -Invoke Invoke-Rest -Times 0 -ParameterFilter { $Method -eq 'PUT' -and $Uri -like '*billingRoleAssignments*' }
            $result.Status | Should -Be 'AlreadyAssigned'
            $result.BillingAccountId | Should -Be 'billing-id'
            $result.RoleAssignmentId | Should -Be 'existing-assignment-id'
        }

        It 'returns skipped when ShouldProcess is declined' {
            $result = Add-FinOpsHubBillingReader -BillingAccountId 'billing-id' -WhatIf

            Should -Invoke Invoke-Rest -Times 0 -ParameterFilter { $Method -eq 'PUT' -and $Uri -like '*billingRoleAssignments*' }
            $result.Status | Should -Be 'Skipped'
        }

        It 'throws when the assignment API fails' {
            Mock Invoke-Rest -ParameterFilter { $Method -eq 'PUT' -and $Uri -like '*billingRoleAssignments*' } {
                @{
                    Success = $false
                    Content = @{ error = @{ message = 'Denied' } }
                }
            }

            { Add-FinOpsHubBillingReader -BillingAccountId 'billing-id' -Confirm:$false } | Should -Throw
        }
    }
}
