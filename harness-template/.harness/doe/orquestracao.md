# DOE — Orquestração
# Camada 2: Como o Agente Planeja e Delega

## Padrão de Orquestração

```
ENTRADA: tarefa do usuário
      ↓
INTENT GATE: pesquisa / implementação / investigação / correção / revisão
      ↓
INDEX: leia .harness/index.md → identifique directive com match
      ↓
DIRECTIVE: carregue apenas a directive relevante
      ↓
PLAN: decomponha em tarefas com critérios verificáveis
      ↓
EXECUTE: use scripts de execution/ quando disponível
      ↓
VERIFY: valide cada critério antes de reportar
      ↓
SAÍDA: máximo 3 linhas de sucesso ou ERRO/CAUSA/AÇÃO
```

## Decisão: Agente vs Script

| Tarefa | Quem faz |
|--------|---------|
| Lógica de negócio verificável | Script em `execution/` |
| Compressão de histórico | `compress-history.py` |
| Geração de documentos | Script determinístico |
| Raciocínio e decisão | Agente (Camada 2) |
| Classificação de intenção | Agente (Camada 2) |

## Sub-agentes

Quando delegar para sub-agente:
- Tarefa > 20k tokens estimados
- Tarefa independente do contexto atual

Template em `directives/subagent-dispatch.md`.

## Prompt do Planejador

Use este template para tarefas complexas:

```
Tarefa: [descrição]
Spec: [link para docs/specs/ se existir]

Decomponha em tarefas com:
| # | Tarefa | Arquivo | Critério Verificável | Depende de |

Apresente o plano. Aguarde aprovação antes de executar.
```
