<div align="center">

```
██████╗ ██╗███████╗██████╗  ██████╗ ███████╗████████╗
██╔══██╗██║██╔════╝██╔══██╗██╔═══██╗██╔════╝╚══██╔══╝
██████╔╝██║█████╗  ██████╔╝██║   ██║███████╗   ██║
██╔══██╗██║██╔══╝  ██╔══██╗██║   ██║╚════██║   ██║
██████╔╝██║██║     ██║  ██║╚██████╔╝███████║   ██║
╚═════╝ ╚═╝╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝
```

**Harness Engineering para o mundo real.**
**Um comando. Qualquer runtime. Zero infraestrutura.**

[![npm](https://img.shields.io/npm/v/harness-engineering?style=flat-square&color=000)](https://www.npmjs.com/package/harness-engineering)
[![MIT](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)
[![v2.0.0](https://img.shields.io/badge/versão-2.0.0-purple?style=flat-square)](#changelog)
[![runtimes](https://img.shields.io/badge/runtimes-Claude%20Code%20%7C%20Antigravity%20%7C%20OpenCode-green?style=flat-square)](#compatibilidade)

</div>

---

## O problema que ninguém fala

Você dá uma tarefa ao Claude Code. Ele começa bem — lê arquivos, escreve código, parece produtivo. Depois algo vai errado. Ele pula um passo. Quebra um teste. Diz "feito" mas nada funciona. Você gasta mais tempo limpando do que se tivesse feito você mesmo.

**Isso não é problema do modelo. É problema de harness.**

A Anthropic demonstrou isso em experimento controlado:

```
Mesmo modelo (Opus 4.5) · Mesmo prompt ("build a 2D retro game editor")

❌ Sem harness  →  $9 · 20 minutos · não funcionou
✅ Com harness  →  $200 · 6 horas · jogo jogável e funcional
```

A diferença não foi o modelo. Foi o ambiente ao redor dele.

> *"O gargalo se moveu. Não é mais escrever código.*
> *É validar comportamento, capturar regressões, manter confiabilidade."*

---

## O que é o Bifrost

Na mitologia nórdica, **Bifrost** é a ponte que conecta todos os mundos — a única via que funciona entre qualquer reino.

```
╔══════════════════════════════════════════════════════╗
║                     BIFROST                          ║
║                                                      ║
║   Claude Code  ─────┐                                ║
║   Antigravity  ─────┼──── AGENTS.md ──── seu projeto ║
║   OpenCode     ─────┤     CLAUDE.md                  ║
║   Cursor       ─────┘     GEMINI.md                  ║
║                                                      ║
║   Um harness. Qualquer runtime. Mesmas regras.       ║
╚══════════════════════════════════════════════════════╝
```

**Bifrost** é o único harness que:
- Instala com **um comando** — sem Docker, sem banco de dados, sem servidor
- Funciona em **qualquer runtime** — Claude Code, Antigravity, OpenCode, Cursor
- Implementa os **mesmos princípios** do código-fonte do Claude Code
- Cobre o ciclo completo — **spec → plan → build → review → ship**

```
Prompt Engineering    →  você funciona
Context Engineering   →  você é consistente
Harness Engineering   →  você é confiável em produção
```

---

## Instalação

> Requisito: [Node.js 16+](https://nodejs.org)

```bash
npx harness-engineering
```

O instalador pergunta 6 coisas e configura tudo em menos de 1 minuto.

```bash
npx harness-engineering check                     # verifica integridade
npx harness-engineering skill --bundle essentials # instala skills
npx harness-engineering skill --list              # ver todas disponíveis
```

---

## Arquitetura de 3 Camadas

```
┌────────────────────────────────────────────────────┐
│                  BIFROST v2.0.0                    │
│                                                    │
│  Camada 1 ── directives/                           │
│  SOPs em Markdown: define o QUE fazer              │
│               ↓                                    │
│  Camada 2 ── .harness/doe/                         │
│  Orquestração: COMO o agente age                   │
│  diretrizes · orquestracao · execucao              │
│               ↓                                    │
│  Camada 3 ── execution/                            │
│  Scripts determinísticos: FAZ de forma confiável   │
└────────────────────────────────────────────────────┘
```

> *"Agente = Modelo + Harness.*
> *O modelo raciocina. O harness faz todo o resto."*

---

## Harness não é só para código

O padrão é universal. O que muda entre projetos é o domínio:

```
Agente jurídico     =  modelo + regras CC/2002 + templates  + verificador
Agente financeiro   =  modelo + regras fiscais + schemas    + auditoria
Agente imobiliário  =  modelo + histórico      + contratos  + alertas
Agente educacional  =  modelo + currículo      + progresso  + avaliação
Agente médico       =  modelo + literatura     + protocolos + validação
```

Bifrost vem com 4 domínios prontos e suporte ao ciclo SDLC completo.

---

## Como Usar no Dia a Dia

### Prompt universal — qualquer runtime

```
Leia .harness/index.md e carregue apenas a directive
com match para esta tarefa.

Antes de executar, classifique minha intenção:
pesquisa / implementação / investigação / correção / revisão

Tarefa: [DESCREVA]

Protocolo PEV:
PLAN    → critérios verificáveis antes de qualquer código
EXECUTE → dentro do plano aprovado
VERIFY  → máximo 3 linhas de resposta
```

### Ciclo SDLC completo (Claude Code)

```
/spec    → escreva a spec antes de qualquer código
/plan    → decomponha em tarefas verificáveis
/review  → quality gate em 5 dimensões antes de merge
/ship    → checklist completo antes de deploy
```

### Memória entre sessões

**Claude Code:**
```
/wrap-session          ← encerra e salva contexto
/brief-session         ← retoma de onde parou
/context-check         ← audita e comprime se necessário
/model-select          ← recomenda modelo certo para a tarefa
```

**Antigravity / OpenCode / outros:**
```
# Encerrar
Leia directives/session-memory.md e salve em .harness/memory/last-session.md

# Retomar
Leia .harness/memory/last-session.md e me dê um briefing
```

**Trocar de runtime sem perder contexto:**
1. Salve com `/wrap-session`
2. No novo runtime: `Leia .harness/memory/last-session.md e me dê um briefing`

---

## Economia de Tokens

Bifrost corta **50–70% do consumo** com cinco técnicas:

```
┌──────────────────────────────────────────────────────┐
│ 1. Lazy Loading                                      │
│    .harness/index.md → carrega só a directive certa  │
│    15k → 3k tokens                    ▓▓░░░░ -80%   │
├──────────────────────────────────────────────────────┤
│ 2. Progressive Disclosure                            │
│    grep -n "fn" arquivo.ts  em vez de cat inteiro    │
│                                       ▓▓░░░░ -70%   │
├──────────────────────────────────────────────────────┤
│ 3. Observation Masking                               │
│    [Logs — 847 linhas | FALHA | timeout linha 42]    │
│                                       ▓▓▓░░ -52%    │
├──────────────────────────────────────────────────────┤
│ 4. Roteamento de Modelos                             │
│    Docs/testes  → Haiku   (até -95% de custo)        │
│    Código       → Sonnet  (equilíbrio)               │
│    Arquitetura  → Opus    (quando necessário)        │
├──────────────────────────────────────────────────────┤
│ 5. Compressão de Histórico (após 8 turnos)           │
│    python execution/compress-history.py --auto       │
│    Claude Code: /context-check --compress            │
└──────────────────────────────────────────────────────┘
```

---

## Princípios Karpathy

Derivados das observações de **Andrej Karpathy** (ex-diretor de IA da Tesla, ex-OpenAI) sobre como LLMs falham na prática. Integrados ao `AGENTS.md` do Bifrost:

```
1. Declare suposições antes de agir
   Múltiplas interpretações? Apresente todas — nunca escolha silenciosamente.
   Algo não está claro? Pare. Nomeie a confusão. Pergunte.

2. Código mínimo — nada especulativo
   Sem features além do pedido. Sem abstrações desnecessárias.
   Escreveu 200 linhas e poderiam ser 50? Reescreva.

3. Mudanças cirúrgicas — toque só o que deve
   Não melhore código que não está quebrado.
   Não apague código que não foi você quem tornou obsoleto.
   Cada linha mudada deve ter rastreabilidade ao pedido.

4. Transforme tarefas em critérios verificáveis
   "Corrija o bug"      → "Escreva teste que reproduz, faça passar"
   "Adicione validação" → "Testes para inputs inválidos, faça passar"
   "Refatore X"         → "Testes passam antes e depois"
```

> *"LLMs são excepcionalmente bons em fazer loops até atingir critérios específicos.*
> *Não diga o que fazer — dê critérios de sucesso e deixe ir."*

---

## Quality Gate

O pre-commit hook bloqueia automaticamente — e sincroniza espelhos quando `AGENTS.md` muda:

| Verificação | O que bloqueia |
|-------------|----------------|
| 🔑 Segredos | passwords, api_keys, tokens hardcoded |
| 📝 `console.log` | logs soltos em JS/TS |
| ⚠️ TypeScript `any` | sem `// harness-ignore` |
| 💰 Float monetário | valores em ponto flutuante |
| 🔒 `.env` | commit sem ser `.example` |
| 🛡️ Protected paths | definidos em `.harness/config.json` |
| 🔄 Auto-sync | AGENTS.md mudou → CLAUDE.md + GEMINI.md atualizados |

```json
// .harness/config.json
{
  "protected_paths": [".env", "secrets/", "terraform/", "*.pem"],
  "allowed_paths":   ["src/", "app/", "directives/", "docs/"]
}
```

---

## Regra de Hashimoto

> *Cada bug que não vira regra do harness é um bug que vai acontecer de novo.*

```
1. Corrija o código
2. Identifique onde o harness falhou em prevenir
3. Atualize a directive correspondente
4. Se verificável → atualize o pre-commit hook
5. Commit: harness(tipo): descrição
```

---

## O que está instalado

```
seu-projeto/
├── AGENTS.md · CLAUDE.md · GEMINI.md
│
├── directives/
│   ├── session-memory.md       ← memória entre sessões
│   ├── context-management.md   ← 3 estratégias de compressão
│   ├── observation-masking.md  ← outputs longos → placeholder
│   ├── subagent-dispatch.md    ← tarefas > 20k tokens
│   ├── harness-evolution.md    ← Hashimoto + Intent Gate
│   ├── diagnose.md             ← investigação sistemática
│   └── spec-driven.md          ← spec antes de código
│
├── execution/
│   └── compress-history.py     ← compressor determinístico
│
├── agents/
│   ├── code-reviewer.md        ← revisor em 5 dimensões
│   └── security-auditor.md     ← auditor OWASP + LGPD
│
├── scripts/
│   └── sync-mirrors.sh         ← auto-sync AGENTS→CLAUDE→GEMINI
│
├── .harness/
│   ├── index.md                ← lazy loading central
│   ├── config.json             ← protected/allowed paths
│   ├── config.schema.json      ← schema JSON formal
│   ├── doe/                    ← Camada 2: orquestração
│   │   ├── diretrizes.md
│   │   ├── orquestracao.md
│   │   └── execucao.md
│   ├── domains/                ← regras por domínio (4)
│   ├── skills/                 ← skills instaladas
│   ├── memory/                 ← histórico de sessões
│   └── quality-gates/pre-commit
│
└── .claude/commands/
    ├── spec.md · plan.md · review.md · ship.md
    ├── wrap-session.md · brief-session.md
    ├── context-check.md · model-select.md
```

---

## Skills — Bundles disponíveis

```bash
npx harness-engineering skill --bundle essentials  # brainstorming, debug, docs
npx harness-engineering skill --bundle saas        # produto web completo
npx harness-engineering skill --bundle api         # APIs e backends
npx harness-engineering skill --bundle security    # segurança e auditoria
npx harness-engineering skill --bundle automation  # scripts e pipelines
npx harness-engineering skill --bundle ai          # projetos com IA
npx harness-engineering skill --bundle sdlc        # ciclo completo de entrega
npx harness-engineering skill --list               # ver todas disponíveis
```

---

## Compatibilidade

| Runtime | Arquivo | Lazy Loading | Memória | SDLC | Tokens |
|---------|---------|-------------|---------|------|--------|
| Claude Code | `CLAUDE.md` | `index.md` | `/wrap-session` | `/spec /plan /review /ship` | `/context-check` |
| Antigravity | `GEMINI.md` | `index.md` | manual | prompt direto | script Python |
| OpenCode | `AGENTS.md` | `index.md` | manual | prompt direto | script Python |
| Cursor | `.cursorrules` | `index.md` | manual | prompt direto | — |

---

## Changelog

### v2.0.0
- ✨ Camada 2 (`.harness/doe/`) visível e documentada na arquitetura
- ✨ Intent Gate — classifica intenção antes de executar
- ✨ **Princípios Karpathy** integrados ao `AGENTS.md` e README
- ✨ Tabela de Frases Proibidas (fillers que desperdiçam tokens)
- ✨ Ciclo SDLC completo: `/spec` · `/plan` · `/review` · `/ship`
- ✨ Anti-rationalization tables em todas as directives
- ✨ `directives/diagnose.md` — investigação sistemática de falhas
- ✨ `directives/spec-driven.md` — spec antes de código
- ✨ `agents/code-reviewer.md` + `agents/security-auditor.md`
- ✨ `.harness/config.schema.json` — schema JSON formal
- ✨ `scripts/sync-mirrors.sh` — auto-sync dos espelhos
- ✨ `cli.js` v2.0.0 — todos os arquivos incluídos na instalação
- 🔄 `directives/session-memory.md` — hooks automáticos
- 🔄 `directives/context-management.md` — 3 estratégias de compressão
- 🔄 `.harness/index.md` — todas as directives indexadas

### v1.4.0
- ✨ Nome: Bifrost · README com visual nórdico
- ✨ `.harness/config.json` — protected/allowed paths
- ✨ `directives/harness-evolution.md`
- ✨ `sync-mirrors.sh`

### v1.3.0
- ✨ Progressive Disclosure · Observation Masking
- ✨ Roteamento de Modelos · Sub-agentes
- ✨ `/model-select`

### v1.2.0
- ✨ Lazy loading · Output conciso · Budget por tarefa
- ✨ `compress-history.py` · `/context-check`

### v1.1.0
- ✨ Memória persistente · `/wrap-session` · `/brief-session`

### v1.0.0
- Estrutura base · DOE · PEV · 4 domínios · quality gate · npm

---

## Princípios

```
 1. Agente = Modelo + Harness
 2. Marcha dos Noves — o harness resolve
 3. Directives são documentos vivos
 4. Scripts determinísticos > agente improvisando
 5. Verificador com contexto limpo
 6. Sucesso silencioso, falha barulhenta
 7. Hashimoto — cada erro melhora o harness
 8. Memória persistente          · v1.1.0
 9. Contexto mínimo necessário   · v1.2.0
10. Modelo certo para cada tarefa · v1.3.0
11. Intenção antes de execução    · v2.0.0
12. Spec antes de código          · v2.0.0
```

---

## Licença

MIT — use, modifique, distribua, contribua.

---

<div align="center">

*Na mitologia nórdica, Bifrost é a ponte que conecta todos os mundos.*
*Aqui, conecta seus projetos a qualquer agente de IA.*

**[⭐ Star no GitHub](https://github.com/JRoberto1/Bifrost_Harness-Engineering) · [📦 npm](https://www.npmjs.com/package/harness-engineering)**

</div>
