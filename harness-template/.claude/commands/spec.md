# /spec — Spec-Driven Development

Escreva a especificação ANTES de qualquer código.
"Spec antes de código" é não-negociável.

## Como usar

```
/spec nova feature de login
/spec refatoração do módulo de contratos
/spec integração com API externa
```

## Instrução para o Agente

Ao receber este comando, siga o protocolo:

### 1. Estrutura da Spec (preencha na ordem)

```markdown
## Spec: [Nome da Feature]
**Data:** | **Autor:** | **Status:** Rascunho

### Visão Geral
[Uma frase: o que esta feature faz e por que existe]

### Problema que Resolve
[O que está quebrado ou faltando sem esta feature]

### Escopo — O que ESTÁ incluído
- [item 1]
- [item 2]

### Escopo — O que NÃO está incluído
- [item 1] ← previne scope creep

### Critérios de Aceitação
| # | Cenário | Dado | Quando | Então |
|---|---------|------|--------|-------|
| 1 | [nome] | [contexto] | [ação] | [resultado esperado] |

### Impacto Técnico
- Arquivos afetados: [lista]
- Dependências novas: [lista ou "nenhuma"]
- Mudanças de schema: [lista ou "nenhuma"]
- Breaking changes: [sim/não + detalhes]

### Anti-Rationalization
❌ "Posso implementar sem spec" → Spec leva 10 min, debug sem spec leva horas
❌ "É uma mudança pequena" → Mudanças pequenas sem spec são as que quebram prod
❌ "Já sei o que fazer" → Spec não é para você — é para o agente e o futuro
```

### 2. Aguardar Aprovação

Apresente a spec e aguarde confirmação antes de qualquer implementação.
Só prossiga após "aprovado" explícito.

### 3. Ao Aprovar

Salve em `docs/specs/[nome-kebab-case].md` e responda:
```
✓ Spec salva em docs/specs/[arquivo].md
→ Próximo passo: /plan [nome-da-feature]
```
