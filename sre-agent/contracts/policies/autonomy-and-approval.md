# Política de autonomia e aprovação

## Regra central

O modo padrão é `Review-first`. Leitura não implica autorização de escrita.
Silêncio, timeout, ausência de objeção ou texto genérico nunca são aprovação. O
agente proponente, executor ou orquestrador não pode aprovar a própria mudança.
Falha do mecanismo de aprovação é `BLOCKED` (fail-closed).

## Classificação

| Classe | Exemplos |
|---|---|
| AUTÔNOMO | inventário read-only, consulta, validação, cálculo, detecção, recomendação e artefato local não publicado |
| APROVAÇÃO OBRIGATÓRIA | toda escrita, publicação, alteração de recurso/configuração/dado, RBAC, policy, budget, tag, alerta, export, retenção, automação, comunicação externa |
| BLOQUEADO | fora do scope, evidência adulterada, segredo/PII sem proteção, autoaprovação, comando diferente do aprovado, aprovação ausente/expirada, ação irreversível sem autorização específica |

Compra, troca ou renovação de Reservation, Savings Plan, licença ou qualquer
commitment financeiro exige aprovação explícita e nunca pode ser promovida a
autônoma.

## Protocolo

1. Gerar um
   [`change-set`](../schemas/change-set.schema.json) com preconditions,
   dry-run/what-if, expected diff, blast radius, comandos exatos, recursos,
   postconditions e rollback/compensação.
2. Canonicalizar JSON (UTF-8, chaves ordenadas, sem whitespace insignificante) e
   calcular SHA-256.
3. Registrar decisão no
   [`approval-ledger`](../schemas/approval-ledger.schema.json), com hash,
   approver independente, escopo e validade.
4. Antes de cada passo, revalidar scope, identidade, RBAC, hash, validade,
   preconditions, lock e maintenance window.
5. Executar somente passos aprovados. Mudança de comando, recurso, ordem,
   parâmetro ou hash invalida a aprovação.
6. Validar postconditions. Ao falhar, parar; executar rollback apenas se também
   coberto pela aprovação. Caso contrário, escalar para humano.

`REVERSIBLE` requer rollback testado; `COMPENSATABLE`, compensação e risco
residual; `IRREVERSIBLE`, autorização específica e execução humana/controle
externo conforme política. Approval não amplia RBAC nem scope.
