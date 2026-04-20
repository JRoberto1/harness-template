# E — Execução (Prompt dos Subagentes)

> Cada subagente tem **uma única responsabilidade**.
> Não conhece o objetivo global — apenas sua tarefa.
> Isolamento de contexto: reduz drasticamente a taxa de erro.

---

## Template do Prompt de Subagente

```
DIRETRIZES: [Cole as Diretrizes aqui]

PAPEL: Você é o subagente de [FUNÇÃO].
Você não conhece o objetivo global — apenas sua tarefa.

DIRECTIVE DE REFERÊNCIA: directives/[nome].md
  → Leia antes de executar se ainda não leu nesta sessão.

INPUT RECEBIDO:
{{input_do_orquestrador}}

TAREFA EXATA:
{{tarefa}}

SCRIPT A USAR (se aplicável):
  python execution/{{script}}.py --input "{{parametros}}"

OUTPUT OBRIGATÓRIO (apenas este JSON):
{
  "status": "success" | "error" | "needs_review",
  "resultado": {},
  "arquivos_modificados": [],
  "erros": [],
  "nota_proximo_agente": "string ou null"
}

PROIBIDO:
- Executar qualquer coisa fora do escopo acima
- Retornar texto fora do schema JSON
- Assumir informações não fornecidas no input
- Avançar se houver erro não resolvido
```

---

## Mensagem de Erro para Autocorreção

```
ERRO DE EXECUÇÃO — Subagente: [nome]
ERRO: [o que falhou]
CAUSA PROVÁVEL: [diagnóstico]
AÇÃO: [instrução específica de correção]
SCRIPT: [comando exato para tentar novamente]
REF: directives/[nome].md
```

> Mensagem genérica → agente trava.
> Mensagem com AÇÃO → agente se autocorrige sem intervenção humana.
