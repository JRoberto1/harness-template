#!/usr/bin/env python3
"""
execution/compress-history.py — Bifrost v2.0.0
Comprime histórico de conversa mantendo apenas o essencial.
Reduz consumo de tokens em sessões longas.

Uso:
    python execution/compress-history.py --auto
    python execution/compress-history.py --input historico.json
    python execution/compress-history.py --estimate --input historico.json
    python execution/compress-history.py --dry-run --input historico.json
"""
import argparse, json, os, re, sys
from datetime import datetime, timezone
from pathlib import Path

VERSION         = "2.0.0"
MEMORY_DIR      = ".harness/memory"
LAST_SESSION    = f"{MEMORY_DIR}/last-session.md"
COMPRESS_AFTER  = 8
TOKENS_PER_CHAR = 0.25

def est(text): return int(len(text) * TOKENS_PER_CHAR)

DISCARD = [
    r"^(sim|ok|entendido|pode continuar|certo|perfeito|ótimo|exato|claro|certamente)[\.\!]?$",
    r"^vou (fazer|executar|implementar|verificar|analisar)",
    r"^estou (pensando|analisando|verificando|processando)",
    r"^(como solicitado|como pedido|como mencionado)",
    r"^(ótima pergunta|boa pergunta)",
]
KEEP = [
    r"ERRO:|FALHA:|AVISO:|VERIFICAR",
    r"decisão:|decidido:|optamos por|aprovado",
    r"próximo passo|próxima etapa|pendente|falta",
    r"implementado:|concluído:|feito:|✓|✅",
    r"aprendizado|hashimoto|descobri|harness",
]

def discard(t): return any(re.search(p, t.lower().strip()) for p in DISCARD)
def keep(t):    return any(re.search(p, t, re.IGNORECASE) for p in KEEP)

def compress(messages):
    decisions, errors, done, pending, learnings = [], [], [], [], []
    last_state = ""; disc = 0; kept = 0
    for i, m in enumerate(messages):
        content = m.get("content", ""); role = m.get("role", "")
        if not content: continue
        if role == "assistant" and i == len(messages)-1:
            last_state = content[:500]; kept += 1; continue
        if discard(content): disc += 1; continue
        if keep(content):
            kept += 1
            if re.search(r"ERRO:|FALHA:", content, re.I): errors.append(content[:200])
            if re.search(r"decisão:|decidido:|aprovado", content, re.I): decisions.append(content[:200])
            if re.search(r"implementado:|concluído:|✓|✅", content, re.I): done.append(content[:150])
            if re.search(r"próximo passo|pendente|falta", content, re.I): pending.append(content[:150])
            if re.search(r"aprendizado|hashimoto|descobri", content, re.I): learnings.append(content[:150])
        else: disc += 1
    orig  = sum(est(m.get("content","")) for m in messages)
    comp  = est(last_state) + sum(est(t) for t in decisions+errors+done)
    return {
        "data": datetime.now(timezone.utc).isoformat(),
        "msgs_orig": len(messages), "msgs_disc": disc, "msgs_kept": kept,
        "tokens_orig": orig, "tokens_comp": comp,
        "reducao_pct": round((1 - comp/max(orig,1))*100),
        "estado_atual": last_state, "decisoes": decisions,
        "erros": errors, "concluido": done, "pendente": pending, "aprendizados": learnings,
    }

def render(s):
    lines = [
        f"# Sessão Comprimida — {s['data'][:10]}",
        f"\n**Compressão:** {s['msgs_disc']}/{s['msgs_orig']} msgs descartadas · {s['reducao_pct']}% menos tokens ({s['tokens_orig']:,} → {s['tokens_comp']:,})",
        "",
    ]
    if s["estado_atual"]: lines += ["## Estado Atual", s["estado_atual"], ""]
    if s["decisoes"]:     lines += ["## Decisões"] + [f"- {d}" for d in s["decisoes"]] + [""]
    if s["concluido"]:    lines += ["## Concluído"] + [f"- [x] {d}" for d in s["concluido"]] + [""]
    if s["pendente"]:     lines += ["## Pendente"] + [f"- [ ] {p}" for p in s["pendente"]] + [""]
    if s["erros"]:        lines += ["## Erros"] + [f"- {e}" for e in s["erros"]] + [""]
    if s["aprendizados"]: lines += ["## Aprendizados (Hashimoto)"] + [f"- {a}" for a in s["aprendizados"]] + [""]
    lines += ["---", f"*Gerado por compress-history.py v{VERSION}*", "*Para retomar: /brief-session*"]
    return "\n".join(lines)

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--auto",     action="store_true")
    p.add_argument("--input",    help="JSON com mensagens")
    p.add_argument("--output",   help="Arquivo de saída")
    p.add_argument("--estimate", action="store_true")
    p.add_argument("--dry-run",  action="store_true")
    args = p.parse_args()

    Path(MEMORY_DIR).mkdir(parents=True, exist_ok=True)

    messages = []
    if args.input and Path(args.input).exists():
        with open(args.input, encoding="utf-8") as f:
            data = json.load(f)
            messages = data if isinstance(data, list) else data.get("messages", [])

    if not messages:
        print(json.dumps({"status": "skip", "motivo": "Nenhuma mensagem para comprimir"}))
        sys.exit(0)

    if args.auto and len(messages) < COMPRESS_AFTER:
        print(json.dumps({"status": "skip", "motivo": f"Apenas {len(messages)} turnos — comprime após {COMPRESS_AFTER}"}))
        sys.exit(0)

    if args.estimate:
        total = sum(est(m.get("content","")) for m in messages)
        print(json.dumps({"status": "estimate", "msgs": len(messages), "tokens_est": total,
                          "recomendacao": "comprimir" if len(messages) >= COMPRESS_AFTER else "aguardar"}))
        sys.exit(0)

    summary  = compress(messages)
    markdown = render(summary)

    if args.dry_run:
        print(markdown)
        sys.exit(0)

    out = args.output or LAST_SESSION
    with open(out, "w", encoding="utf-8") as f: f.write(markdown)

    print(json.dumps({
        "status": "success", "arquivo": out,
        "reducao_pct": summary["reducao_pct"],
        "tokens_antes": summary["tokens_orig"], "tokens_depois": summary["tokens_comp"],
    }, ensure_ascii=False))

if __name__ == "__main__": main()
