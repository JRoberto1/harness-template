#!/bin/bash
# ============================================================
# Harness Adopt — instala o harness em projeto já existente
# Faz análise do projeto antes de aplicar qualquer coisa
#
# Uso: bash /caminho/do/harness-template/scripts/adopt-project.sh
# ============================================================
set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

HARNESS_VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")"
TARGET_DIR="$(pwd)"
REPORT_FILE=".harness-adoption-report.md"

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║  Harness Engineering — Adopt (brownfield)║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "Projeto: ${BLUE}$(basename "$TARGET_DIR")${NC}"
echo -e "Diretório: ${BLUE}${TARGET_DIR}${NC}"
echo ""

# ── Verificar que não é o template em si ─────────────────────
if [ -f "$TARGET_DIR/.harness/VERSION" ]; then
  echo -e "${YELLOW}⚠ Harness já instalado neste projeto.${NC}"
  echo "  Use bash scripts/health-check.sh para verificar integridade."
  exit 0
fi

# ── FASE 1: Análise do projeto existente ─────────────────────
echo -e "${BOLD}[ FASE 1/5 ] Analisando projeto existente...${NC}"
echo ""

# Detectar stack
detect_stack() {
  local stack=""
  [ -f "package.json" ]        && stack+="Node.js "
  [ -f "tsconfig.json" ]       && stack+="TypeScript "
  [ -f "next.config.js" ] || [ -f "next.config.ts" ] && stack+="Next.js "
  [ -f "vite.config.ts" ] || [ -f "vite.config.js" ] && stack+="Vite "
  [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] && stack+="Python "
  [ -f "go.mod" ]              && stack+="Go "
  [ -f "Cargo.toml" ]          && stack+="Rust "
  [ -f "pom.xml" ]             && stack+="Java/Maven "
  [ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ] && stack+="Docker "
  [ -f "prisma/schema.prisma" ] && stack+="Prisma "
  [ -f "drizzle.config.ts" ]   && stack+="Drizzle "
  echo "${stack:-Não detectada}"
}

# Detectar padrões de código existentes
detect_patterns() {
  local patterns=""
  [ -f ".eslintrc*" ] || [ -f "eslint.config*" ] && patterns+="ESLint "
  [ -f ".prettierrc*" ]        && patterns+="Prettier "
  [ -f "biome.json" ]          && patterns+="Biome "
  [ -f "jest.config*" ]        && patterns+="Jest "
  [ -f "vitest.config*" ]      && patterns+="Vitest "
  [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] && grep -q "pytest" pyproject.toml 2>/dev/null && patterns+="Pytest "
  echo "${patterns:-Nenhum detectado}"
}

# Detectar arquivos de contexto existentes
detect_context_files() {
  local found=""
  for f in CLAUDE.md AGENTS.md GEMINI.md .cursorrules .clinerules README.md; do
    [ -f "$f" ] && found+="$f "
  done
  echo "${found:-Nenhum}"
}

# Contar arquivos de código
count_code_files() {
  find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \
    -o -name "*.py" -o -name "*.go" -o -name "*.rs" \) \
    -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/dist/*" \
    2>/dev/null | wc -l | tr -d ' '
}

# Detectar estrutura de diretórios
detect_structure() {
  find . -maxdepth 2 -type d \
    -not -path "*/.git*" -not -path "*/node_modules*" -not -path "*/dist*" \
    -not -path "*/__pycache__*" -not -path "*/.next*" \
    2>/dev/null | sort | head -30
}

STACK=$(detect_stack)
PATTERNS=$(detect_patterns)
CONTEXT_FILES=$(detect_context_files)
CODE_FILES=$(count_code_files)
GIT_COMMITS=$(git log --oneline 2>/dev/null | wc -l | tr -d ' ')
GIT_BRANCH=$(git branch --show-current 2>/dev/null || echo "N/A")

echo -e "  Stack detectada:      ${CYAN}${STACK}${NC}"
echo -e "  Ferramentas de código:${CYAN}${PATTERNS}${NC}"
echo -e "  Arquivos de contexto: ${CYAN}${CONTEXT_FILES}${NC}"
echo -e "  Arquivos de código:   ${CYAN}${CODE_FILES}${NC}"
echo -e "  Commits no git:       ${CYAN}${GIT_COMMITS}${NC}"
echo -e "  Branch atual:         ${CYAN}${GIT_BRANCH}${NC}"
echo ""

# ── FASE 2: Perguntas de configuração ─────────────────────────
echo -e "${BOLD}[ FASE 2/5 ] Configuração do Harness${NC}"
echo ""
read -rp "  Nome do projeto: " PROJECT_NAME
read -rp "  Descrição em uma linha: " PROJECT_DESC
echo ""
echo -e "  Stack detectada: ${CYAN}${STACK}${NC}"
read -rp "  Confirme/ajuste a stack: " PROJECT_STACK
[ -z "$PROJECT_STACK" ] && PROJECT_STACK="$STACK"
echo ""

echo -e "${BOLD}  Domínios ativos:${NC}"
read -rp "  SaaS / Produto Web? [s/n]: " D_SAAS
read -rp "  API / Backend? [s/n]: " D_API
read -rp "  Automação / Scripts? [s/n]: " D_AUTO
read -rp "  Jurídico / Financeiro? [s/n]: " D_JF
echo ""

# ── FASE 3: Conflitos e colisões ──────────────────────────────
echo -e "${BOLD}[ FASE 3/5 ] Verificando conflitos...${NC}"
echo ""

CONFLICTS=()
WARNINGS_LIST=()

# Verificar arquivos que seriam sobrescritos
for f in AGENTS.md CLAUDE.md GEMINI.md; do
  if [ -f "$f" ]; then
    CONFLICTS+=("$f já existe ($(wc -l < "$f") linhas)")
  fi
done

# Verificar se há docs/ com conteúdo
if [ -d "docs" ] && [ "$(ls -A docs/ 2>/dev/null)" ]; then
  WARNINGS_LIST+=("docs/ já existe — harness vai adicionar arquivos, não sobrescrever")
fi

# Verificar pre-commit hook existente
if [ -f ".git/hooks/pre-commit" ]; then
  WARNINGS_LIST+=("pre-commit hook já existe — será feito backup antes de substituir")
fi

# Relatório de conflitos
if [ ${#CONFLICTS[@]} -gt 0 ]; then
  echo -e "  ${YELLOW}Conflitos encontrados:${NC}"
  for c in "${CONFLICTS[@]}"; do
    echo -e "    ${YELLOW}⚠${NC} $c"
  done
  echo ""
  echo -e "  O harness vai ${BOLD}MESCLAR${NC} o conteúdo existente, não substituir."
  read -rp "  Continuar mesmo assim? [s/n]: " proceed
  [ "$proceed" != "s" ] && echo "Adoção cancelada." && exit 0
else
  echo -e "  ${GREEN}✓ Sem conflitos críticos${NC}"
fi

if [ ${#WARNINGS_LIST[@]} -gt 0 ]; then
  echo ""
  for w in "${WARNINGS_LIST[@]}"; do
    echo -e "  ${YELLOW}ℹ${NC} $w"
  done
fi
echo ""

# ── FASE 4: Instalação não-destrutiva ────────────────────────
echo -e "${BOLD}[ FASE 4/5 ] Instalando harness...${NC}"
echo ""

mark() { [ "$1" = "s" ] && echo "x" || echo " "; }

# 4a. .harness/ — sempre seguro (diretório novo)
cp -r "$TEMPLATE_DIR/.harness" "$TARGET_DIR/"
echo "$HARNESS_VERSION" > "$TARGET_DIR/.harness/VERSION"
echo -e "  ${GREEN}✓${NC} .harness/ instalado"

# 4b. directives/ — só cria se não existir
if [ ! -d "$TARGET_DIR/directives" ]; then
  cp -r "$TEMPLATE_DIR/directives" "$TARGET_DIR/"
  echo -e "  ${GREEN}✓${NC} directives/ criado"
else
  # Adiciona apenas o template, não sobrescreve
  cp "$TEMPLATE_DIR/directives/DIRECTIVE-template.md" "$TARGET_DIR/directives/" 2>/dev/null || true
  echo -e "  ${YELLOW}ℹ${NC} directives/ já existe — apenas template adicionado"
fi

# 4c. execution/ — só cria se não existir
if [ ! -d "$TARGET_DIR/execution" ]; then
  cp -r "$TEMPLATE_DIR/execution" "$TARGET_DIR/"
  echo -e "  ${GREEN}✓${NC} execution/ criado"
else
  cp "$TEMPLATE_DIR/execution/SCRIPT-template.py" "$TARGET_DIR/execution/" 2>/dev/null || true
  echo -e "  ${YELLOW}ℹ${NC} execution/ já existe — apenas template adicionado"
fi

# 4d. docs/ — adiciona apenas arquivos que não existem
mkdir -p "$TARGET_DIR/docs"
for doc in architecture.md domain-rules.md coding-standards.md; do
  if [ ! -f "$TARGET_DIR/docs/$doc" ]; then
    cp "$TEMPLATE_DIR/docs/$doc" "$TARGET_DIR/docs/"
    echo -e "  ${GREEN}✓${NC} docs/$doc criado"
  else
    echo -e "  ${YELLOW}ℹ${NC} docs/$doc já existe — não sobrescrito"
  fi
done

# 4e. scripts/
mkdir -p "$TARGET_DIR/scripts"
for s in fetch-skill.sh health-check.sh adopt-project.sh; do
  [ -f "$TEMPLATE_DIR/scripts/$s" ] && cp "$TEMPLATE_DIR/scripts/$s" "$TARGET_DIR/scripts/"
done
chmod +x "$TARGET_DIR/scripts/"*.sh 2>/dev/null || true
echo -e "  ${GREEN}✓${NC} scripts/ instalados"

# 4f. .tmp/
mkdir -p "$TARGET_DIR/.tmp"
[ ! -f "$TARGET_DIR/.tmp/.gitkeep" ] && \
  echo "# Arquivos intermediários — sempre regeneráveis" > "$TARGET_DIR/.tmp/.gitkeep"

# 4g. .github/workflows/ — só adiciona se não existir o arquivo
mkdir -p "$TARGET_DIR/.github/workflows"
if [ ! -f "$TARGET_DIR/.github/workflows/harness-ci.yml" ]; then
  cp "$TEMPLATE_DIR/.github/workflows/harness-ci.yml" "$TARGET_DIR/.github/workflows/"
  echo -e "  ${GREEN}✓${NC} CI GitHub Actions adicionado"
else
  echo -e "  ${YELLOW}ℹ${NC} harness-ci.yml já existe — não sobrescrito"
fi

# 4h. AGENTS.md — mesclar ou criar
if [ -f "$TARGET_DIR/AGENTS.md" ]; then
  # Backup do original
  cp "$TARGET_DIR/AGENTS.md" "$TARGET_DIR/AGENTS.md.backup-$(date +%Y%m%d%H%M%S)"
  # Adicionar seção do harness ao final do existente
  cat >> "$TARGET_DIR/AGENTS.md" << APPEND_EOF

---
<!-- HARNESS ENGINEERING — adicionado pelo adopt-project.sh -->

## Arquitetura de 3 Camadas (Harness)

Você opera dentro de uma arquitetura de 3 camadas:
- **Camada 1 — Directives** (\`directives/\`): SOPs — o QUE fazer
- **Camada 2 — Agente (você)**: roteamento entre directives e scripts
- **Camada 3 — Execution** (\`execution/\`): scripts determinísticos

**Verifique \`execution/\` antes de criar scripts novos.**

## Regras de Harness

1. Nunca avance sem validar o output da etapa anterior
2. Nunca invente — marque \`[VERIFICAR: motivo]\`
3. Aplique o Protocolo PEV em tarefas com 3+ arquivos
4. Aplique a Regra de Hashimoto: cada erro melhora o harness
5. Atualize a directive relevante após cada aprendizado

## Protocolo PEV

\`\`\`
PLAN    → critérios verificáveis antes de qualquer código
EXECUTE → estritamente dentro do plano aprovado
VERIFY  → falha = volta ao Plan com contexto de erro
\`\`\`

## Domínios Ativos

- [$(mark "$D_SAAS")] SaaS Web              → \`.harness/domains/saas.md\`
- [$(mark "$D_API")] API / Backend         → \`.harness/domains/api.md\`
- [$(mark "$D_AUTO")] Automação / Scripts   → \`.harness/domains/automation.md\`
- [$(mark "$D_JF")] Jurídico / Financeiro → \`.harness/domains/juridico-financeiro.md\`

## Skills Instaladas

> Instale novas: \`bash scripts/fetch-skill.sh <nome>\`

- \`.harness/skills/SKILL-template.md\` → template para criar skills

<!-- Harness v${HARNESS_VERSION} — adotado em $(date +%Y-%m-%d) -->
APPEND_EOF
  echo -e "  ${GREEN}✓${NC} AGENTS.md existente atualizado (backup salvo)"
else
  # Criar do zero
  cat > "$TARGET_DIR/AGENTS.md" << AGENTS_EOF
# AGENTS.md — ${PROJECT_NAME}
<!-- Claude Code · Antigravity · OpenCode · Cursor · Copilot -->

> Leia este arquivo completamente antes de qualquer ação.

## Identidade

Você é um agente de engenharia do projeto **${PROJECT_NAME}**.
${PROJECT_DESC}

Stack: ${PROJECT_STACK}

## Arquitetura de 3 Camadas

- **Camada 1 — Directives** (\`directives/\`): SOPs — o QUE fazer
- **Camada 2 — Agente (você)**: roteamento inteligente
- **Camada 3 — Execution** (\`execution/\`): scripts determinísticos

## Regras Absolutas

1. Nunca avance sem validar o output da etapa anterior
2. Nunca invente — marque \`[VERIFICAR: motivo]\`
3. Nunca quebre a arquitetura de camadas de \`docs/architecture.md\`
4. Verifique \`execution/\` antes de criar script novo
5. Nunca use \`any\` em TypeScript nem ignore erros silenciosamente
6. Aplique o Protocolo PEV em tarefas com 3+ arquivos
7. Aplique a Regra de Hashimoto: cada erro melhora o harness

## Protocolo PEV

\`\`\`
PLAN    → critérios verificáveis antes de qualquer código
EXECUTE → estritamente dentro do plano aprovado
VERIFY  → falha = volta ao Plan com contexto de erro
\`\`\`

## Domínios Ativos

- [$(mark "$D_SAAS")] SaaS Web              → \`.harness/domains/saas.md\`
- [$(mark "$D_API")] API / Backend         → \`.harness/domains/api.md\`
- [$(mark "$D_AUTO")] Automação / Scripts   → \`.harness/domains/automation.md\`
- [$(mark "$D_JF")] Jurídico / Financeiro → \`.harness/domains/juridico-financeiro.md\`

## Skills Instaladas

> Instale novas: \`bash scripts/fetch-skill.sh <nome>\`

- \`.harness/skills/SKILL-template.md\` → template para criar skills

*Harness v${HARNESS_VERSION} — adotado em $(date +%Y-%m-%d)*
AGENTS_EOF
  echo -e "  ${GREEN}✓${NC} AGENTS.md criado"
fi

# Espelhar para outros runtimes
cp "$TARGET_DIR/AGENTS.md" "$TARGET_DIR/CLAUDE.md"
cp "$TARGET_DIR/AGENTS.md" "$TARGET_DIR/GEMINI.md"
echo -e "  ${GREEN}✓${NC} CLAUDE.md e GEMINI.md sincronizados"

# 4i. Pre-commit hook
if [ -d "$TARGET_DIR/.git" ]; then
  if [ -f "$TARGET_DIR/.git/hooks/pre-commit" ]; then
    cp "$TARGET_DIR/.git/hooks/pre-commit" \
       "$TARGET_DIR/.git/hooks/pre-commit.backup-$(date +%Y%m%d%H%M%S)"
  fi
  cp "$TEMPLATE_DIR/.harness/quality-gates/pre-commit" "$TARGET_DIR/.git/hooks/pre-commit"
  chmod +x "$TARGET_DIR/.git/hooks/pre-commit"
  echo -e "  ${GREEN}✓${NC} Pre-commit hook instalado"
fi

# ── FASE 5: Gerar relatório de adoção ────────────────────────
echo ""
echo -e "${BOLD}[ FASE 5/5 ] Gerando relatório de adoção...${NC}"

cat > "$TARGET_DIR/$REPORT_FILE" << REPORT_EOF
# Relatório de Adoção do Harness

**Projeto:** ${PROJECT_NAME}
**Data:** $(date +%Y-%m-%d)
**Harness versão:** ${HARNESS_VERSION}

---

## Análise do Projeto

| Item | Valor |
|------|-------|
| Stack detectada | ${STACK} |
| Ferramentas de código | ${PATTERNS} |
| Arquivos de código | ${CODE_FILES} |
| Commits existentes | ${GIT_COMMITS} |
| Branch | ${GIT_BRANCH} |

---

## O que foi instalado

- [x] \`.harness/\` — framework DOE, PEV, domínios, skills, quality-gates
- [x] \`directives/\` — SOPs (templates)
- [x] \`execution/\` — scripts determinísticos (templates)
- [x] \`docs/\` — arquitetura, regras de domínio, padrões (somente arquivos ausentes)
- [x] \`scripts/\` — fetch-skill, health-check, adopt-project
- [x] \`AGENTS.md\` / \`CLAUDE.md\` / \`GEMINI.md\`
- [x] Pre-commit quality gate

---

## Próximos Passos Obrigatórios

### 1. Documentar a arquitetura REAL do projeto
\`\`\`bash
nano docs/architecture.md
\`\`\`
> Preencha com a stack, camadas e padrões que o projeto JÁ usa.
> Não invente — documente o que existe.

### 2. Criar a primeira directive do projeto
Identifique a tarefa mais repetida da equipe e documente:
\`\`\`bash
cp directives/DIRECTIVE-template.md directives/[nome-da-tarefa].md
nano directives/[nome-da-tarefa].md
\`\`\`

### 3. Instalar skills relevantes
\`\`\`bash
bash scripts/fetch-skill.sh --bundle essentials
bash scripts/fetch-skill.sh --bundle saas      # se domínio SaaS ativo
\`\`\`

### 4. Verificar integridade
\`\`\`bash
bash scripts/health-check.sh
\`\`\`

### 5. Commitar o harness
\`\`\`bash
git add .harness/ directives/ execution/ docs/ scripts/ AGENTS.md CLAUDE.md GEMINI.md
git commit -m "harness: adoção do harness engineering v${HARNESS_VERSION}"
\`\`\`

---

## Conflitos Resolvidos

$([ ${#CONFLICTS[@]} -gt 0 ] && printf '%s\n' "${CONFLICTS[@]/#/- }" || echo "- Nenhum conflito encontrado")

---

## Como Usar Daqui em Diante

Para qualquer tarefa no projeto, inicie com:

\`\`\`
Leia o AGENTS.md, a directive relevante em directives/ e os domínios
ativos em .harness/domains/.

Tarefa: [DESCREVA]

Siga o Protocolo PEV:
1. PLAN — critérios verificáveis antes de qualquer código
2. EXECUTE — dentro do plano aprovado
3. VERIFY — confirme cada critério; atualize a directive com aprendizados
\`\`\`
REPORT_EOF

echo -e "  ${GREEN}✓${NC} Relatório gerado: ${CYAN}${REPORT_FILE}${NC}"

# ── Resumo final ──────────────────────────────────────────────
echo ""
echo -e "${BOLD}╔══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║        ✅ Harness Adotado!               ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BOLD}Próximos passos:${NC}"
echo -e "  ${CYAN}1.${NC} nano docs/architecture.md           ← documente a arquitetura REAL"
echo -e "  ${CYAN}2.${NC} bash scripts/fetch-skill.sh         ← instale skills relevantes"
echo -e "  ${CYAN}3.${NC} bash scripts/health-check.sh        ← verifique integridade"
echo -e "  ${CYAN}4.${NC} Leia ${CYAN}${REPORT_FILE}${NC} para o roteiro completo"
echo ""
echo -e "  ${YELLOW}Commite o harness:${NC}"
echo "  git add .harness/ directives/ execution/ docs/ scripts/ AGENTS.md CLAUDE.md GEMINI.md"
echo "  git commit -m \"harness: adoção do harness engineering v${HARNESS_VERSION}\""
echo ""
