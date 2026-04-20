# /context-check — Verificar e Otimizar Contexto

Verifica o estado atual do contexto e aplica otimizações se necessário.
Funciona em qualquer runtime — Claude Code tem o comando `/context-check`,
outros runtimes usam o prompt diretamente.

## Como usar

```
/context-check
/context-check --compress
```

## Instruções para o Agente

### 1. Auditar o contexto atual

Verifique e reporte:

```
📊 Auditoria de Contexto

Directives carregadas: [lista]
Domínios carregados: [lista]
Turnos desta sessão: [N]
Tokens estimados: [N]k

Status: ✅ OK | ⚠️ Atenção | 🔴 Comprimir
```

### 2. Se `--compress` ou status 🔴

Execute:
```bash
python execution/compress-history.py --auto
```

Se Python não disponível, resuma manualmente:
- Decisões tomadas nesta sessão
- Estado atual do projeto
- Próximos passos
- Salve em `.harness/memory/last-session.md`

### 3. Recomendações

Se directives desnecessárias carregadas:
→ "Posso descarregar X e Y para liberar contexto. Confirma?"

Se output verbose detectado:
→ Ative modo conciso: respostas máximo 3 linhas a partir daqui.
