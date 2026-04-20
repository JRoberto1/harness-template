#!/bin/bash
# ============================================================
# Harness Health Check
# Uso: bash scripts/health-check.sh
# ============================================================
GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; BOLD='\033[1m'; NC='\033[0m'
ISSUES=0

ok()   { echo -e "${GREEN}✓${NC} $1"; }
fail() { echo -e "${RED}✗${NC} $1 ${RED}← ausente: $2${NC}"; ISSUES=$((ISSUES+1)); }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }

echo ""; echo -e "${BOLD}Harness Health Check${NC}"; echo "================================"

echo ""; echo -e "${BOLD}[ Arquivos Núcleo ]${NC}"
[ -f "AGENTS.md" ] && ok "AGENTS.md" || fail "AGENTS.md" "AGENTS.md"
[ -f "CLAUDE.md" ] && ok "CLAUDE.md (espelho)" || warn "CLAUDE.md ausente — rode: cp AGENTS.md CLAUDE.md"
[ -f "GEMINI.md" ] && ok "GEMINI.md (espelho)" || warn "GEMINI.md ausente — rode: cp AGENTS.md GEMINI.md"

echo ""; echo -e "${BOLD}[ Camada 1 — Directives ]${NC}"
[ -d "directives" ] && ok "directives/" || fail "directives/" "directives/"
[ -f "directives/DIRECTIVE-template.md" ] && ok "template de directive" || fail "template" "directives/DIRECTIVE-template.md"

echo ""; echo -e "${BOLD}[ Camada 3 — Execution ]${NC}"
[ -d "execution" ] && ok "execution/" || fail "execution/" "execution/"
[ -f "execution/SCRIPT-template.py" ] && ok "template de script" || fail "template" "execution/SCRIPT-template.py"

echo ""; echo -e "${BOLD}[ Framework DOE ]${NC}"
for f in "doe/diretrizes.md" "doe/orquestracao.md" "doe/execucao.md"; do
  [ -f ".harness/$f" ] && ok ".harness/$f" || fail "$f" ".harness/$f"
done

echo ""; echo -e "${BOLD}[ Ciclo PEV ]${NC}"
[ -f ".harness/pev/pev.md" ] && ok ".harness/pev/pev.md" || fail "pev.md" ".harness/pev/pev.md"

echo ""; echo -e "${BOLD}[ Domínios ]${NC}"
for d in saas api automation juridico-financeiro; do
  [ -f ".harness/domains/${d}.md" ] && ok "domain: $d" || fail "$d" ".harness/domains/${d}.md"
done

echo ""; echo -e "${BOLD}[ Skills ]${NC}"
[ -d ".harness/skills" ] && ok ".harness/skills/" || fail "skills/" ".harness/skills/"
[ -f ".harness/skills/SKILL-template.md" ] && ok "SKILL-template.md" || fail "template" ".harness/skills/SKILL-template.md"
INSTALLED=$(find ".harness/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
[ "$INSTALLED" -gt 0 ] && ok "${INSTALLED} skill(s) instalada(s)" || warn "Nenhuma skill instalada — rode: bash scripts/fetch-skill.sh --bundle essentials"

echo ""; echo -e "${BOLD}[ Quality Gate ]${NC}"
[ -x ".git/hooks/pre-commit" ] && ok "pre-commit hook instalado" || warn "Hook ausente — rode: cp .harness/quality-gates/pre-commit .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit"

echo ""; echo -e "${BOLD}[ Docs ]${NC}"
[ -f "docs/architecture.md" ] && ok "docs/architecture.md" || fail "architecture.md" "docs/architecture.md"
[ -f "docs/domain-rules.md" ] && ok "docs/domain-rules.md" || fail "domain-rules.md" "docs/domain-rules.md"
[ -f "docs/coding-standards.md" ] && ok "docs/coding-standards.md" || fail "coding-standards.md" "docs/coding-standards.md"

echo ""; echo -e "${BOLD}[ AGENTS.md — Qualidade ]${NC}"
if [ -f "AGENTS.md" ]; then
  LINES=$(wc -l < AGENTS.md)
  [ "$LINES" -le 120 ] && ok "Tamanho OK ($LINES linhas)" || warn "Muito longo ($LINES linhas) — mova detalhes para docs/"
  grep -q "\[x\]" AGENTS.md && ok "Domínios configurados" || warn "Nenhum domínio ativo — marque [x] no AGENTS.md"
  grep -q "Skills Instaladas" AGENTS.md && ok "Seção de skills presente" || warn "Sem seção de skills — instale com fetch-skill.sh"
fi

echo ""; echo "================================"
if [ $ISSUES -eq 0 ]; then
  echo -e "${GREEN}✅ Harness íntegro${NC}"
else
  echo -e "${RED}❌ $ISSUES problema(s) — veja acima${NC}"
  echo "   Para reinicializar: bash scripts/init-project.sh"
  exit 1
fi
echo ""
