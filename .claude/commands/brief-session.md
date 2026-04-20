# /brief-session — Iniciar Sessão Retomando Contexto

Inicia a sessão de trabalho lendo o contexto da última sessão salva,
sem precisar reexplicar o projeto do zero.

## Como usar

```
/brief-session
/brief-session autenticacao-jwt
/brief-session 2026-04-20
```

## Instruções para o Agente

Ao receber este comando, execute **na ordem**:

### 1. Ler o contexto

**Se foi passado um tema ou data específica:**
Procure o arquivo correspondente em `.harness/memory/`.

**Se não foi passado nada:**
Leia `.harness/memory/last-session.md`.

**Se `.harness/memory/` estiver vazio ou não existir:**
Responda: "Nenhuma sessão anterior encontrada. Lerei o AGENTS.md e docs/ para
entender o projeto." E faça isso.

### 2. Ler os arquivos do harness

Sempre leia também:
- `AGENTS.md` — regras e identidade do projeto
- `docs/architecture.md` — stack atual
- `docs/domain-rules.md` — regras de negócio

### 3. Apresentar o briefing

Responda com este formato:

```
📖 Briefing da Sessão Anterior — [data] · [tema]

✅ Concluído
- [tarefa concluída 1]
- [tarefa concluída 2]

🔄 Em Andamento / Pendente
- [ ] [tarefa pendente 1] ← [prioridade]
- [ ] [tarefa pendente 2] ← [prioridade]

💡 Aprendizados Registrados
- [aprendizado relevante para esta sessão]

📁 Últimos Arquivos Modificados
- [arquivo 1]

---
Pronto para continuar. Qual tarefa pendente quer atacar primeiro?
```

### 4. Aguardar instrução

Não execute nada além do briefing. Aguarde o usuário escolher o próximo passo.
