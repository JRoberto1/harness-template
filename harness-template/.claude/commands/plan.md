# /plan — Decomposição em Tarefas Verificáveis

Decomponha o trabalho em tarefas pequenas com critérios verificáveis.
Nenhuma tarefa pode ser "parece certo" — deve ter evidência.

## Como usar

```
/plan login com JWT
/plan refatoração do módulo de contratos
/plan [nome da feature da spec]
```

## Instrução para o Agente

### 1. Ler a Spec

Se existir `docs/specs/[feature].md`, leia antes de planejar.
Se não existir, peça: "Rode /spec [feature] primeiro."

### 2. Gerar o Plano

```markdown
## Plano: [Nome]
**Spec:** docs/specs/[arquivo].md | **Estimativa:** [N tarefas]

| # | Tarefa | Arquivo(s) | Critério Verificável | Depende de |
|---|--------|-----------|---------------------|-----------|
| 1 | [descrição] | [arquivo] | [evidência concreta] | — |
| 2 | [descrição] | [arquivo] | [evidência concreta] | #1 |

**Fora do escopo:** [o que NÃO será feito neste plano]

**Riscos:** [o que pode dar errado e como mitigar]
```

### Critérios Verificáveis — Exemplos

| ❌ Fraco | ✅ Forte |
|---------|---------|
| "implementar login" | "`POST /auth/login` retorna 200 com JWT válido" |
| "adicionar testes" | "`npm test` passa com 0 erros, cobertura > 80%" |
| "corrigir bug" | "erro X não aparece mais com input Y" |

### Anti-Rationalization

❌ "Posso implementar sem plano" → Sem plano = sem critério = sem verificação
❌ "As tarefas são óbvias" → Se é óbvio, leva 2 min escrever. Escreva.
❌ "Posso fazer tudo de uma vez" → Tarefas grandes = contexto pesado = erros

### 3. Aguardar Aprovação

Apresente o plano e aguarde. Só execute após "aprovado" explícito.
