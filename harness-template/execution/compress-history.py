#!/usr/bin/env python3
"""
execution/compress-history.py

Comprime o histórico de conversa mantendo apenas o essencial.
Reduz consumo de tokens em sessões longas.

Uso:
    python execution/compress-history.py --auto
    python execution/compress-history.py --input historico.json --output resumo.md
    python execution/compress-history.py --estimate --input historico.json
    python execution/compress-history.py --dry-run
"""

import argparse
import json
import os
import sys
import re
from datetime import datetime, timezone
from pathlib import Path

# ── Configuração ─────────────────────────────────────────────
MEMORY_DIR     = ".harness/memory"
LAST_SESSION   = f"{MEMORY_DIR}/last-session.md"
COMPRESS_AFTER = 8   # turnos antes de comprimir
TOKENS_PER_CHAR = 0.25  # estimativa: 1 token ≈ 4 chars


def estimate_tokens(text: str) -> int:
    return int(len(text) * TOKENS_PER_CHAR)


# ── Padrões para descartar ────────────────────────────────────
DISCARD_PATTERNS = [
    r"^(sim|ok|entendido|pode continuar|certo|perfeito|ótimo|exato)[\.\!]?$",
    r"^vou (fazer|executar|implementar|verificar|analisar)",
    r"^estou (pensando|analisando|verificando|processando)",
    r"^como (solicitado|pedido|mencionado)",
    r"^(claro|certamente|com prazer)",
    r"entendido, (vou|irei)",
]

KEEP_PATTERNS = [
    r"ERRO:|FALHA:|AVISO:",
    r"decisão:|decidido:|optamos por",
    r"próximo passo|próxima etapa",
    r"implementado:|concluído:|feito:",
    r"\[VERIFICAR\]|\[DADO_AUSENTE\]",
    r"harness|hashimoto|regra",
]


def should_discard(text: str) -> bool:
    text_lower = text.lower().strip()
    for pattern in DISCARD_PATTERNS:
        if re.search(pattern, text_lower):
            return True
    return False


def should_keep(text: str) -> bool:
    for pattern in KEEP_PATTERNS:
        if re.search(pattern, text, re.IGNORECASE):
            return True
    return False


# ── Compressor principal ──────────────────────────────────────
def compress_messages(messages: list) -> dict:
    """
    Recebe lista de mensagens e retorna resumo estruturado.
    Formato de mensagem: {"role": "user|assistant", "content": "texto"}
    """
    decisions     = []
    errors        = []
    completed     = []
    pending       = []
    learnings     = []
    last_state    = ""
    discarded     = 0
    kept          = 0

    for i, msg in enumerate(messages):
        content = msg.get("content", "")
        role    = msg.get("role", "")

        if not content:
            continue

        # Último turno do assistente = estado atual
        if role == "assistant" and i == len(messages) - 1:
            last_state = content[:500]
            kept += 1
            continue

        # Descartar confirmações simples
        if should_discard(content):
            discarded += 1
            continue

        # Manter informações críticas
        if should_keep(content):
            kept += 1

            if re.search(r"ERRO:|FALHA:", content, re.IGNORECASE):
                errors.append(content[:200])

            if re.search(r"decisão:|decidido:|optamos", content, re.IGNORECASE):
                decisions.append(content[:200])

            if re.search(r"implementado:|concluído:|✓", content, re.IGNORECASE):
                completed.append(content[:150])

            if re.search(r"próximo passo|pendente|falta", content, re.IGNORECASE):
                pending.append(content[:150])

            if re.search(r"aprendizado|hashimoto|descobri", content, re.IGNORECASE):
                learnings.append(content[:150])
        else:
            discarded += 1

    original_tokens  = sum(estimate_tokens(m.get("content", "")) for m in messages)
    compressed_tokens = estimate_tokens(last_state) + \
                        sum(estimate_tokens(t) for t in decisions + errors + completed)

    return {
        "data":               datetime.now(timezone.utc).isoformat(),
        "mensagens_originais": len(messages),
        "mensagens_descartadas": discarded,
        "mensagens_mantidas":  kept,
        "tokens_originais":   original_tokens,
        "tokens_comprimidos": compressed_tokens,
        "reducao_pct":        round((1 - compressed_tokens / max(original_tokens, 1)) * 100),
        "estado_atual":       last_state,
        "decisoes":           decisions,
        "erros":              errors,
        "concluido":          completed,
        "pendente":           pending,
        "aprendizados":       learnings,
    }


def render_markdown(summary: dict) -> str:
    """Converte resumo em markdown para last-session.md"""
    lines = [
        f"# Sessão Comprimida — {summary['data'][:10]}",
        "",
        f"**Compressão:** {summary['mensagens_descartadas']}/{summary['mensagens_originais']} "
        f"mensagens descartadas · "
        f"{summary['reducao_pct']}% menos tokens "
        f"({summary['tokens_originais']:,} → {summary['tokens_comprimidos']:,})",
        "",
    ]

    if summary["estado_atual"]:
        lines += ["## Estado Atual", summary["estado_atual"], ""]

    if summary["decisoes"]:
        lines += ["## Decisões Tomadas"]
        lines += [f"- {d}" for d in summary["decisoes"]]
        lines += [""]

    if summary["concluido"]:
        lines += ["## Concluído"]
        lines += [f"- [x] {c}" for c in summary["concluido"]]
        lines += [""]

    if summary["pendente"]:
        lines += ["## Pendente"]
        lines += [f"- [ ] {p}" for p in summary["pendente"]]
        lines += [""]

    if summary["erros"]:
        lines += ["## Erros Encontrados"]
        lines += [f"- {e}" for e in summary["erros"]]
        lines += [""]

    if summary["aprendizados"]:
        lines += ["## Aprendizados (Hashimoto)"]
        lines += [f"- {a}" for a in summary["aprendizados"]]
        lines += [""]

    lines += [
        "---",
        "*Gerado por execution/compress-history.py*",
        "*Para retomar: leia este arquivo antes de iniciar*",
    ]

    return "\n".join(lines)


# ── Entry point ───────────────────────────────────────────────
def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--auto",     action="store_true",
                        help="Comprime automaticamente se >8 turnos")
    parser.add_argument("--input",    help="Arquivo JSON com histórico de mensagens")
    parser.add_argument("--output",   help="Arquivo de saída (padrão: last-session.md)")
    parser.add_argument("--estimate", action="store_true",
                        help="Só estima tokens, não comprime")
    parser.add_argument("--dry-run",  action="store_true",
                        help="Mostra o que seria feito sem executar")
    args = parser.parse_args()

    # Garantir pasta de memória
    Path(MEMORY_DIR).mkdir(parents=True, exist_ok=True)

    # Carregar histórico
    messages = []
    if args.input and Path(args.input).exists():
        with open(args.input, encoding="utf-8") as f:
            data = json.load(f)
            messages = data if isinstance(data, list) else data.get("messages", [])
    elif args.auto:
        # Modo auto: tenta ler last-session se existir
        if Path(LAST_SESSION).exists():
            print(json.dumps({
                "status": "skip",
                "motivo": "last-session.md já existe — use --input para forçar"
            }))
            sys.exit(0)
        print(json.dumps({
            "status": "skip",
            "motivo": "Nenhum histórico encontrado para comprimir"
        }))
        sys.exit(0)

    if not messages:
        print(json.dumps({
            "status": "error",
            "erro": "Nenhuma mensagem encontrada",
            "acao": "Forneça --input com um arquivo JSON de mensagens"
        }))
        sys.exit(1)

    # Verificar se vale comprimir
    if args.auto and len(messages) < COMPRESS_AFTER:
        print(json.dumps({
            "status": "skip",
            "motivo": f"Apenas {len(messages)} turnos — compressão após {COMPRESS_AFTER}"
        }))
        sys.exit(0)

    # Só estimar
    if args.estimate:
        total = sum(estimate_tokens(m.get("content", "")) for m in messages)
        print(json.dumps({
            "status":        "estimate",
            "mensagens":     len(messages),
            "tokens_est":    total,
            "recomendacao":  "comprimir" if len(messages) >= COMPRESS_AFTER else "aguardar"
        }))
        sys.exit(0)

    # Comprimir
    summary  = compress_messages(messages)
    markdown = render_markdown(summary)

    if args.dry_run:
        print(markdown)
        print(json.dumps({
            "status": "dry_run",
            "reducao_pct": summary["reducao_pct"],
            "tokens_originais": summary["tokens_originais"],
            "tokens_comprimidos": summary["tokens_comprimidos"]
        }))
        sys.exit(0)

    # Salvar
    output_path = args.output or LAST_SESSION
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(markdown)

    print(json.dumps({
        "status":          "success",
        "arquivo":         output_path,
        "reducao_pct":     summary["reducao_pct"],
        "tokens_antes":    summary["tokens_originais"],
        "tokens_depois":   summary["tokens_comprimidos"],
        "mensagens_antes": summary["mensagens_originais"],
        "mensagens_apos":  summary["mensagens_mantidas"],
    }, ensure_ascii=False))


if __name__ == "__main__":
    main()
