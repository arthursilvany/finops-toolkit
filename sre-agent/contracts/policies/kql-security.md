# Política de segurança KQL

## Proveniência e estados

Toda query deve vir de fonte fixada por repositório, caminho, branch e commit
SHA, ou de artefato local com SHA-256. Preserve texto original e hash. Adaptação
gera novo artefato/hash e diff documentado. Estados avançam somente em ordem:
`DISCOVERED` → `STATICALLY_VALIDATED` → `SCHEMA_VALIDATED` → `EXECUTED`.

## Allowlist query-only

Permita apenas consultas de leitura e operadores aprovados. Bloqueie:

- management commands iniciados por `.`;
- `.set`, `.append`, `.ingest`, `.drop`, `.delete`, `.alter`, `.create`,
  `.execute`, comandos de policy e qualquer mutação;
- `externaldata`, plugins ou chamadas externas não aprovadas;
- `cluster()`/cross-cluster, cross-database ou union curinga fora da allowlist;
- código dinâmico, ofuscação e expansão de escopo não declarada.

Valide AST/texto, tabelas e colunas reais antes de executar. Parâmetros devem ser
tipados; não concatene entrada não confiável.

## Limites

Respeite os menores valores entre scope e política: período, tabelas,
subscriptions, `max_rows`, `max_query_bytes`, timeout, memória, concorrência e
custo estimado. Comece com amostra/`take` seguro; aumente somente com
justificativa. Cancele query que exceda limite. Nunca contorne limitação
particionando silenciosamente.

## Registro

Evidência deve conter texto e hash da query, parâmetros, database/cluster
aprovados, identidade, tool/run ID, UTC, período, schema, row count, result hash,
freshness, custo/estatística disponível e status. Zero linhas é um resultado
observado, mas erro, timeout, falta de acesso ou fonte ausente não são zero.

