# /model-select — Selecionar Modelo para a Tarefa

Ajuda a escolher o modelo certo antes de iniciar uma tarefa,
evitando usar Opus quando Haiku é suficiente.

## Como usar

```
/model-select
/model-select "gerar testes unitários"
/model-select "arquitetura do sistema de pagamentos"
```

## Instruções para o Agente

Quando receber este comando:

### 1. Identificar o tipo de tarefa

Se o usuário passou uma descrição, classifique:

| Tipo | Exemplos | Modelo |
|------|----------|--------|
| **Arquitetura / Decisão complexa** | Design de sistema, decisão técnica difícil, debugging profundo | **Opus / Pro** |
| **Implementação / Código** | Escrever função, refatorar, criar componente | **Sonnet / padrão** |
| **Rotina / Mecânica** | Docs, testes simples, formatação, resumos | **Haiku / Mini** |

### 2. Recomendar com justificativa

Responda em no máximo 3 linhas:

```
Tarefa: [classificação]
Modelo recomendado: [modelo]
Motivo: [uma linha]
```

### 3. Se não passou descrição

Pergunte:
```
Descreva a tarefa em uma linha para eu recomendar o modelo certo.
```

## Exemplos de Recomendação

```
Tarefa: gerar testes unitários para a função gerarContrato
Modelo recomendado: Haiku / Mini
Motivo: tarefa mecânica, padrão repetitivo, não requer raciocínio complexo

Tarefa: decidir arquitetura de cache para o sistema de contratos
Modelo recomendado: Opus / Pro
Motivo: decisão com impacto de longo prazo, requer análise de trade-offs

Tarefa: implementar endpoint POST /api/contratos
Modelo recomendado: Sonnet / padrão
Motivo: implementação padrão, equilíbrio ideal entre custo e qualidade
```
