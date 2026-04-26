#!/usr/bin/env python3
"""
execution/handoff.py — Bifrost v2.3.0
Gera um artefato estruturado JSON/YAML do estado atual do projeto
para iniciar um novo agente com contexto limpo e preciso.

Diferença do last-session.md:
  last-session.md → resumo de conversa em Markdown (contexto humano)
  handoff.json    → estado estruturado do projeto (contexto de agente)

Uso:
    python execution/handoff.py --create --tema "auth-jwt"
    python execution/handoff.py --read
    python execution/handoff.py --brief   (imprime prompt de retomada)
"""
import argparse, json, subprocess, sys
from datetime import datetime, timezone
from pathlib import Path

VERSION      = "2.3.0"
HANDOFF_FILE = ".harness/memory/handoff.json"
MEMORY_DIR   = ".harness/memory"

def git_info() -> dict:
    """Coleta informações do estado atual do git."""
    def run(cmd):
        try:
            return subprocess.check_output(cmd, shell=True, text=True,
                                           stderr=subprocess.DEVNULL).strip()
        except Exception:
            return ""

    return {
        "branch":          run("git branch --show-current"),
        "last_commit":     run("git log -1 --format='%h %s'"),
        "last_commit_hash": run("git log -1 --format='%H'"),
        "modified_files":  [f for f in run("git diff --name-only").split("\n") if f],
        "staged_files":    [f for f in run("git diff --cached --name-only").split("\n") if f],
        "untracked":       [f for f in run("git ls-files --others --exclude-standard").split("\n") if f][:5],
    }

def read_progress() -> dict:
    """Lê o claude-progress.txt se existir."""
    p = Path("claude-progress.txt")
    if not p.exists():
        return {}
    content = p.read_text(encoding="utf-8")
    return {
        "raw_preview": content[:500],
        "has_blockers": "🚧" in content,
        "sessions": int((content.split("Sessões:")[-1].strip().split()[0]
                        if "Sessões:" in content else "0")),
    }

def read_last_session() -> str:
    """Lê o resumo da última sessão."""
    p = Path(".harness/memory/last-session.md")
    if not p.exists():
        return ""
    content = p.read_text(encoding="utf-8")
    # Retorna só as primeiras 300 chars — o suficiente para o agente entender
    return content[:300]

def create_handoff(tema: str, next_task: str = "", blockers: str = "") -> dict:
    """Cria o handoff.json com estado atual."""
    Path(MEMORY_DIR).mkdir(parents=True, exist_ok=True)

    handoff = {
        "version":    VERSION,
        "created_at": datetime.now(timezone.utc).isoformat(),
        "tema":       tema,
        "git":        git_info(),
        "progress":   read_progress(),
        "context": {
            "last_session_preview": read_last_session(),
            "next_task":   next_task or "[definir]",
            "blockers":    blockers or "nenhum",
            "assumptions": [],
        },
        "agent_instructions": {
            "start_with": f"Leia este handoff.json e o AGENTS.md. Sua primeira tarefa é: {next_task or '[pergunte ao usuário]'}",
            "do_not":     ["Reiniciar trabalho já entregue", "Modificar protected_paths", "Fazer push sem aprovação"],
            "verify_first": ["Confirmar que os testes passam no estado atual", "Ler claude-progress.txt se existir"],
        }
    }

    Path(HANDOFF_FILE).write_text(
        json.dumps(handoff, ensure_ascii=False, indent=2),
        encoding="utf-8"
    )
    return handoff

def read_handoff() -> dict | None:
    """Lê o handoff.json existente."""
    p = Path(HANDOFF_FILE)
    if not p.exists():
        return None
    try:
        return json.loads(p.read_text(encoding="utf-8"))
    except Exception:
        return None

def brief_prompt(handoff: dict) -> str:
    """Gera o prompt de retomada para o novo agente."""
    git  = handoff.get("git", {})
    ctx  = handoff.get("context", {})
    inst = handoff.get("agent_instructions", {})

    return f"""# Bifrost Handoff — {handoff.get('tema', 'projeto')}
Criado: {handoff.get('created_at', '')[:10]}

## Estado do Git
Branch: {git.get('branch', '?')}
Último commit: {git.get('last_commit', '?')}
Arquivos modificados: {', '.join(git.get('modified_files', [])) or 'nenhum'}

## Próxima Tarefa
{ctx.get('next_task', '[pergunte ao usuário]')}

## Bloqueios Conhecidos
{ctx.get('blockers', 'nenhum')}

## Instruções
{inst.get('start_with', '')}

NÃO faça: {', '.join(inst.get('do_not', []))}
Verifique primeiro: {', '.join(inst.get('verify_first', []))}

---
Leia também:
- AGENTS.md (regras do harness)
- claude-progress.txt (progresso de features)
- .harness/memory/last-session.md (contexto da conversa)
"""

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--create",    action="store_true", help="Cria novo handoff.json")
    p.add_argument("--read",      action="store_true", help="Lê o handoff.json atual")
    p.add_argument("--brief",     action="store_true", help="Imprime prompt de retomada")
    p.add_argument("--tema",      default="sessão", help="Nome do tema/feature")
    p.add_argument("--next-task", default="", help="Próxima tarefa para o agente")
    p.add_argument("--blockers",  default="", help="Bloqueios conhecidos")
    args = p.parse_args()

    if args.create:
        handoff = create_handoff(args.tema, args.next_task, args.blockers)
        print(json.dumps({
            "status": "success",
            "arquivo": HANDOFF_FILE,
            "tema": args.tema,
            "git_branch": handoff["git"].get("branch", "?"),
            "next_task": handoff["context"]["next_task"],
        }, ensure_ascii=False))

    elif args.read:
        handoff = read_handoff()
        if not handoff:
            print(json.dumps({"status": "not_found", "arquivo": HANDOFF_FILE}))
            sys.exit(1)
        print(json.dumps(handoff, ensure_ascii=False, indent=2))

    elif args.brief:
        handoff = read_handoff()
        if not handoff:
            print("Nenhum handoff.json encontrado. Rode: python execution/handoff.py --create")
            sys.exit(1)
        print(brief_prompt(handoff))

    else:
        p.print_help()

if __name__ == "__main__":
    main()
