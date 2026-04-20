#!/bin/bash
# ============================================================
# Harness Skill Fetcher
# Busca skills do repositório antigravity-awesome-skills
# e instala em .harness/skills/ registrando no AGENTS.md
#
# Uso:
#   bash scripts/fetch-skill.sh                       → menu interativo
#   bash scripts/fetch-skill.sh brainstorming         → instala skill
#   bash scripts/fetch-skill.sh --list               → lista categorias
#   bash scripts/fetch-skill.sh --category security  → lista skills da categoria
#   bash scripts/fetch-skill.sh --bundle saas        → instala bundle
#   bash scripts/fetch-skill.sh --search "api"       → busca por termo
#   bash scripts/fetch-skill.sh --update             → atualiza índice
# ============================================================
set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

SKILLS_REPO_RAW="https://raw.githubusercontent.com/sickn33/antigravity-awesome-skills/main"
SKILLS_INDEX_URL="${SKILLS_REPO_RAW}/skills_index.json"
SKILLS_DIR=".harness/skills"
INDEX_CACHE="${SKILLS_DIR}/.index-cache.json"
CACHE_TTL=86400  # 24 horas

# ── Verificar dependências ────────────────────────────────────
check_deps() {
  local missing=()
  command -v curl &>/dev/null || missing+=("curl")
  command -v jq   &>/dev/null || missing+=("jq")
  if [ ${#missing[@]} -gt 0 ]; then
    echo -e "${RED}Dependências ausentes: ${missing[*]}${NC}"
    echo "  macOS:  brew install ${missing[*]}"
    echo "  Ubuntu: sudo apt install ${missing[*]}"
    exit 1
  fi
}

# ── Baixar/cachear índice de skills ──────────────────────────
fetch_index() {
  mkdir -p "$SKILLS_DIR"
  local force="${1:-}"

  if [ "$force" = "--force" ] || [ ! -f "$INDEX_CACHE" ]; then
    echo -e "${CYAN}Atualizando índice...${NC}"
    if curl -sf "$SKILLS_INDEX_URL" -o "$INDEX_CACHE" 2>/dev/null; then
      echo -e "${GREEN}✓ Índice atualizado ($(jq length "$INDEX_CACHE") skills)${NC}"
    else
      echo -e "${YELLOW}⚠ Índice online indisponível — usando lista offline${NC}"
      build_offline_index
    fi
    return
  fi

  # Verificar idade do cache
  local cache_age=$(( $(date +%s) - $(date -r "$INDEX_CACHE" +%s 2>/dev/null || echo 0) ))
  if [ "$cache_age" -gt "$CACHE_TTL" ]; then
    fetch_index --force
  fi
}

# ── Índice offline (skills essenciais hardcoded) ──────────────
build_offline_index() {
  cat > "$INDEX_CACHE" << 'EOF'
[
  {"name":"brainstorming","category":"general","description":"Planejamento antes da implementação"},
  {"name":"architecture","category":"architecture","description":"Design de sistema e componentes"},
  {"name":"senior-architect","category":"architecture","description":"Arquitetura de nível sênior"},
  {"name":"test-driven-development","category":"testing","description":"TDD orientado a qualidade"},
  {"name":"testing-patterns","category":"testing","description":"Padrões avançados de teste"},
  {"name":"security-auditor","category":"security","description":"Revisão de segurança"},
  {"name":"api-security-best-practices","category":"security","description":"Segurança de APIs"},
  {"name":"sql-injection-testing","category":"security","description":"Testes de SQL injection"},
  {"name":"vulnerability-scanner","category":"security","description":"Scanner de vulnerabilidades"},
  {"name":"api-design-principles","category":"development","description":"Design e consistência de APIs"},
  {"name":"frontend-design","category":"development","description":"Qualidade de UI e interação"},
  {"name":"typescript-expert","category":"development","description":"TypeScript avançado"},
  {"name":"python-patterns","category":"development","description":"Padrões Python"},
  {"name":"react-patterns","category":"development","description":"Padrões React"},
  {"name":"debugging-strategies","category":"general","description":"Troubleshooting sistemático"},
  {"name":"doc-coauthoring","category":"general","description":"Documentação estruturada"},
  {"name":"lint-and-validate","category":"testing","description":"Verificações de qualidade leve"},
  {"name":"create-pr","category":"workflow","description":"Pull request limpo e documentado"},
  {"name":"workflow-automation","category":"workflow","description":"Automação de workflows"},
  {"name":"docker-expert","category":"infrastructure","description":"Containerização e Docker"},
  {"name":"aws-serverless","category":"infrastructure","description":"AWS Lambda e serverless"},
  {"name":"rag-engineer","category":"data-ai","description":"RAG e aplicações LLM"},
  {"name":"prompt-engineer","category":"data-ai","description":"Engenharia de prompts"},
  {"name":"writing-plans","category":"general","description":"Planos de escrita e conteúdo"},
  {"name":"copywriting","category":"business","description":"Copywriting e mensagem de produto"}
]
EOF
}

# ── Listar categorias ─────────────────────────────────────────
cmd_list() {
  fetch_index
  echo ""
  echo -e "${BOLD}Categorias disponíveis:${NC}"
  echo ""
  jq -r '.[].category' "$INDEX_CACHE" | sort -u | while read -r cat; do
    local count
    count=$(jq -r --arg c "$cat" '[.[] | select(.category == $c)] | length' "$INDEX_CACHE")
    printf "  ${CYAN}%-20s${NC} %s skills\n" "$cat" "$count"
  done
  echo ""
  echo -e "Use: ${YELLOW}bash scripts/fetch-skill.sh --category <nome>${NC}"
  echo -e "     ${YELLOW}bash scripts/fetch-skill.sh --bundle <nome>${NC}"
}

# ── Listar skills de uma categoria ───────────────────────────
cmd_category() {
  local category="$1"
  fetch_index
  echo ""
  echo -e "${BOLD}Skills em '${category}':${NC}"
  echo ""
  jq -r --arg c "$category" \
    '.[] | select(.category == $c) | "  \(.name) — \(.description // "")"' \
    "$INDEX_CACHE"
  echo ""
  echo -e "Para instalar: ${YELLOW}bash scripts/fetch-skill.sh <nome>${NC}"
}

# ── Buscar por termo ──────────────────────────────────────────
cmd_search() {
  local term="$1"
  fetch_index
  echo ""
  echo -e "${BOLD}Resultados para '${term}':${NC}"
  echo ""
  jq -r --arg t "$term" \
    '.[] | select((.name | ascii_downcase | contains($t)) or (.description // "" | ascii_downcase | contains($t))) | "  \(.name) [\(.category)] — \(.description // "")"' \
    "$INDEX_CACHE"
  echo ""
}

# ── Instalar uma skill ────────────────────────────────────────
install_skill() {
  local skill_name="$1"
  local target_dir="${SKILLS_DIR}/${skill_name}"

  # Verificar se já existe
  if [ -f "${target_dir}/SKILL.md" ]; then
    echo -e "${YELLOW}⚠ '${skill_name}' já instalada${NC}"
    read -rp "  Atualizar? [s/n]: " upd
    [ "$upd" != "s" ] && return 0
  fi

  mkdir -p "$target_dir"
  local url="${SKILLS_REPO_RAW}/skills/${skill_name}/SKILL.md"
  echo -ne "${CYAN}Buscando '${skill_name}'...${NC} "

  if curl -sf "$url" -o "${target_dir}/SKILL.md" 2>/dev/null; then
    echo -e "${GREEN}✓${NC}"
    register_in_agents "$skill_name"
  else
    echo -e "${RED}✗ não encontrada${NC}"
    echo "  Verifique o nome: https://github.com/sickn33/antigravity-awesome-skills/tree/main/skills"
    rmdir "$target_dir" 2>/dev/null || true
    return 1
  fi
}

# ── Registrar skill no AGENTS.md ─────────────────────────────
register_in_agents() {
  local skill_name="$1"
  [ ! -f "AGENTS.md" ] && return 0

  # Criar seção se não existir
  if ! grep -q "## Skills Instaladas" AGENTS.md; then
    printf '\n## Skills Instaladas\n\n> Leia a skill relevante antes de executar a tarefa correspondente.\n\n' >> AGENTS.md
  fi

  # Adicionar se não estiver listada
  if ! grep -q "$skill_name" AGENTS.md; then
    local desc
    desc=$(jq -r --arg n "$skill_name" '.[] | select(.name == $n) | .description // ""' "$INDEX_CACHE" 2>/dev/null || echo "")
    echo "- \`.harness/skills/${skill_name}/SKILL.md\` — ${desc}" >> AGENTS.md
    echo -e "  ${GREEN}✓ Registrada no AGENTS.md${NC}"
  fi

  # Espelhar em CLAUDE.md e GEMINI.md
  [ -f "CLAUDE.md" ] && cp AGENTS.md CLAUDE.md
  [ -f "GEMINI.md" ] && cp AGENTS.md GEMINI.md
}

# ── Bundles pré-definidos ─────────────────────────────────────
declare -A BUNDLES
BUNDLES[essentials]="brainstorming debugging-strategies doc-coauthoring lint-and-validate create-pr"
BUNDLES[saas]="brainstorming architecture frontend-design api-design-principles test-driven-development security-auditor create-pr"
BUNDLES[api]="api-design-principles api-security-best-practices test-driven-development debugging-strategies typescript-expert doc-coauthoring"
BUNDLES[security]="security-auditor api-security-best-practices sql-injection-testing vulnerability-scanner"
BUNDLES[infra]="docker-expert aws-serverless workflow-automation"
BUNDLES[ai]="rag-engineer prompt-engineer brainstorming architecture"
BUNDLES[automation]="workflow-automation debugging-strategies python-patterns lint-and-validate"

cmd_bundle() {
  local bundle="$1"

  if [ -z "${BUNDLES[$bundle]+x}" ]; then
    echo -e "${RED}Bundle '${bundle}' não existe.${NC}"
    echo ""
    echo -e "${BOLD}Bundles disponíveis:${NC}"
    for b in "${!BUNDLES[@]}"; do
      echo "  $b — ${BUNDLES[$b]}"
    done
    exit 1
  fi

  fetch_index
  echo ""
  echo -e "${BOLD}Instalando bundle '${bundle}'...${NC}"
  echo ""

  local ok=0 fail=0
  for skill in ${BUNDLES[$bundle]}; do
    install_skill "$skill" && ok=$((ok+1)) || fail=$((fail+1))
  done

  echo ""
  echo -e "${BOLD}Bundle '${bundle}': ${GREEN}${ok} instaladas${NC}${fail:+ · ${RED}${fail} falhas${NC}}"
}

# ── Menu interativo ───────────────────────────────────────────
cmd_interactive() {
  fetch_index
  echo ""
  echo -e "${BOLD}╔══════════════════════════════════╗${NC}"
  echo -e "${BOLD}║      Harness Skill Fetcher       ║${NC}"
  echo -e "${BOLD}╚══════════════════════════════════╝${NC}"
  echo ""
  echo "  1) Listar categorias"
  echo "  2) Instalar bundle"
  echo "  3) Buscar skill por nome/termo"
  echo "  4) Ver skills instaladas"
  echo "  5) Atualizar índice"
  echo "  0) Sair"
  echo ""
  read -rp "Opção: " opt

  case $opt in
    1) cmd_list ;;
    2)
      echo ""
      echo -e "Bundles: ${CYAN}${!BUNDLES[*]}${NC}"
      read -rp "Bundle: " b
      cmd_bundle "$b"
      ;;
    3)
      read -rp "Buscar: " term
      cmd_search "$term"
      read -rp "Instalar qual skill? (Enter para pular): " s
      [ -n "$s" ] && install_skill "$s"
      ;;
    4)
      echo ""
      echo -e "${BOLD}Skills instaladas em ${SKILLS_DIR}/:${NC}"
      find "$SKILLS_DIR" -name "SKILL.md" | sed "s|${SKILLS_DIR}/||;s|/SKILL.md||" | sort | while read -r s; do
        echo "  - $s"
      done
      ;;
    5) fetch_index --force ;;
    0) exit 0 ;;
    *) echo -e "${RED}Opção inválida${NC}" ;;
  esac
}

# ── Entry point ───────────────────────────────────────────────
check_deps

case "${1:-}" in
  --list)                   cmd_list ;;
  --category)               cmd_category "${2:-}" ;;
  --bundle)                 cmd_bundle "${2:-}" ;;
  --search)                 cmd_search "${2:-}" ;;
  --update)                 fetch_index --force ;;
  "")                       cmd_interactive ;;
  -*)
    echo -e "${RED}Opção desconhecida: $1${NC}"
    echo "Uso: bash scripts/fetch-skill.sh [--list|--category <c>|--bundle <b>|--search <t>|--update|<skill-name>]"
    exit 1
    ;;
  *)  # nome da skill direto
    fetch_index
    install_skill "$1"
    ;;
esac
