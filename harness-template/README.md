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

> Requisito: [Node.js](https://nodejs.org) instalado (versão 16+).

```bash
npx harness-engineering
```

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

O instalador detecta o projeto existente, faz backup do que precisar
substituir e gera um relatório com os próximos passos.

---

## Como Usar no Dia a Dia

### Iniciar qualquer tarefa

```
Leia .harness/index.md e carregue apenas a directive com match para esta tarefa.

Tarefa: [DESCREVA]

Siga o Protocolo PEV:
1. PLAN — critérios verificáveis antes de qualquer código
2. EXECUTE — dentro do plano aprovado
3. VERIFY — confirme cada critério; máximo 3 linhas de resposta
```

### Instalar skills

```bash
npx harness-engineering skill --bundle essentials
npx harness-engineering skill --bundle saas
npx harness-engineering skill --bundle api
npx harness-engineering skill --bundle security
npx harness-engineering skill --bundle ai
npx harness-engineering skill brainstorming
npx harness-engineering skill --list
```

---

## Economia de Contexto *(v1.2.0)*

O maior custo em projetos com IA não é o modelo — é o **desperdício de tokens**.
A v1.2.0 corta 35-50% do consumo com três mudanças:

### 1. Lazy Loading de Directives

Em vez de carregar todas as directives, o agente lê `.harness/index.md`
(arquivo leve com 1-2 linhas por directive) e carrega **apenas** a que
tem match com a tarefa atual.

```
Antes:  AGENTS.md + saas.md + api.md + juridico.md + automation.md = 15k tokens
Depois: AGENTS.md + index.md + directive-relevante.md = 5k tokens
```

### 2. Regras de Output Conciso

Definidas no `AGENTS.md` e aplicadas em **qualquer runtime**:

| Situação | Antes | Depois |
|----------|-------|--------|
| Sucesso | 2 parágrafos explicando o que foi feito | "✓ feito" |
| Erro | Análise longa do problema | `ERRO:` / `CAUSA:` / `AÇÃO:` |
| Progresso | "Estou fazendo X como você pediu..." | Uma linha por etapa |

### 3. Compressão de Histórico

Após 8 turnos, o script determinístico comprime o histórico:

```bash
python execution/compress-history.py --auto
```

Mantém: decisões, estado atual, erros relevantes.
Descarta: raciocínio intermediário, confirmações verbosas, repetições.

**Claude Code:** use `/context-check --compress`
**Outros runtimes:** rode o script diretamente ou peça ao agente para resumir

---

## Memória Persistente entre Sessões *(v1.1.0)*

### Encerrar sessão

**Claude Code:**
```
/wrap-session
/wrap-session nome-da-tarefa
```

**Antigravity / OpenCode / outros:**
```
Leia directives/session-memory.md e encerre a sessão
salvando o contexto em .harness/memory/last-session.md
```

### Retomar sessão

**Claude Code:**
```
/brief-session
```

**Antigravity / OpenCode / outros:**
```
Leia .harness/memory/last-session.md e me dê um briefing
antes de começar qualquer coisa
```

### Trocar de runtime sem perder contexto

1. No runtime atual: salve com `/wrap-session` ou equivalente
2. No novo runtime: `Leia .harness/memory/last-session.md e me dê um briefing`

---

## Estrutura

```
seu-projeto/
│
├── AGENTS.md / CLAUDE.md / GEMINI.md
│
├── directives/
│   ├── DIRECTIVE-template.md
│   ├── session-memory.md        ← v1.1.0
│   └── context-management.md   ← v1.2.0
│
├── execution/
│   ├── SCRIPT-template.py
│   └── compress-history.py      ← v1.2.0
│
├── .harness/
│   ├── index.md                 ← v1.2.0: lazy loading central
│   ├── domains/
│   ├── skills/
│   ├── doe/
│   ├── pev/
│   ├── memory/                  ← v1.1.0
│   │   ├── INDEX.md
│   │   └── last-session.md
│   └── quality-gates/
│
├── .claude/commands/
│   ├── wrap-session.md          ← v1.1.0
│   ├── brief-session.md         ← v1.1.0
│   ├── context-check.md         ← v1.2.0
│   ├── fetch-skills.md
│   ├── harness-check.md
│   └── create-directive.md
│
└── docs/
    ├── architecture.md
    ├── domain-rules.md
    └── coding-standards.md
```

---

## Quality Gate

| Verificação | O que bloqueia |
|-------------|----------------|
| Segredos | passwords, api_keys, tokens hardcoded |
| `console.log` | logs soltos em JS/TS |
| TypeScript `any` | sem `// harness-ignore` |
| Valores float | monetários em ponto flutuante |
| Arquivos `.env` | commit sem ser `.example` |

---

## Regra de Hashimoto

1. Corrija o código
2. Atualize a directive com o aprendizado
3. Se verificável → atualize o pre-commit hook
4. Se regra de negócio → atualize o arquivo de domínio
5. Commit: `harness(quality-gate): [descrição]`

---

## Compatibilidade

| Runtime | Arquivo lido | Lazy Loading | Memória | Compressão |
|---------|-------------|-------------|---------|-----------|
| Claude Code | `CLAUDE.md` | `.harness/index.md` | `/wrap-session` | `/context-check` |
| Antigravity | `GEMINI.md` | `.harness/index.md` | manual | script Python |
| OpenCode | `AGENTS.md` | `.harness/index.md` | manual | script Python |
| Cursor | `.cursorrules` | `.harness/index.md` | manual | script Python |

---

## Integração com GSD

```bash
npx get-shit-done-cc@latest
# O GSD lê o AGENTS.md automaticamente
```

---

## Changelog

### v1.2.0
- ✨ Lazy loading via `.harness/index.md` — carrega só o necessário
- ✨ Protocolo de output conciso no `AGENTS.md` — 35-50% menos tokens
- ✨ Budget por tipo de tarefa no `AGENTS.md`
- ✨ `execution/compress-history.py` — compressão determinística
- ✨ `directives/context-management.md` — SOP de gestão de tokens
- ✨ Comando `/context-check` para Claude Code

### v1.1.0
- ✨ Memória persistente entre sessões
- ✨ Comandos `/wrap-session` e `/brief-session`
- ✨ `directives/session-memory.md`

### v1.0.0
- Estrutura base: AGENTS.md · CLAUDE.md · GEMINI.md
- Framework DOE · Ciclo PEV · 4 domínios
- Quality gate · CI · Scripts de instalação
- `npx harness-engineering`

---

## Princípios

1. **Agente = Modelo + Harness**
2. **Marcha dos Noves** — o harness resolve
3. **Directives são documentos vivos**
4. **Scripts determinísticos > agente improvisando**
5. **Verificador com contexto limpo**
6. **Sucesso silencioso, falha barulhenta**
7. **Hashimoto** — cada erro melhora o harness
8. **Memória persistente** *(v1.1.0)*
9. **Contexto mínimo necessário** *(v1.2.0)*

---

## Licença

MIT — use, modifique e distribua livremente.
