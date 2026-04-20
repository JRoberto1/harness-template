# Arquitetura do Projeto

> Preencha este arquivo antes de iniciar o desenvolvimento.
> O agente lê aqui antes de qualquer decisão arquitetural.
> Atualize sempre que uma decisão importante for tomada (Regra de Hashimoto).

---

## Stack

| Camada | Tecnologia | Versão | Motivo da escolha |
|--------|-----------|--------|-------------------|
| Frontend | - | - | - |
| Backend | - | - | - |
| Banco de dados | - | - | - |
| Autenticação | - | - | - |
| Cache | - | - | - |
| Infra / Deploy | - | - | - |

---

## Arquitetura em Camadas

> Defina a hierarquia e a direção de dependências.
> **Nunca inverta** as dependências definidas aqui.

```
[Camada mais alta — ex: UI / Clientes externos]
        ↓
[Ex: Controllers / Handlers]
        ↓
[Ex: Services — lógica de negócio]
        ↓
[Ex: Repositories — acesso a dados]
        ↓
[Ex: Tipos / Schemas]
```

**Regra**: cada camada só conhece a camada imediatamente abaixo.
Handler nunca acessa banco diretamente. UI nunca chama repositório.

---

## Padrões de Nomenclatura

| Elemento | Padrão | Exemplo |
|---------|--------|---------|
| Arquivos | kebab-case | `auth-service.ts` |
| Classes | PascalCase | `AuthService` |
| Funções | camelCase | `getUser()` |
| Constantes | UPPER_SNAKE | `MAX_RETRY_COUNT` |
| Tabelas DB | snake_case | `user_sessions` |
| Variáveis de ambiente | UPPER_SNAKE | `DATABASE_URL` |
| Branches | kebab-case | `feat/auth-refresh-token` |

---

## Limites do Sistema

| Recurso | Limite | Motivo |
|---------|--------|--------|
| Tamanho de payload | - | - |
| Timeout de request | - | - |
| Rate limit | - | - |
| Tamanho de batch | - | - |

---

## Decisões Arquiteturais (ADRs)

### ADR-001: [Título]
**Data:** | **Status:** Aceita

**Contexto:** [Por que esta decisão foi necessária?]

**Decisão:** [O que foi decidido]

**Consequências:**
- ✅ [Benefício]
- ⚠️ [Trade-off aceito]

---

> Adicione um ADR para cada decisão arquitetural significativa.

---

## O que NUNCA Fazer

> Atualize conforme erros são encontrados (Regra de Hashimoto).
> Cada entrada aqui representa um erro que já aconteceu.

| Proibido | Motivo | Descoberto em |
|---------|--------|--------------|
| - | - | - |
