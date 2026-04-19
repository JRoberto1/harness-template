# Harness Engineering — Template Universal

> Sistema de harness para projetos de IA.
> Funciona com **Claude Code · Antigravity · OpenCode · Cursor · Copilot**.

---

## O que é isso

Um template que você clona uma vez e inicializa em qualquer projeto.
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

## Estrutura

```
harness-template/
│
├── AGENTS.md                    ← núcleo do harness (lido por todos os runtimes)
├── CLAUDE.md                    ← espelho para Claude Code
├── GEMINI.md                    ← espelho para Antigravity
│
├── directives/                  ← Camada 1: SOPs (o QUE fazer)
│   ├── DIRECTIVE-template.md    ← template para criar directives
│   └── health-check.md          ← exemplo de directive
│
├── execution/                   ← Camada 3: scripts determinísticos
│   └── SCRIPT-template.py       ← template com --dry-run, logs, retry
│
├── .harness/
│   ├── VERSION
│   ├── doe/                     ← Framework D·O·E (templates de prompt)
│   │   ├── diretrizes.md        ← D: system prompt global
│   │   ├── orquestracao.md      ← O: prompt do planejador
│   │   └── execucao.md          ← E: prompt dos subagentes
│   ├── pev/
│   │   └── pev.md               ← Ciclo Plan · Execute · Verify
│   ├── domains/                 ← Regras por domínio de projeto
│   │   ├── saas.md
│   │   ├── api.md
│   │   ├── automation.md
│   │   └── juridico-financeiro.md
│   ├── skills/                  ← Skills instaladas
│   │   └── SKILL-template.md    ← template para criar skills do projeto
│   └── quality-gates/
│       └── pre-commit           ← hook que bloqueia violações
│
├── docs/
│   ├── architecture.md          ← preencha: stack, camadas, ADRs
│   ├── domain-rules.md          ← preencha: regras de negócio, schemas
│   └── coding-standards.md      ← padrões de código prontos
│
├── scripts/
│   ├── init-project.sh          ← inicializa em novo projeto
│   ├── fetch-skill.sh           ← busca skills do repositório externo
│   └── health-check.sh          ← verifica integridade do harness
│
├── .github/workflows/
│   └── harness-ci.yml           ← quality gate no CI
│
├── .tmp/                        ← arquivos intermediários (nunca commitados)
├── .env.example
└── .gitignore
```

---

## Início Rápido

### 1. Clone o template

```bash
git clone https://github.com/SEU_USUARIO/harness-template.git ~/dev/harness-template
```

### 2. Inicialize em um projeto

```bash
cd ~/dev/meu-projeto
git init

bash ~/dev/harness-template/scripts/init-project.sh
```

O script vai:
- Perguntar nome, descrição, stack e domínios ativos
- Gerar `AGENTS.md`, `CLAUDE.md` e `GEMINI.md` personalizados
- Copiar toda a estrutura `.harness/`, `directives/`, `execution/`, `docs/`
- Instalar o pre-commit hook automaticamente
- Configurar o runtime detectado (Claude Code, Antigravity ou OpenCode)

### 3. Preencha os docs obrigatórios

```bash
nano docs/architecture.md    # sua stack e arquitetura em camadas
nano docs/domain-rules.md    # regras de negócio do projeto
```

### 4. Instale skills essenciais

```bash
bash scripts/fetch-skill.sh --bundle essentials
```

### 5. Verifique a integridade

```bash
bash scripts/health-check.sh
```

---

## Como Usar no Dia a Dia

### Prompt universal para qualquer runtime

```
Leia o AGENTS.md, a directive relevante em directives/ e os domínios
ativos em .harness/domains/.

Tarefa: [DESCREVA]

Siga o Protocolo PEV:
1. Apresente o PLAN com critérios verificáveis — aguarde aprovação
2. Execute dentro do plano aprovado
3. Verifique cada critério antes de encerrar
4. Atualize a directive com qualquer aprendizado novo
```

### Criar uma nova directive

```bash
cp directives/DIRECTIVE-template.md directives/minha-tarefa.md
nano directives/minha-tarefa.md
```

### Criar um novo script de execução

```bash
cp execution/SCRIPT-template.py execution/meu-script.py
# Implemente a lógica na função executar()
python execution/meu-script.py --dry-run --input "teste"
```

---

## Skills — Repositório Externo

O script `fetch-skill.sh` busca skills do repositório
[antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills)
(1.200+ skills para Claude Code, Antigravity, OpenCode e outros).

```bash
# Menu interativo
bash scripts/fetch-skill.sh

# Instalar uma skill específica
bash scripts/fetch-skill.sh brainstorming
bash scripts/fetch-skill.sh security-auditor

# Instalar um bundle completo
bash scripts/fetch-skill.sh --bundle essentials   # brainstorming, debugging, doc, lint, create-pr
bash scripts/fetch-skill.sh --bundle saas         # essentials + frontend, api, test, security
bash scripts/fetch-skill.sh --bundle api          # api design, security, test, typescript
bash scripts/fetch-skill.sh --bundle security     # security-auditor, sql-injection, vulns
bash scripts/fetch-skill.sh --bundle ai           # rag, prompt-engineer, architecture

# Listar categorias disponíveis
bash scripts/fetch-skill.sh --list

# Buscar por termo
bash scripts/fetch-skill.sh --search "typescript"

# Listar skills de uma categoria
bash scripts/fetch-skill.sh --category security
```

Skills instaladas são registradas automaticamente no `AGENTS.md`.

---

## Quality Gate

O pre-commit hook bloqueia automaticamente:

| Verificação | O que bloqueia |
|-------------|----------------|
| Segredos | passwords, api_keys, tokens hardcoded |
| `console.log` | logs soltos em JS/TS |
| TypeScript `any` | sem `// harness-ignore` |
| Valores float | monetários em ponto flutuante (domínio financeiro) |
| Arquivos `.env` | commit de `.env` sem ser `.example` |
| Directives | código sem atualização de directive (aviso) |

Para exceção justificada: adicione `// harness-ignore` na linha.

---

## Regra de Hashimoto

Quando encontrar um bug ou padrão ruim:

1. Corrija o código
2. Atualize a **directive** correspondente com o aprendizado
3. Se for verificável automaticamente → atualize o **pre-commit hook**
4. Se for regra de domínio → atualize o **arquivo de domínio**
5. Commit: `harness(quality-gate): [descrição]`

> Cada bug que não vira regra do harness é um bug que vai acontecer de novo.

---

## Compatibilidade de Runtimes

| Runtime | Arquivo lido | Config extra |
|---------|-------------|-------------|
| Claude Code | `CLAUDE.md` | `.claude/settings.json` (gerado pelo init) |
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
# Instale o GSD após o harness
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
