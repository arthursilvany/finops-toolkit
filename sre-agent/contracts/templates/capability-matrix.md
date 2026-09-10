# Capability Matrix

Preencha somente por testes reais. Não transforme nomes abaixo em capacidades
presumidas. Capacidade ausente ou teste não executável é `SEM_ACESSO`.

| Capability ID | Runtime tool name | Connector/endpoint | Identidade efetiva | RBAC/role observada | Escopo testado | Teste read-only e resultado | UTC/tool run ID | Estado | Fallback aprovado |
|---|---|---|---|---|---|---|---|---|---|
| `<capability-id>` | `<nome reportado pelo runtime>` | `<connector>` | `<principal observado>` | `<role ou SEM_ACESSO>` | `<resource IDs>` | `<comando/query sem segredo>` | `<timestamp/run>` | `VALIDATED/PARTIAL/SEM_ACESSO/NA` | `<nenhum ou fallback>` |

Para cada linha registre ainda: operações permitidas/proibidas, classificação
dos dados, limite, timeout e owner. Um fallback deve manter scope, read-only e
evidência; documentação ou memória do modelo não prova acesso.

