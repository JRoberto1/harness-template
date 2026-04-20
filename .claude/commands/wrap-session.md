# /wrap-session — Encerrar Sessão e Salvar Contexto

Encerra a sessão de trabalho atual, resume o que foi feito e salva
em `.harness/memory/` para que a próxima sessão retome de onde parou.

## Como usar

```
/wrap-session
/wrap-session autenticacao-jwt
/wrap-session fase-2-contratos
```

## Instruções para o Agente

Ao receber este comando, execute **na ordem**:

### 1. Coletar o contexto da sessão

Analise o que foi feito nesta sessão e monte o seguinte JSON internamente:

```json
{
  "data": "YYYY-MM-DD",
  "hora": "HH:MM",
  "tema": "[nome passado pelo usuário ou 'sessão-geral']",
  "decisoes_tomadas": ["decisão 1", "decisão 2"],
  "tarefas_concluidas": ["tarefa 1", "tarefa 2"],
  "tarefas_pendentes": [
    { "tarefa": "descrição", "prioridade": "alta|media|baixa" }
  ],
  "aprendizados": ["aprendizado não óbvio 1", "aprendizado 2"],
  "arquivos_modificados": ["caminho/arquivo1", "caminho/arquivo2"],
  "hashimoto": ["se algum erro recorrente foi encontrado, qual regra do harness deveria existir"]
}
```

### 2. Salvar o arquivo de sessão

Crie o arquivo `.harness/memory/YYYY-MM-DD-[tema].md` com este conteúdo:

```markdown
# Sessão: [tema] — [data]

## Decisões Tomadas
- [decisão 1]
- [decisão 2]

## Tarefas Concluídas
- [x] [tarefa 1]
- [x] [tarefa 2]

## Tarefas Pendentes
- [ ] [tarefa] ← [prioridade]

## Aprendizados
- [aprendizado 1]
- [aprendizado 2]

## Arquivos Modificados
- [arquivo 1]
- [arquivo 2]

## Hashimoto — Melhorias para o Harness
- [se houver: qual regra ou directive deveria ter sido atualizada]

---
*Salvo em: [data] [hora]*
*Próximo passo: abra com `/brief-session` na próxima sessão*
```

### 3. Atualizar last-session.md

Sobrescreva `.harness/memory/last-session.md` com o mesmo conteúdo.
Este arquivo é sempre o ponto de entrada da próxima sessão.

### 4. Aplicar Hashimoto automaticamente

Se a lista `hashimoto` não estiver vazia:
- Para cada item, verifique se a directive correspondente existe em `directives/`
- Se existir, adicione o aprendizado na seção "Aprendizados" da directive
- Se não existir, sugira ao usuário criar com `/create-directive`

### 5. Confirmar para o usuário

Responda com:
```
✅ Sessão salva em .harness/memory/[data]-[tema].md

📋 Resumo:
- [N] decisões tomadas
- [N] tarefas concluídas
- [N] tarefas pendentes
- [N] aprendizados registrados

Para retomar: use /brief-session na próxima sessão
```
