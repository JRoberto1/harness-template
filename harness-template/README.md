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

---

## Como Usar no Dia a Dia

### Prompt universal (todos os runtimes)

```
Leia .harness/index.md e carregue apenas a directive com match para esta tarefa.

Tarefa: [DESCREVA]

Siga o Protocolo PEV:
1. PLAN — critérios verificáveis antes de qualquer código
2. EXECUTE — dentro do plano aprovado, lendo arquivos incrementalmente
3. VERIFY — máximo 3 linhas de resposta; use masking em outputs longos
```

---

## Economia de Contexto *(v1.2.0 + v1.3.0)*

O harness implementa 5 técnicas que juntas cortam **50-70% do consumo de tokens**:

### 1. Lazy Loading de Directives *(v1.2.0)*

O agente lê `.harness/index.md` (arquivo leve) e carrega **só** a directive relevante.

```
Antes:  todos os arquivos = 15k tokens
Depois: index.md + 1 directive = 3k tokens
```

### 2. Progressive Disclosure *(v1.3.0)*

Em vez de carregar arquivos inteiros, o agente lê só o necessário:

```bash
# Em vez de cat arquivo-inteiro.ts
grep -n "função relevante" src/services/auth.ts
head -50 src/services/auth.ts
```

### 3. Observation Masking *(v1.3.0)*

Outputs longos (logs, testes, stack traces) são substituídos por placeholders:

```
[Logs omitidos — 847 linhas | Resultado: FALHA | Erro: timeout na linha 42]
[Testes omitidos — 47 testes | Status: 46 PASS, 1 FALHA: 'valor em float']
```

**52% mais barato** que pedir ao modelo para sumarizar.

### 4. Roteamento de Modelos *(v1.3.0)*

| Tarefa | Modelo | Economia |
|--------|--------|---------|
| Docs, testes simples, formatação | Haiku / Mini | até 95% |
| Código, implementação | Sonnet / padrão | até 80% |
| Arquitetura, debugging difícil | Opus / Pro | — |

**Claude Code:** `/model-select` antes de iniciar.
**Outros runtimes:** consulte a tabela no `AGENTS.md`.

### 5. Sub-agentes para Tarefas Pesadas *(v1.3.0)*

Tarefas > 20k tokens são delegadas a sub-agentes isolados.
Retornam apenas um resumo de 1.000-2.000 tokens para o agente principal.

```
Directive: directives/subagent-dispatch.md
```

### 6. Compressão de Histórico *(v1.2.0)*

```bash
python execution/compress-history.py --auto
```

**Claude Code:** `/context-check --compress`

---

## Memória Persistente *(v1.1.0)*

**Claude Code:**
```
/wrap-session       ← encerra e salva
/brief-session      ← retoma sessão anterior
```

**Outros runtimes:**
```
# Encerrar
Leia directives/session-memory.md e salve o contexto em
.harness/memory/last-session.md

# Retomar
Leia .harness/memory/last-session.md e me dê um briefing
```

### Trocar de runtime sem perder contexto

1. Salve com `/wrap-session` ou equivalente
2. No novo runtime: `Leia .harness/memory/last-session.md e me dê um briefing`

---

## Estrutura

```
seu-projeto/
│
├── AGENTS.md / CLAUDE.md / GEMINI.md
│
├── directives/
│   ├── session-memory.md          ← v1.1.0
│   ├── context-management.md      ← v1.2.0
│   ├── subagent-dispatch.md       ← v1.3.0
│   └── observation-masking.md     ← v1.3.0
│
├── execution/
│   ├── SCRIPT-template.py
│   └── compress-history.py        ← v1.2.0
│
├── .harness/
│   ├── index.md                   ← v1.2.0 (atualizado v1.3.0)
│   ├── domains/
│   ├── skills/
│   ├── memory/                    ← v1.1.0
│   └── quality-gates/
│
└── .claude/commands/
    ├── wrap-session.md             ← v1.1.0
    ├── brief-session.md            ← v1.1.0
    ├── context-check.md            ← v1.2.0
    ├── model-select.md             ← v1.3.0
    ├── fetch-skills.md
    ├── harness-check.md
    └── create-directive.md
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

| Runtime | Arquivo | Lazy Loading | Memória | Masking | Roteamento |
|---------|---------|-------------|---------|---------|-----------|
| Claude Code | `CLAUDE.md` | `index.md` | `/wrap-session` | automático | `/model-select` |
| Antigravity | `GEMINI.md` | `index.md` | manual | manual | tabela AGENTS.md |
| OpenCode | `AGENTS.md` | `index.md` | manual | manual | tabela AGENTS.md |
| Cursor | `.cursorrules` | `index.md` | manual | manual | tabela AGENTS.md |

---

## Integração com GSD

```bash
npx get-shit-done-cc@latest
```

---

## Changelog

### v1.3.0
- ✨ Progressive Disclosure — leitura incremental de arquivos
- ✨ Observation Masking — placeholders para outputs longos (52% mais barato)
- ✨ Roteamento de Modelos — tabela Haiku/Sonnet/Opus por tipo de tarefa
- ✨ Sub-agentes — critério e directive para delegar tarefas > 20k tokens
- ✨ Comando `/model-select` para Claude Code
- ✨ `directives/subagent-dispatch.md`
- ✨ `directives/observation-masking.md`
- 🔄 `.harness/index.md` atualizado com novas directives

### v1.2.0
- ✨ Lazy loading via `.harness/index.md`
- ✨ Protocolo de output conciso
- ✨ Budget por tipo de tarefa
- ✨ `execution/compress-history.py`
- ✨ `directives/context-management.md`
- ✨ Comando `/context-check`

### v1.1.0
- ✨ Memória persistente entre sessões
- ✨ Comandos `/wrap-session` e `/brief-session`
- ✨ `directives/session-memory.md`

### v1.0.0
- Estrutura base completa
- Framework DOE · Ciclo PEV · 4 domínios
- Quality gate · CI · `npx harness-engineering`

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
10. **Modelo certo para cada tarefa** *(v1.3.0)*

---

## Licença

MIT — use, modifique e distribua livremente.
