# Contrato de relatório

## Metadados

`report_id`, versão, execution ID, epoch/snapshot, scope hash, período, timezone,
moeda, classificação, gerado em UTC, fontes e freshness.

## Conteúdo mínimo

Resumo; KPIs com estado/confiança; dados ausentes; riscos; decisões; change sets;
evidence refs; limitações; métricas do agente. Cada número informa unidade,
fórmula, denominador, `OBSERVED/DERIVED/INFERRED/RECOMMENDED`, período e fonte.
`SEM_ACESSO`, `NA`, stale e erro permanecem explícitos.

## Pipeline de publicação

1. `BUILD`: gerar JSON/HTML determinísticos em staging.
2. `STAGE`: validar schemas, links, escaping contextual e acessibilidade.
3. `APPROVE`: aprovar hash exato do pacote.
4. `PUBLISH`: atomic swap; preservar versão anterior e rollback.

HTML deve ser autocontido/offline, legível sem JavaScript, sem scripts/fontes
remotos, com CSP restritiva, dados escapados, sanitização, redaction,
secret/PII scan e classificação visível. JSON embutido usa
`type="application/json"` e escaping seguro. Registre checksum, destino,
retenção, versão e verificação pós-publicação. Publicação sempre exige aprovação.

