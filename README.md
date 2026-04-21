<div align="center">

```
        ╔══════════════════════════════════════════════════════════╗
        ║                                                          ║
        ║          ██████╗ ██╗███████╗██████╗  ██████╗ ███████╗████████╗  ║
        ║          ██╔══██╗██║██╔════╝██╔══██╗██╔═══██╗██╔════╝╚══██╔══╝  ║
        ║          ██████╔╝██║█████╗  ██████╔╝██║   ██║███████╗   ██║     ║
        ║          ██╔══██╗██║██╔══╝  ██╔══██╗██║   ██║╚════██║   ██║     ║
        ║          ██████╔╝██║██║     ██║  ██║╚██████╔╝███████║   ██║     ║
        ║          ╚═════╝ ╚═╝╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝     ║
        ║                                                          ║
        ║         A ponte entre seus projetos e qualquer agente    ║
        ╚══════════════════════════════════════════════════════════╝
```

**Harness Engineering para o mundo real.**
**Um comando. Qualquer runtime. Zero infraestrutura.**

[![npm version](https://img.shields.io/npm/v/harness-engineering?style=flat-square&color=000)](https://www.npmjs.com/package/harness-engineering)
[![MIT License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)
[![Works with](https://img.shields.io/badge/works%20with-Claude%20Code%20%7C%20Antigravity%20%7C%20OpenCode-purple?style=flat-square)](#compatibilidade)

</div>

---

## O problema que ninguém fala

Você dá uma tarefa ao Claude Code. Ele começa bem — lê arquivos, escreve código, parece produtivo. Depois algo vai errado. Ele pula um passo. Quebra um teste. Diz "feito" mas nada funciona. Você gasta mais tempo limpando do que se tivesse feito você mesmo.

**Isso não é problema do modelo. É problema de harness.**

A Anthropic demonstrou isso em um experimento controlado:

```
Mesmo modelo (Opus 4.5)
Mesmo prompt ("construa um editor de jogos 2D retro")

❌ Sem harness  →  $9 · 20 minutos · não funcionou
✅ Com harness  →  $200 · 6 horas · jogo jogável
```

A diferença não foi o modelo. Foi o ambiente ao redor dele.

---

## O que é Bifrost

Na mitologia nórdica, **Bifrost** é a ponte que conecta todos os mundos — a única via que funciona entre qualquer reino.

```
╔═══════════════════════════════════════════════════════════════╗
║                        BIFROST                                ║
║                                                               ║
║   Claude Code ──────┐                                         ║
║   Antigravity ──────┤──── AGENTS.md ──── seu projeto          ║
║   OpenCode    ──────┤     CLAUDE.md                           ║
║   Cursor      ──────┘     GEMINI.md                           ║
║                                                               ║
║   Um harness. Qualquer runtime. Mesmas regras.                ║
╚═══════════════════════════════════════════════════════════════╝
```

Bifrost é o harness que transforma um modelo probabilístico em um sistema confiável em produção — **sem precisar de Docker, banco de dados, Python runtime ou qualquer infraestrutura extra.**

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

Isso é tudo. O instalador pergunta 6 coisas e configura tudo em menos de 1 minuto.

```bash
# Verificar
npx harness-engineering check

# Instalar skills
npx harness-engineering skill --bundle essentials

# Ver todas as opções
npx harness-engineering skill --list
```

---

## Projeto Novo vs Projeto Existente

### Projeto novo

```bash
mkdir meu-projeto && cd meu-projeto
git init
npx harness-engineering
```

### Projeto existente (já tem código)

```bash
cd meu-projeto-existente
npx harness-engineering
```

O instalador detecta o projeto existente automaticamente:
- ✓ Detecta sua stack (Node, Python, Next.js, etc.)
- ✓ Faz backup antes de qualquer substituição
- ✓ Não sobrescreve nada sem avisar
- ✓ Gera relatório `.harness-adoption-report.md` com próximos passos

---

## O que é instalado

```
seu-projeto/
│
├── AGENTS.md          ← núcleo do harness
├── CLAUDE.md          ← espelho para Claude Code
├── GEMINI.md          ← espelho para Antigravity
│
├── directives/        ← Camada 1: SOPs — o QUE fazer
│   ├── session-memory.md
│   ├── context-management.md
│   ├── observation-masking.md
│   ├── subagent-dispatch.md
│   └── harness-evolution.md    ← novo v1.4.0
│
├── execution/         ← Camada 3: scripts determinísticos
│   └── compress-history.py
│
├── .harness/
│   ├── index.md               ← lazy loading central
│   ├── config.json            ← novo v1.4.0: protected paths
│   ├── domains/               ← regras por domínio
│   ├── skills/                ← skills instaladas
│   ├── memory/                ← histórico de sessões
│   └── quality-gates/         ← pre-commit hook
│
└── .claude/commands/
    ├── wrap-session.md
    ├── brief-session.md
    ├── context-check.md
    └── model-select.md
```

---

## Harness não é só para código

O padrão é universal. O que muda entre projetos é o domínio — a estrutura é sempre a mesma:

```
Agente jurídico     =  modelo  +  regras CC/2002  +  templates  +  verificador
Agente imobiliário  =  modelo  +  histórico        +  contratos  +  alertas
Agente financeiro   =  modelo  +  regras fiscais   +  schemas    +  auditoria
Agente médico       =  modelo  +  literatura       +  protocolos +  validação
Agente educacional  =  modelo  +  currículo        +  progresso  +  avaliação
```

Bifrost vem com 4 domínios prontos:

| Domínio | Ativa quando |
|---------|-------------|
| `saas.md` | produto web, autenticação, UI |
| `api.md` | endpoints, REST, backend |
| `automation.md` | scripts, ETL, pipelines |
| `juridico-financeiro.md` | contratos, LGPD, valores monetários |

---

## Como Usar no Dia a Dia

### Prompt universal — funciona em qualquer runtime

```
Leia .harness/index.md e carregue apenas a directive
com match para esta tarefa.

Tarefa: [DESCREVA]

Antes de executar, classifique minha intenção:
pesquisa / implementação / investigação / correção

Siga o Protocolo PEV:
1. PLAN — critérios verificáveis antes de qualquer código
2. EXECUTE — dentro do plano aprovado
3. VERIFY — máximo 3 linhas; use masking em outputs longos
```

### Memória entre sessões

**Claude Code:**
```
/wrap-session          ← encerra e salva contexto
/brief-session         ← retoma sessão anterior
```

**Antigravity / OpenCode:**
```
Leia directives/session-memory.md e salve o contexto
em .harness/memory/last-session.md
```

**Trocar de runtime sem perder contexto:**
1. Salve com `/wrap-session` ou equivalente
2. No novo runtime: `Leia .harness/memory/last-session.md e me dê um briefing`

---

## Economia de Tokens

Bifrost corta **50–70% do consumo** com cinco técnicas:

```
┌─────────────────────────────────────────────────────┐
│  Lazy Loading      Carrega só a directive relevante  │
│  antes: 15k tokens                                   │
│  depois: 3k tokens        ▓▓▓░░░░░░░░░░ -80%        │
├─────────────────────────────────────────────────────┤
│  Observation Masking    Logs longos → placeholder    │
│  [Logs omitidos — FALHA | timeout linha 42]          │
│                                       ▓▓▓░░░░ -52%  │
├─────────────────────────────────────────────────────┤
│  Roteamento de Modelos                               │
│  Docs/testes  → Haiku      (até -95% de custo)      │
│  Código       → Sonnet     (equilíbrio)              │
│  Arquitetura  → Opus       (quando necessário)       │
├─────────────────────────────────────────────────────┤
│  Progressive Disclosure   Lê só o trecho necessário  │
│  grep -n "função" arquivo.ts  em vez de cat inteiro  │
├─────────────────────────────────────────────────────┤
│  Compressão de Histórico  Após 8 turnos              │
│  python execution/compress-history.py --auto         │
└─────────────────────────────────────────────────────┘
```

---

## Quality Gate

O pre-commit hook bloqueia automaticamente a cada `git commit`:

| Verificação | O que bloqueia |
|-------------|----------------|
| 🔑 Segredos | passwords, api_keys, tokens hardcoded |
| 📝 `console.log` | logs soltos em JS/TS |
| ⚠️ TypeScript `any` | sem `// harness-ignore` |
| 💰 Valores float | monetários em ponto flutuante |
| 🔒 Arquivos `.env` | commit sem ser `.example` |
| 🛡️ Protected paths | arquivos definidos em `.harness/config.json` |

```json
// .harness/config.json
{
  "protected_paths": [
    ".env", ".env.*", "secrets/", "terraform/",
    "credentials/", "infra/"
  ],
  "allowed_paths": [
    "src/", "app/", "components/", "lib/",
    "AGENTS.md", "directives/"
  ]
}
```

---

## Regra de Hashimoto

> *Cada bug que não vira regra do harness é um bug que vai acontecer de novo.*

Quando o agente cometer um erro:

```
1. Corrija o código
2. Identifique onde o harness falhou em prevenir
3. Atualize a directive correspondente
4. Se verificável → atualize o pre-commit hook
5. Commit: harness(quality-gate): [descrição]
```

O arquivo `directives/harness-evolution.md` define o protocolo completo de como Bifrost melhora a si mesmo ao longo do tempo.

---

## Skills — 1.200+ disponíveis

```bash
# Bundles prontos
npx harness-engineering skill --bundle essentials
npx harness-engineering skill --bundle saas
npx harness-engineering skill --bundle api
npx harness-engineering skill --bundle security
npx harness-engineering skill --bundle ai

# Skill específica
npx harness-engineering skill brainstorming
npx harness-engineering skill security-auditor

# Explorar
npx harness-engineering skill --list
npx harness-engineering skill --category security
npx harness-engineering skill --search "typescript"
```

Skills buscadas do repositório [antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) e registradas automaticamente no `AGENTS.md`.

---

## Compatibilidade

| Runtime | Arquivo lido | Memória | Tokens | Comandos |
|---------|-------------|---------|--------|---------|
| Claude Code | `CLAUDE.md` | `/wrap-session` | `/context-check` | `/model-select` |
| Antigravity | `GEMINI.md` | manual | script Python | — |
| OpenCode | `AGENTS.md` | manual | script Python | — |
| Cursor | `.cursorrules` | manual | — | — |
| Copilot | manual | manual | — | — |

---

## Integração com GSD

Bifrost e o [GSD](https://github.com/gsd-build/get-shit-done) se complementam:

| Camada | Responsabilidade |
|--------|-----------------|
| **Bifrost** | Regras, domínios, directives, memory, quality gates |
| **GSD** | Execução: planejamento, waves paralelas, commits atômicos |

```bash
npx get-shit-done-cc@latest
# O GSD lê o AGENTS.md automaticamente
```

---

## Changelog

### v1.4.0 *(próxima)*
- ✨ Intent Gate — classificação de intenção antes de executar
- ✨ `.harness/config.json` — protected paths e allowed paths
- ✨ `directives/harness-evolution.md` — protocolo de auto-melhoria
- ✨ Build sync automático AGENTS.md → CLAUDE.md → GEMINI.md

### v1.3.0
- ✨ Progressive Disclosure — leitura incremental de arquivos
- ✨ Observation Masking — placeholders para outputs longos
- ✨ Roteamento de Modelos por tipo de tarefa
- ✨ Sub-agentes — critério e directive para tarefas pesadas
- ✨ `/model-select` para Claude Code

### v1.2.0
- ✨ Lazy loading via `.harness/index.md`
- ✨ Output conciso — protocolo de economia
- ✨ Budget por tipo de tarefa
- ✨ `compress-history.py` — compressão determinística
- ✨ `/context-check` para Claude Code

### v1.1.0
- ✨ Memória persistente entre sessões
- ✨ `/wrap-session` e `/brief-session`
- ✨ `directives/session-memory.md`

### v1.0.0
- Estrutura base: AGENTS.md · CLAUDE.md · GEMINI.md
- Framework DOE · Ciclo PEV · 4 domínios
- Quality gate · CI · `npx harness-engineering`

---

## Princípios

```
1.  Agente = Modelo + Harness
    LLM sem harness é chatbot. Com harness, é sistema.

2.  Marcha dos Noves
    90% por etapa × 10 etapas = 35% de sucesso total.
    O harness resolve isso.

3.  Directives são documentos vivos
    Atualize sempre que aprender algo novo.

4.  Scripts determinísticos > agente improvisando
    Delegue execução ao código quando possível.

5.  Verificador com contexto limpo
    Agente não audita o próprio trabalho de forma confiável.

6.  Sucesso silencioso, falha barulhenta
    Economize contexto para o que importa.

7.  Hashimoto
    Cada erro vira melhoria permanente no harness.

8.  Memória persistente          ·  v1.1.0
    Cada sessão começa de onde a anterior parou.

9.  Contexto mínimo necessário   ·  v1.2.0
    Carregue só o que a tarefa precisa.

10. Modelo certo para cada tarefa ·  v1.3.0
    Haiku para rotina. Sonnet para código. Opus para arquitetura.

11. Intenção antes de execução    ·  v1.4.0
    Classifique o que você quer antes de fazer.
```

---

## Licença

MIT — use, modifique, distribua, contribua.

---

<div align="center">

*Na mitologia nórdica, Bifrost é a ponte que conecta todos os mundos.*
*Aqui, conecta seus projetos a qualquer agente de IA.*

**[⭐ Star no GitHub](https://github.com/JRoberto1/harness-template) · [📦 npm](https://www.npmjs.com/package/harness-engineering) · [🐛 Issues](https://github.com/JRoberto1/harness-template/issues)**

</div>
