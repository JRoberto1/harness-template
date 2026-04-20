# .harness/index.md — Índice de Directives e Skills

> Leia este arquivo PRIMEIRO. Carregue apenas o que tiver match com a tarefa.
> Atualizado automaticamente quando novas directives/skills são criadas.

---

## Como Usar

```
1. Leia as palavras-chave de cada directive abaixo
2. Identifique qual tem match com a tarefa atual
3. Carregue APENAS essa directive
4. Se nenhuma fizer match → execute sem directive específica
```

---

## Directives Disponíveis

| Arquivo | Palavras-chave | Quando carregar |
|---------|---------------|----------------|
| `directives/DIRECTIVE-template.md` | template, criar directive | ao criar nova directive |
| `directives/health-check.md` | saúde, verificar, integridade, check | ao verificar o sistema |
| `directives/session-memory.md` | sessão, memória, contexto, handoff, retomar | ao iniciar/encerrar sessão |
| `directives/context-management.md` | tokens, contexto, compressão, budget, economia | ao gerenciar tokens |

> Adicione uma linha aqui sempre que criar uma nova directive.

---

## Skills Disponíveis

| Arquivo | Palavras-chave | Quando carregar |
|---------|---------------|----------------|
| `.harness/skills/SKILL-template.md` | template, criar skill | ao criar nova skill |

> Adicione uma linha aqui sempre que instalar uma nova skill.

---

## Domínios Disponíveis

| Arquivo | Palavras-chave | Quando carregar |
|---------|---------------|----------------|
| `.harness/domains/saas.md` | frontend, UI, autenticação, JWT, produto web | tarefas de produto web |
| `.harness/domains/api.md` | endpoint, API, REST, backend, rota | tarefas de API |
| `.harness/domains/automation.md` | script, automação, batch, pipeline, ETL | tarefas de automação |
| `.harness/domains/juridico-financeiro.md` | contrato, cláusula, LGPD, valor, pagamento | tarefas jurídicas/financeiras |

---

## Regra de Manutenção

Quando criar uma nova directive, skill ou domínio:
1. Adicione uma linha na tabela correspondente acima
2. Use palavras-chave específicas — evite termos genéricos
3. Commit: `harness(index): adicionar [nome]`
