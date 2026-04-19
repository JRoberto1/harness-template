#!/usr/bin/env python3
"""
execution/SCRIPT-template.py

Camada 3: Script determinístico.
Confiável, testável, bem comentado.
Variáveis de ambiente e tokens vivem no .env — nunca hardcoded aqui.

Uso:
    python execution/SCRIPT-template.py --input "valor" [--dry-run]

Retorno:
    JSON para stdout (sucesso ou erro)
    Exit code 0 = sucesso, 1 = erro esperado, 2 = erro inesperado
"""

import argparse
import json
import os
import sys
from datetime import datetime, timezone

# ── Carregar .env se existir ─────────────────────────────────
try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass  # dotenv opcional — variáveis podem vir do ambiente

# ── Variáveis obrigatórias ───────────────────────────────────
# Valide no startup — não em runtime. Falha cedo é melhor.
REQUIRED_ENV = []  # ex: ["DATABASE_URL", "API_KEY"]
missing = [k for k in REQUIRED_ENV if not os.getenv(k)]
if missing:
    print(json.dumps({
        "status": "error",
        "erro": f"Variáveis de ambiente ausentes: {', '.join(missing)}",
        "acao": "Configure as variáveis no arquivo .env"
    }))
    sys.exit(1)


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", required=True, help="[descreva o input]")
    parser.add_argument("--dry-run", action="store_true",
                        help="Simula sem executar efeitos colaterais")
    return parser.parse_args()


def validar_input(valor: str) -> dict:
    """Valida o input antes de processar. Retorna erro se inválido."""
    if not valor or not valor.strip():
        return {"valido": False, "erro": "Input não pode ser vazio"}
    # Adicione outras validações específicas aqui
    return {"valido": True}


def executar(input_valor: str, dry_run: bool) -> dict:
    """
    Lógica principal — determinística e testável.
    Sem side effects externos se dry_run=True.
    """
    if dry_run:
        return {
            "status": "success",
            "dry_run": True,
            "simulacao": f"Processaria: {input_valor}",
            "timestamp": datetime.now(timezone.utc).isoformat()
        }

    # ── Implemente a lógica aqui ─────────────────────────────
    resultado = {
        "processado": input_valor,
        "timestamp": datetime.now(timezone.utc).isoformat()
    }

    return {
        "status": "success",
        "resultado": resultado
    }


def main():
    args = parse_args()

    # 1. Validar input
    validacao = validar_input(args.input)
    if not validacao["valido"]:
        print(json.dumps({
            "status": "error",
            "erro": validacao["erro"],
            "acao": "Forneça um input válido conforme a directive"
        }))
        sys.exit(1)

    # 2. Executar
    try:
        resultado = executar(args.input, args.dry_run)
        print(json.dumps(resultado, ensure_ascii=False, indent=2))
        sys.exit(0)

    except Exception as e:
        # Falha explícita — nunca silenciosa
        print(json.dumps({
            "status": "error",
            "erro": str(e),
            "tipo": type(e).__name__,
            "acao": "Verifique os logs e a directive correspondente",
            "timestamp": datetime.now(timezone.utc).isoformat()
        }))
        sys.exit(2)


if __name__ == "__main__":
    main()
