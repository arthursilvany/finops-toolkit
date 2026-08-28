# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

[CmdletBinding(SupportsShouldProcess)]
param
(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Scope,

    [Parameter()]
    [string]
    $HubName,

    [Parameter()]
    [string]
    $ResourceGroupName
)

$ErrorActionPreference = 'Stop'

try
{
    $modulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\..\src\powershell\FinOpsToolkit.psm1'
    if (-not (Test-Path -LiteralPath $modulePath))
    {
        throw "Could not find the FinOpsToolkit module at '$modulePath'. Run this script from a cloned finops-toolkit repository, or import the module and call Add-FinOpsHubResourceGraphReader directly."
    }

    Import-Module -FullyQualifiedName $modulePath -Force
    Add-FinOpsHubResourceGraphReader -Scope $Scope -HubName $HubName -ResourceGroupName $ResourceGroupName -Confirm:$false
    exit 0
}
catch
{
    Write-Error $_
    exit 1
}
