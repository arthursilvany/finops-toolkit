# Política de custo dos agentes

Cada execução declara limites aprovados por run, dia e mês para chamadas,
tokens quando disponibilizados, duração, linhas, bytes consultados e custo
estimado/real. Limite ausente bloqueia schedules de produção.

## Controles

- Prefira eventos e freshness a polling; não presuma cadência de 15 minutos.
- Declare timezone IANA, jitter, timeout, maintenance windows e lock.
- Evite queries repetidas com cache versionado por scope, período e hash.
- Use projeção de colunas, partições e janelas mínimas suficientes.
- Deduplique por execution ID/idempotency key.
- Pare antes do orçamento; não reduza evidência crítica para aparentar economia.
- Escalone aumento de orçamento como change set.

## Métricas

Registre por agente/run: tool calls, tokens de entrada/saída quando disponíveis,
latência, falhas, retries, handoffs, groundedness auditada, falsos
positivos/negativos, approval latency, custo do agente/plataforma e valor
potencial, aprovado, implementado e validado. Métrica indisponível é `NA`, não
zero. Valor deve ser ligado a baseline, período comparável e evidência.

