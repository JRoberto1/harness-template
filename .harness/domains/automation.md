# Domínio: Automações / Scripts

> Ative: marque `[x] Automação / Scripts` no AGENTS.md

## Princípios
- **Idempotência**: toda automação pode rodar N vezes sem efeito colateral
- **Falha explícita**: nunca silenciosa — log + notificação + propagação do erro
- **Estado persistido**: progresso salvo para retomada após falha
- **`--dry-run` obrigatório**: toda automação simula antes de executar

## Pipeline ETL
```
EXTRACT  → coleta + valida schema → grava em .tmp/staging/
TRANSFORM → aplica regras de negócio → grava resultado
LOAD     → persiste no destino → confirma sucesso
```
Cada fase tem rollback definido antes de executar.

## Processamento em Lote
- Batch size: máx 100 itens (configurável via `--batch-size`)
- Timeout por item: explícito
- Retry: máx 3 tentativas com backoff exponencial
- Dead letter: falhas após 3 tentativas → fila de análise manual

## Quality Gates
- [ ] Script tem `--dry-run` · Logs incluem job_id, item_id, step, timestamp
- [ ] Estado de progresso salvo a cada batch
- [ ] Variáveis obrigatórias validadas no startup (não em runtime)
