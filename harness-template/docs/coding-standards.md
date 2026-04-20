# Padrões de Código

> O agente lê este arquivo antes de qualquer implementação.

---

## TypeScript / JavaScript

```typescript
// ❌ Proibido
function process(data: any) {}
try { await op(); } catch (e) {}   // erro silencioso

// ✅ Correto
function process(data: User) {}
try {
  await op();
} catch (error) {
  logger.error({ message: "Falha em op()", error, context: { userId } });
  throw error;
}
```

**Nomenclatura de funções:**
- Retornam boolean: `isValid()`, `hasPermission()`
- Buscam dado: `getUser()`, `fetchOrders()`
- Transformam: `formatDate()`, `parseResponse()`
- Executam efeito: `sendEmail()`, `createRecord()`

---

## Python

```python
# ❌ Proibido
def process(data):         # sem tipagem
    try: return fn(data)
    except: pass           # bare except

# ✅ Correto
def process(data: dict) -> ProcessedData:
    try:
        return fn(data)
    except DomainError as e:
        logger.error("Falha", extra={"error": str(e)})
        raise
```

---

## Scripts de Execução (`execution/`)

Todo script em `execution/` deve ter:
- `--dry-run` para simular sem executar
- Validação de variáveis de ambiente no startup
- Logs estruturados com job_id, step, timestamp
- Retry com backoff exponencial para chamadas externas
- Exit codes: 0 = sucesso, 1 = erro esperado, 2 = erro inesperado
- Output em JSON para stdout (integração com orquestrador)

---

## Commits

Formato: `tipo(escopo): descrição no imperativo`

| Tipo | Quando usar |
|------|------------|
| `feat` | Nova funcionalidade |
| `fix` | Correção de bug |
| `docs` | Apenas documentação |
| `refactor` | Sem mudança de comportamento |
| `test` | Testes |
| `harness` | Melhoria no harness (Regra de Hashimoto) |
| `directive` | Atualização de directive |

---

## Logs

```typescript
// ❌ Não use
console.log("Usuário criado: " + userId);

// ✅ Use
logger.info("Usuário criado", {
  event: "user.created",
  userId,
  timestamp: new Date().toISOString()
});
```

Níveis: `debug` (dev) · `info` (eventos normais) · `warn` (anormal recuperável) · `error` (requer atenção)

---

## Testes

- Nomeie em português: `"deve retornar erro quando email inválido"`
- Estrutura: Arrange → Act → Assert
- Mocks apenas para I/O externo (banco, API, filesystem)
- Teste comportamento, não implementação
