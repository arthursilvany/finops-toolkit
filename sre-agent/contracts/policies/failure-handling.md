# Política de tratamento de falhas

## Semântica

- Erro de ferramenta não é estado do ambiente.
- Unknown, ausência, timeout, dado stale ou `SEM_ACESSO` nunca vira zero,
  `healthy` ou `PASS`.
- Evidências conflitantes são preservadas; a conclusão é `INCONCLUSIVE`.
- Não declare ação, artefato ou link concluído sem verificar retorno,
  persistência e integridade.
- Perda de scope, identidade, RBAC, lock ou aprovação interrompe toda escrita.

## Estratégia

Classifique falhas como transitórias, permanentes, de dados, autorização,
contrato ou segurança. Retry somente para transitórias, com backoff exponencial,
jitter e limite explícito; use a mesma idempotency key. Abra circuit breaker
após o limiar e envie item sanitizado à dead-letter queue. Não faça fallback que
reduza segurança ou altere a semântica.

`PARTIAL_SUCCESS` lista partições concluídas, não executadas, stale e falhas,
sem promover KPIs incompletos. Falha de cleanup é incidente e permanece aberta.
Ao falhar redaction, secret/PII scan, schema ou hash, bloqueie publicação.

## Recuperação

Registre erro sanitizado, tool/run ID, tentativa, UTC, impacto, evidências,
último checkpoint seguro e ação humana necessária. Rollback/compensação exige
plano e autorização compatível. Não repita ações irreversíveis.

