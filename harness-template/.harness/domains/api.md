# Domínio: API / Backend

> Ative: marque `[x] API / Backend` no AGENTS.md

## Contrato de API
- Versioning obrigatório: `/api/v1/`
- Envelope padrão: `{ success, data, error: { code, message, fields }, meta: { timestamp, request_id } }`
- Rate limiting em **todos** os endpoints públicos
- SQL: sempre queries parametrizadas, nunca concatenação

## Códigos HTTP
| Situação | Código |
|---|---|
| Criação | 201 · Sem conteúdo (DELETE) | 204 · Validação falhou | 422 |
| Não autenticado | 401 · Sem permissão | 403 · Rate limit | 429 |

## Estrutura
```
handler → valida input (Zod/Joi) → service (lógica) → repository (dados) → response
```
Handler nunca acessa banco diretamente.

## Quality Gates
- [ ] Schema de validação em todos os endpoints
- [ ] Timeout em todas as chamadas externas
- [ ] Health check funcional em `/health`
- [ ] `.env.example` atualizado com novas variáveis
