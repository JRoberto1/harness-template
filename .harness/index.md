# .harness/index.md — Índice de Directives e Skills
<!-- v1.3.0 -->

> Leia este arquivo PRIMEIRO. Carregue apenas o que tiver match com a tarefa.

---

## Como Usar

```
1. Leia as palavras-chave de cada linha
2. Identifique qual tem match com a tarefa atual
3. Carregue APENAS essa directive ou skill
4. Se nenhuma fizer match → execute sem carregar nada extra
```

---

## Directives

| Arquivo | Palavras-chave | Quando carregar |
|---------|---------------|----------------|
| `directives/DIRECTIVE-template.md` | template, criar directive | ao criar nova directive |
| `directives/health-check.md` | saúde, verificar, integridade | ao verificar o sistema |
| `directives/session-memory.md` | sessão, memória, contexto, handoff, retomar | ao iniciar/encerrar sessão |
| `directives/context-management.md` | tokens, contexto, compressão, budget | ao gerenciar tokens |
| `directives/subagent-dispatch.md` | subagente, delegar, tarefa pesada, isolado | tarefa > 20k tokens |
| `directives/observation-masking.md` | log longo, output longo, masking, placeholder | output > 20 linhas |

---

## Skills

| Arquivo | Palavras-chave | Quando carregar |
|---------|---------------|----------------|
| `.harness/skills/SKILL-template.md` | template, criar skill | ao criar nova skill |

---

## Domínios

| Arquivo | Palavras-chave | Quando carregar |
|---------|---------------|----------------|
| `.harness/domains/saas.md` | frontend, UI, autenticação, JWT, produto web | tarefas de produto web |
| `.harness/domains/api.md` | endpoint, API, REST, backend, rota | tarefas de API |
| `.harness/domains/automation.md` | script, automação, batch, pipeline, ETL | tarefas de automação |
| `.harness/domains/juridico-financeiro.md` | contrato, cláusula, LGPD, valor, pagamento | tarefas jurídicas |

---

## Regra de Manutenção

Ao criar nova directive, skill ou domínio:
1. Adicione uma linha na tabela acima
2. Use palavras-chave específicas
3. Commit: `harness(index): adicionar [nome]`
