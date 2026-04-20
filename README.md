# Harness Engineering — Template Universal

> Sistema de harness para projetos de IA.
> Funciona com **Claude Code · Antigravity · OpenCode · Cursor · Copilot**.

---

## O que é isso

Um template que você instala em qualquer projeto com um comando.
Implementa os princípios de **Harness Engineering** — a camada que transforma
um modelo probabilístico em um sistema confiável em produção.

```
┌─────────────────────────────────────────────┐
│                  HARNESS                    │
│  ┌───────────────────────────────────────┐  │
│  │           AGENTE (você)               │  │
│  │  ┌────────────┐  ┌────────────────┐   │  │
│  │  │   SKILLS   │  │  DIRECTIVES    │   │  │
│  │  │ (como      │  │ (o que fazer)  │   │  │
│  │  │  fazer)    │  │                │   │  │
│  │  └────────────┘  └────────────────┘   │  │
│  │  ┌─────────────────────────────────┐  │  │
│  │  │   EXECUTION (scripts det.)      │  │  │
│  │  └─────────────────────────────────┘  │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

**Prompt Engineering** → você funciona.
**Context Engineering** → você é consistente.
**Harness Engineering** → você é confiável em produção.

---

## Instalação

> Requisito: [Node.js](https://nodejs.org) instalado (versão 16 ou superior).

```bash
npx harness-engineering
```

O instalador pergunta o nome do projeto, a stack e os domínios ativos.
Em menos de 1 minuto tudo está configurado.

### Verificar

```bash
npx harness-engineering check
```

---

## Projeto Novo vs Projeto Existente

### Projeto novo

```bash
mkdir meu-projeto && cd meu-projeto
git init
npx harness-engineering
npx harness-engineering skill --bundle essentials
```

### Projeto existente

```bash
cd meu-projeto-existente
npx harness-engineering
```

O instalador detecta que o projeto já existe e faz a adoção sem sobrescrever nada —
faz backup de qualquer arquivo que precisar substituir e gera um relatório
com os próximos passos específicos para o seu projeto.

---

## Como Usar no Dia a Dia

### Iniciar qualquer tarefa

```
Leia o AGENTS.md e os domínios ativos em .harness/domains/.

Tarefa: [DESCREVA O QUE QUER FAZER]

Siga o Protocolo PEV:
1. Apresente o PLAN com critérios verificáveis antes de qualquer código
2. Execute dentro do plano aprovado
3. Verifique cada critério antes de encerrar
```

### Instalar skills adicionais

```bash
npx harness-engineering skill --bundle essentials  # para todos os projetos
npx harness-engineering skill --bundle saas        # produtos web
npx harness-engineering skill --bundle api         # APIs e backends
npx harness-engineering skill --bundle security    # segurança
npx harness-engineering skill --bundle ai          # projetos com IA
npx harness-engineering skill brainstorming        # skill específica
npx harness-engineering skill --list               # ver todas
```

---

## Memória Persistente entre Sessões *(v1.1.0)*

O maior problema com agentes de IA é que **cada sessão começa do zero**.
O harness resolve isso com dois comandos nativos do Claude Code:

### Encerrar sessão

```
/wrap-session
/wrap-session autenticacao-jwt
```

O agente resume automaticamente:
- Decisões tomadas
- Tarefas concluídas e pendentes
- Aprendizados não óbvios
- Aplicação da Regra de Hashimoto

Tudo salvo em `.harness/memory/YYYY-MM-DD-[tema].md`

### Iniciar próxima sessão

```
/brief-session
```

O agente lê a última sessão salva e apresenta um briefing resumido
antes de fazer qualquer coisa. Você retoma exatamente de onde parou.

### Trocar de runtime sem perder contexto

Quando trocar do Claude Code para o Antigravity (ou qualquer outro runtime):

**1. Antes de sair — no Claude Code:**
```
/wrap-session
```

**2. No novo runtime — Antigravity, OpenCode, etc.:**
```
Leia o GEMINI.md e em seguida .harness/memory/last-session.md
para entender o contexto e onde paramos.
Apresente um briefing e aguarde minha instrução.
```

O `last-session.md` funciona como memória universal — qualquer runtime consegue ler.

---

## Estrutura instalada

```
seu-projeto/
│
├── AGENTS.md          ← núcleo do harness (lido por todos os runtimes)
├── CLAUDE.md          ← espelho para Claude Code
├── GEMINI.md          ← espelho para Antigravity
│
├── directives/        ← SOPs: define O QUE o agente deve fazer
│   └── session-memory.md  ← ✨ novo: fluxo de memória entre sessões
│
├── execution/         ← scripts determinísticos
│
├── .harness/
│   ├── domains/       ← regras por domínio
│   ├── skills/        ← skills instaladas
│   ├── doe/           ← templates de prompt
│   ├── pev/           ← ciclo Plan · Execute · Verify
│   ├── memory/        ← ✨ novo: histórico de sessões
│   │   ├── INDEX.md
│   │   └── last-session.md
│   └── quality-gates/ ← hooks de verificação
│
├── .claude/
│   └── commands/
│       ├── wrap-session.md   ← ✨ novo: /wrap-session
│       ├── brief-session.md  ← ✨ novo: /brief-session
│       ├── fetch-skills.md
│       ├── harness-check.md
│       └── create-directive.md
│
└── docs/
    ├── architecture.md
    ├── domain-rules.md
    └── coding-standards.md
```

---

## Quality Gate

O pre-commit hook bloqueia automaticamente:

| Verificação | O que bloqueia |
|-------------|----------------|
| Segredos | passwords, api_keys, tokens hardcoded |
| `console.log` | logs soltos em JS/TS |
| TypeScript `any` | sem `// harness-ignore` |
| Valores float | monetários em ponto flutuante |
| Arquivos `.env` | commit sem ser `.example` |

---

## Regra de Hashimoto

Quando o agente cometer um erro, não basta corrigir o código.
Atualize o harness para que aquele erro nunca mais aconteça:

1. Corrija o código
2. Atualize a **directive** com o aprendizado
3. Se verificável → atualize o **pre-commit hook**
4. Se for regra de negócio → atualize o **arquivo de domínio**
5. Commit: `harness(quality-gate): [descrição]`

> Cada bug que não vira regra do harness é um bug que vai acontecer de novo.

---

## Compatibilidade de Runtimes

| Runtime | Arquivo lido | Memória de sessão |
|---------|-------------|------------------|
| Claude Code | `CLAUDE.md` | `/wrap-session` + `/brief-session` |
| Antigravity | `GEMINI.md` | leia `last-session.md` manualmente |
| OpenCode | `AGENTS.md` | leia `last-session.md` manualmente |
| Cursor | `.cursorrules` | leia `last-session.md` manualmente |

---

## Integração com GSD (opcional)

| Camada | Responsabilidade |
|--------|-----------------|
| **Harness** | Regras, domínios, directives, quality gates, memória |
| **GSD** | Execução: planejamento, waves paralelas, commits atômicos |

```bash
npx get-shit-done-cc@latest
```

---

## Changelog

### v1.1.0
- ✨ Memória persistente entre sessões (`.harness/memory/`)
- ✨ Comando `/wrap-session` — encerra sessão e salva contexto
- ✨ Comando `/brief-session` — retoma sessão anterior
- ✨ Directive `session-memory.md` — SOP de continuidade
- ✨ Suporte a troca de runtime sem perda de contexto

### v1.0.0
- Estrutura base: AGENTS.md · CLAUDE.md · GEMINI.md
- Framework DOE · Ciclo PEV
- 4 domínios: saas, api, automation, juridico-financeiro
- Quality gate pre-commit · CI GitHub Actions
- Scripts: init-project, health-check, fetch-skill, adopt-project
- Instalador npm: `npx harness-engineering`

---

## Princípios

1. **Agente = Modelo + Harness** — LLM sem harness é chatbot, não agente
2. **Marcha dos Noves** — 90% por etapa × 10 etapas = 35% de sucesso
3. **Directives são documentos vivos** — atualize sempre que aprender algo novo
4. **Scripts determinísticos > agente improvisando**
5. **Verificador com contexto limpo** — agente não audita o próprio trabalho
6. **Sucesso silencioso, falha barulhenta**
7. **Hashimoto** — cada erro vira melhoria permanente no harness
8. **Memória persistente** *(v1.1.0)* — cada sessão começa de onde a anterior parou

---

## Licença

MIT — use, modifique e distribua livremente.
