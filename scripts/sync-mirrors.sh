#!/bin/bash
# ============================================================
# Bifrost — Sync Mirrors
# Sincroniza AGENTS.md → CLAUDE.md e GEMINI.md automaticamente
#
# Uso:
#   bash scripts/sync-mirrors.sh
#   bash scripts/sync-mirrors.sh --watch   ← monitora mudanças
# ============================================================

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BOLD='\033[1m'; NC='\033[0m'

sync() {
  if [ ! -f "AGENTS.md" ]; then
    echo "AGENTS.md não encontrado. Rode npx harness-engineering primeiro."
    exit 1
  fi

  local changed=0

  # Sincronizar CLAUDE.md
  if ! diff -q "AGENTS.md" "CLAUDE.md" &>/dev/null 2>&1; then
    cp AGENTS.md CLAUDE.md
    echo -e "${GREEN}✓${NC} CLAUDE.md sincronizado"
    changed=1
  fi

  # Sincronizar GEMINI.md
  if ! diff -q "AGENTS.md" "GEMINI.md" &>/dev/null 2>&1; then
    cp AGENTS.md GEMINI.md
    echo -e "${GREEN}✓${NC} GEMINI.md sincronizado"
    changed=1
  fi

  [ $changed -eq 0 ] && echo -e "${GREEN}✓${NC} Espelhos já sincronizados"
}

# Modo watch — monitora mudanças no AGENTS.md
if [ "${1}" = "--watch" ]; then
  echo -e "${BOLD}Bifrost Mirror Sync — modo watch${NC}"
  echo "Monitorando AGENTS.md... (Ctrl+C para parar)"

  LAST_HASH=""
  while true; do
    CURRENT_HASH=$(md5sum AGENTS.md 2>/dev/null | cut -d' ' -f1)
    if [ "$CURRENT_HASH" != "$LAST_HASH" ] && [ -n "$CURRENT_HASH" ]; then
      sync
      LAST_HASH="$CURRENT_HASH"
    fi
    sleep 2
  done
else
  sync
fi
