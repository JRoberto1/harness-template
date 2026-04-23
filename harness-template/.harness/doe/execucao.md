# DOE — Execução
# Camada 2→3: Como o Agente Chama Scripts Determinísticos

## Princípio

> Scripts determinísticos > agente improvisando.
> Se existe um script para a tarefa, use o script.

## Scripts Disponíveis

| Script | O que faz | Quando usar |
|--------|-----------|------------|
| `execution/compress-history.py` | Comprime histórico de sessão | Após 8 turnos |

## Template de Chamada de Script

```bash
# Sempre use --dry-run primeiro para validar
python execution/[script].py --dry-run --input "[valor]"

# Após validar, execute de verdade
python execution/[script].py --input "[valor]"
```

## Verificação de Output

Após executar qualquer script:
1. Verifique se o JSON de saída tem `"status": "success"`
2. Se `"status": "error"` → reporte ERRO/CAUSA/AÇÃO
3. Nunca avance se o script retornou erro

## Criar Novo Script

Antes de criar um script novo:
1. Verifique se já existe em `execution/`
2. Use `execution/SCRIPT-template.py` como base
3. O script deve ter obrigatoriamente: `--dry-run`, output JSON, tratamento de erro
4. Registre em `execution/README.md` (crie se não existir)

## Prompt para Sub-agente de Execução

```
CONTEXTO: [mínimo necessário]
TAREFA: Execute [script] com os parâmetros [X]
SAÍDA ESPERADA: JSON de resultado em máximo 500 tokens
PROIBIDO: Não modifique arquivos fora de [escopo]
```
