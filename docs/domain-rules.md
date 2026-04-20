# Regras de Domínio

> O agente lê este arquivo antes de qualquer implementação de lógica de negócio.
> **Atualize aqui** ao encontrar regra não documentada (Regra de Hashimoto).
> Cada entrada é memória permanente do sistema.

---

## Schemas Centrais

> Defina os tipos/schemas principais do seu domínio.

```typescript
// Substitua pelos seus schemas reais

// type Usuario = {
//   id: string;          // UUID v4
//   email: string;       // lowercase, validado
//   role: "admin" | "user";
//   created_at: string;  // ISO 8601 UTC
// };
```

---

## Regras de Negócio

> Formato: descrição · motivo · como verificar

### RN-001: [Nome da Regra]
**Descrição:** [O que a regra impõe]
**Motivo:** [Por que existe — contexto de negócio]
**Verificação:** [Como testar — ex: "campo X nunca pode ser null em contrato ativo"]
**Descoberta em:** [data / contexto]

---

## Estados e Transições

> Documente máquinas de estado de entidades importantes.

```
Exemplo:
[rascunho] → [ativo] → [encerrado]
                     ↘ [cancelado]

Transições válidas:
- rascunho → ativo: quando todos os campos obrigatórios preenchidos
- ativo → encerrado: após data de expiração ou ação do usuário
- Qualquer outro: INVÁLIDO → retornar erro 422
```

---

## Campos Obrigatórios por Entidade

| Entidade | Campos Obrigatórios | Validação |
|---------|-------------------|-----------|
| [Entidade] | [campos] | [schema/regex] |

---

## Erros de Domínio

> Atualize quando encontrar novo erro de domínio (Regra de Hashimoto).

| Código | Quando ocorre | Ação esperada |
|--------|--------------|--------------|
| `DOMAIN_001` | [situação] | [o que fazer] |

---

## Glossário

> Termos específicos do negócio — evita ambiguidade entre agente e time.

| Termo | Definição precisa |
|-------|------------------|
| [Termo] | [Definição] |

---

*Última atualização: [data]*
