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

### Via npm (recomendado)

Abra o terminal na pasta do seu projeto e rode:

```bash
npx harness-engineering
```

O instalador vai perguntar o nome do projeto, a stack e os domínios ativos.
Em menos de 1 minuto tudo está configurado.

### Verificar se funcionou

```bash
npx harness-engineering check
```

---

## Projeto Novo vs Projeto Existente

### Projeto novo (pasta vazia)

```bash
# 1. Crie a pasta e entre nela
mkdir meu-projeto && cd meu-projeto
git init

# 2. Instale o harness
npx harness-engineering

# 3. Instale as skills
npx harness-engineering skill --bundle essentials

# 4. Pronto — comece a desenvolver
```

### Projeto existente (já tem código)

O instalador detecta automaticamente que o projeto já existe e faz a adoção sem sobrescrever nada:

```bash
# 1. Entre na pasta do projeto
cd meu-projeto-existente

# 2. Rode o mesmo comando — ele detecta o projeto existente
npx harness-engineering

# O que acontece automaticamente:
# ✓ Detecta a stack (Node, Python, Next.js, etc.)
# ✓ Cria AGENTS.md / CLAUDE.md / GEMINI.md sem apagar arquivos existentes
# ✓ Adiciona .harness/, directives/, execution/, docs/
# ✓ Faz backup de qualquer arquivo que precisar substituir
# ✓ Instala o quality gate (pre-commit hook)
# ✓ Gera relatório com os próximos passos específicos para seu projeto
```

---

## Como Usar no Dia a Dia

Após a instalação, **não é preciso mexer em nenhum arquivo manualmente**.
O agente lê o `AGENTS.md` automaticamente e segue as regras do harness.

### Iniciar qualquer tarefa

Cole este prompt no seu runtime (Claude Code, Antigravity, OpenCode):

```
Leia o AGENTS.md e os domínios ativos em .harness/domains/.

Tarefa: [DESCREVA O QUE QUER FAZER]

Siga o Protocolo PEV:
1. Apresente o PLAN com critérios verificáveis antes de qualquer código
2. Execute dentro do plano aprovado
3. Verifique cada critério antes de encerrar
```

### Instalar skills adicionais

Skills são capacidades extras que o agente pode usar.
Instale pelo terminal sem precisar abrir nenhum arquivo:

```bash
# Skills essenciais (recomendado para todos os projetos)
npx harness-engineering skill --bundle essentials

# Por tipo de projeto
npx harness-engineering skill --bundle saas       # produtos web
npx harness-engineering skill --bundle api        # APIs e backends
npx harness-engineering skill --bundle security   # auditoria de segurança
npx harness-engineering skill --bundle ai         # projetos com IA

# Uma skill específica
npx harness-engineering skill brainstorming
npx harness-engineering skill security-auditor

# Ver todas as opções
npx harness-engineering skill --list
```

### Verificar integridade

```bash
npx harness-engineering check
```

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
├── execution/         ← scripts determinísticos: COMO executar
│
├── .harness/
│   ├── domains/       ← regras por domínio (saas, api, juridico...)
│   ├── skills/        ← skills instaladas
│   ├── doe/           ← templates de prompt por camada
│   ├── pev/           ← ciclo Plan · Execute · Verify
│   └── quality-gates/ ← hooks de verificação automática
│
└── docs/
    ├── architecture.md    ← stack e decisões arquiteturais
    ├── domain-rules.md    ← regras de negócio do projeto
    └── coding-standards.md← padrões de código
```

---

## Configuração após instalação

Os dois arquivos abaixo são os únicos que precisam ser preenchidos manualmente
(ou você pode pedir ao próprio agente para preencher analisando o projeto):

**`docs/architecture.md`** — sua stack real, camadas, decisões arquiteturais

**`docs/domain-rules.md`** — regras de negócio específicas do seu projeto

Para pedir ao agente que preencha automaticamente, use:

```
Analise todos os arquivos do projeto e preencha docs/architecture.md
e docs/domain-rules.md com as informações reais que encontrar.
Não invente — documente apenas o que existe.
```

---

## Skills — Repositório Externo

O comando `skill` busca do repositório
[antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills)
(1.200+ skills para Claude Code, Antigravity, OpenCode e outros).

Skills instaladas são registradas automaticamente no `AGENTS.md`.

---

## Quality Gate

O pre-commit hook bloqueia automaticamente a cada `git commit`:

| Verificação | O que bloqueia |
|-------------|----------------|
| Segredos | passwords, api_keys, tokens hardcoded |
| `console.log` | logs soltos em JS/TS |
| TypeScript `any` | sem `// harness-ignore` |
| Valores float | monetários em ponto flutuante (domínio financeiro) |
| Arquivos `.env` | commit de `.env` sem ser `.example` |

Para exceção justificada: adicione `// harness-ignore` na linha.

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

| Runtime | Arquivo lido | Config extra |
|---------|-------------|-------------|
| Claude Code | `CLAUDE.md` | `.claude/settings.json` (gerado automaticamente) |
| Antigravity | `GEMINI.md` | nenhuma |
| OpenCode | `AGENTS.md` | nenhuma |
| Cursor | `.cursorrules` | copie AGENTS.md para `.cursorrules` |
| Copilot | manual | cole AGENTS.md no contexto |

---

## Integração com GSD (opcional)

O harness e o [GSD](https://github.com/gsd-build/get-shit-done) se complementam:

| Camada | Responsabilidade |
|--------|-----------------|
| **Harness** | Regras, domínios, directives, quality gates |
| **GSD** | Execução: planejamento, waves paralelas, commits atômicos |

```bash
npx get-shit-done-cc@latest
# O GSD lê o AGENTS.md automaticamente
```

---

## Princípios por Trás do Template

1. **Agente = Modelo + Harness** — LLM sem harness é chatbot, não agente
2. **Marcha dos Noves** — 90% por etapa × 10 etapas = 35% de sucesso. O harness resolve
3. **Directives são documentos vivos** — atualize sempre que aprender algo novo
4. **Scripts determinísticos > agente improvisando** — delegue execução ao código
5. **Verificador com contexto limpo** — agente não audita o próprio trabalho
6. **Sucesso silencioso, falha barulhenta** — economize contexto para o que importa
7. **Hashimoto** — cada erro vira melhoria permanente no harness

---

## Licença

MIT — use, modifique e distribua livremente.
