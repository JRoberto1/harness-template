#!/bin/bash
# ============================================================
# Harness Init — inicializa o harness em um projeto
# Uso: bash /caminho/do/harness-template/scripts/init-project.sh
# ============================================================
set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

HARNESS_VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")"
TARGET_DIR="$(pwd)"

echo ""
echo -e "${BOLD}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}║    Harness Engineering — Init v${HARNESS_VERSION}   ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════╝${NC}"
echo ""

# ── Detectar runtime ──────────────────────────────────────────
detect_runtime() {
  if command -v claude &>/dev/null; then echo "claude"
  elif [ -d "$HOME/.gemini/antigravity" ]; then echo "antigravity"
  elif [ -d "$HOME/.config/opencode" ]; then echo "opencode"
  else echo "generic"; fi
}
RUNTIME=$(detect_runtime)
echo -e "Runtime detectado: ${BLUE}${RUNTIME}${NC}"
echo ""

# ── 1. Informações do projeto ─────────────────────────────────
echo -e "${BOLD}[ 1/6 ] Configuração do Projeto${NC}"
read -rp "  Nome: " PROJECT_NAME
read -rp "  Descrição (uma linha): " PROJECT_DESC
read -rp "  Stack (ex: Next.js + Node + PostgreSQL): " PROJECT_STACK
echo ""

# ── 2. Domínios ───────────────────────────────────────────────
echo -e "${BOLD}[ 2/6 ] Domínios Ativos${NC}"
read -rp "  SaaS / Produto Web? [s/n]: " D_SAAS
read -rp "  API / Backend? [s/n]: " D_API
read -rp "  Automação / Scripts? [s/n]: " D_AUTO
read -rp "  Jurídico / Financeiro? [s/n]: " D_JF
echo ""

# ── 3. Copiar estrutura ───────────────────────────────────────
echo -e "${BOLD}[ 3/6 ] Copiando template...${NC}"

# .harness/
cp -r "$TEMPLATE_DIR/.harness" "$TARGET_DIR/"
echo "$HARNESS_VERSION" > "$TARGET_DIR/.harness/VERSION"

# directives/ e execution/
cp -r "$TEMPLATE_DIR/directives" "$TARGET_DIR/"
cp -r "$TEMPLATE_DIR/execution"  "$TARGET_DIR/"

# docs/
cp -r "$TEMPLATE_DIR/docs" "$TARGET_DIR/"

# scripts/
mkdir -p "$TARGET_DIR/scripts"
for s in fetch-skill.sh health-check.sh; do
  [ -f "$TEMPLATE_DIR/scripts/$s" ] && cp "$TEMPLATE_DIR/scripts/$s" "$TARGET_DIR/scripts/"
done
chmod +x "$TARGET_DIR/scripts/"*.sh 2>/dev/null || true

# .tmp/
mkdir -p "$TARGET_DIR/.tmp"
echo "# Arquivos intermediários — sempre regeneráveis. Não commite." > "$TARGET_DIR/.tmp/.gitkeep"

echo -e "${GREEN}✓ Template copiado${NC}"

# ── 4. Gerar AGENTS.md personalizado ─────────────────────────
echo ""
echo -e "${BOLD}[ 4/6 ] Gerando AGENTS.md...${NC}"

mark() { [ "$1" = "s" ] && echo "x" || echo " "; }

cat > "$TARGET_DIR/AGENTS.md" << AGENTS_EOF
# AGENTS.md — ${PROJECT_NAME}
<!-- Este arquivo é espelhado como CLAUDE.md e GEMINI.md -->
<!-- Claude Code · Antigravity · OpenCode · Cursor · Copilot -->

> Leia este arquivo **completamente** antes de qualquer ação.

---

## Identidade

Você é um agente de engenharia do projeto **${PROJECT_NAME}**.
${PROJECT_DESC}

Stack: ${PROJECT_STACK}

Você opera dentro de uma **arquitetura de 3 camadas**:
- **Camada 1 — Directives** (\`directives/\`): SOPs — o QUE fazer
- **Camada 2 — Agente (você)**: roteamento inteligente entre directives e scripts
- **Camada 3 — Execution** (\`execution/\`): scripts determinísticos — COMO fazer

---

## Regras Absolutas

1. **Nunca avance** sem validar o output da etapa anterior
2. **Nunca invente** — marque \`[VERIFICAR: motivo]\` se não tiver certeza
3. **Nunca quebre** a arquitetura de camadas de \`/docs/architecture.md\`
4. **Verifique \`execution/\` primeiro** — só crie script novo se não existir
5. **Nunca use** \`any\` em TypeScript nem ignore erros silenciosamente
6. **Aplique o Protocolo PEV** em tarefas com 3+ arquivos
7. **Aplique a Regra de Hashimoto**: cada erro vira melhoria permanente no harness

---

## Loop de Self-Annealing

Quando algo quebrar:
1. Leia o erro e stack trace · 2. Corrija · 3. Teste
4. Atualize a directive em \`directives/\` com o aprendizado
5. Se recorrente → atualize o harness

---

## Protocolo PEV (tarefas complexas)

\`\`\`
PLAN    → critérios verificáveis antes de qualquer código
EXECUTE → estritamente dentro do plano aprovado
VERIFY  → falha = volta ao Plan com contexto de erro
\`\`\`

---

## Domínios Ativos

- [$(mark "$D_SAAS")] SaaS Web              → \`.harness/domains/saas.md\`
- [$(mark "$D_API")] API / Backend         → \`.harness/domains/api.md\`
- [$(mark "$D_AUTO")] Automação / Scripts   → \`.harness/domains/automation.md\`
- [$(mark "$D_JF")] Jurídico / Financeiro → \`.harness/domains/juridico-financeiro.md\`

---

## Skills Instaladas

> Leia a skill antes de executar a tarefa correspondente.
> Instale novas: \`bash scripts/fetch-skill.sh <nome>\`

- \`.harness/skills/SKILL-template.md\` → template para criar skills do projeto

---

*Harness v${HARNESS_VERSION} — inicializado em $(date +%Y-%m-%d)*
AGENTS_EOF

# Espelhar para outros runtimes
cp "$TARGET_DIR/AGENTS.md" "$TARGET_DIR/CLAUDE.md"
cp "$TARGET_DIR/AGENTS.md" "$TARGET_DIR/GEMINI.md"

echo -e "${GREEN}✓ AGENTS.md, CLAUDE.md e GEMINI.md gerados${NC}"

# ── 5. Quality gate ───────────────────────────────────────────
echo ""
echo -e "${BOLD}[ 5/6 ] Instalando Quality Gate...${NC}"
if [ -d "$TARGET_DIR/.git" ]; then
  cp "$TARGET_DIR/.harness/quality-gates/pre-commit" "$TARGET_DIR/.git/hooks/pre-commit"
  chmod +x "$TARGET_DIR/.git/hooks/pre-commit"
  echo -e "${GREEN}✓ Pre-commit hook instalado${NC}"
else
  echo -e "${YELLOW}⚠ Repositório git não encontrado — rode 'git init' e repita o init${NC}"
fi

# ── 6. Runtime-specific ───────────────────────────────────────
echo ""
echo -e "${BOLD}[ 6/6 ] Configuração específica do runtime...${NC}"
case $RUNTIME in
  claude)
    mkdir -p "$TARGET_DIR/.claude"
    cat > "$TARGET_DIR/.claude/settings.json" << 'EOF'
{
  "permissions": {
    "allow": [
      "Bash(date:*)", "Bash(echo:*)", "Bash(cat:*)", "Bash(ls:*)",
      "Bash(mkdir:*)", "Bash(grep:*)", "Bash(git add:*)", "Bash(git commit:*)",
      "Bash(git status:*)", "Bash(git log:*)", "Bash(git diff:*)",
      "Bash(npm test:*)", "Bash(npm run:*)", "Bash(python:*)",
      "Bash(bash scripts/*:*)"
    ],
    "deny": ["Read(.env)", "Read(.env.*)", "Read(**/*.pem)", "Read(**/*.key)"]
  }
}
EOF
    echo -e "${GREEN}✓ Claude Code (.claude/settings.json)${NC}" ;;
  antigravity)
    echo -e "${GREEN}✓ Antigravity — AGENTS.md + GEMINI.md lidos automaticamente${NC}" ;;
  opencode)
    echo -e "${GREEN}✓ OpenCode — AGENTS.md lido automaticamente${NC}" ;;
  *)
    echo -e "${YELLOW}ℹ Runtime genérico — certifique-se que AGENTS.md é lido pelo seu runtime${NC}" ;;
esac

# ── Resumo ────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}║         ✅ Harness Pronto!           ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════╝${NC}"
echo ""
echo -e "Projeto: ${BLUE}${PROJECT_NAME}${NC} · Runtime: ${BLUE}${RUNTIME}${NC}"
echo ""
echo -e "${BOLD}Próximos passos:${NC}"
echo "  1. Preencha docs/architecture.md  → stack e arquitetura"
echo "  2. Preencha docs/domain-rules.md  → regras de negócio"
echo "  3. bash scripts/fetch-skill.sh --bundle essentials  → skills básicas"
echo "  4. bash scripts/health-check.sh   → verificar integridade"
echo ""
echo -e "  ${YELLOW}Opcional:${NC} npx get-shit-done-cc@latest  → adicionar GSD por cima"
echo ""
