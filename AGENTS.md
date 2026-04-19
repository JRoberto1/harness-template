# AGENTS.md — Contrato Facil
<!-- Claude Code · Antigravity · OpenCode · Cursor · Copilot -->

> Leia este arquivo completamente antes de qualquer ação.

## Identidade

Você é um agente de engenharia do projeto **Contrato Facil** — SaaS para geração de contratos de prestação de serviços voltado a MEIs e autônomos brasileiros.

**Stack confirmada (2026-04-19):**
- **Framework:** Next.js 16.2.3 (App Router + Server Components)
- **UI:** React 19 + Tailwind CSS v4
- **Banco:** Supabase (PostgreSQL + RLS) — sem ORM
- **Auth:** Supabase Auth (Google OAuth + email/senha)
- **IA:** Groq llama-3.3-70b-versatile (temperature 0.2)
- **Pagamentos:** Stripe 22.0.1 (checkout + webhook)
- **E-mail:** Resend 6.10.0
- **PDF:** pdf-lib 1.17.1 (server-side, sem API externa)
- **Linguagem:** TypeScript 5 (strict mode)

## Arquitetura de 3 Camadas

- **Camada 1 — Directives** (`directives/`): SOPs — o QUE fazer
- **Camada 2 — Agente (você)**: roteamento inteligente
- **Camada 3 — Execution** (`execution/`): scripts determinísticos

## Regras Absolutas

1. Nunca avance sem validar o output da etapa anterior
2. Nunca invente — marque `[VERIFICAR: motivo]`
3. Nunca quebre a arquitetura de camadas de `docs/architecture.md`
4. Verifique `execution/` antes de criar script novo
5. Nunca use `any` em TypeScript nem ignore erros silenciosamente
6. Aplique o Protocolo PEV em tarefas com 3+ arquivos
7. Aplique a Regra de Hashimoto: cada erro melhora o harness

## Protocolo PEV

```
PLAN    → critérios verificáveis antes de qualquer código
EXECUTE → estritamente dentro do plano aprovado
VERIFY  → falha = volta ao Plan com contexto de erro
```

## Domínios Ativos

- [x] SaaS Web              → `.harness/domains/saas.md`
- [x] API / Backend         → `.harness/domains/api.md`
- [x] Automação / Scripts   → `.harness/domains/automation.md`
- [x] Jurídico / Financeiro → `.harness/domains/juridico-financeiro.md`

## Skills Instaladas

> Instale novas: `bash scripts/fetch-skill.sh <nome>`

- `.harness/skills/SKILL-template.md` → template para criar skills

*Harness v1.0.0 — adotado em 2026-04-19*

- `.harness/skills/brainstorming/SKILL.md` — brainstorming
- `.harness/skills/architecture/SKILL.md` — architecture
- `.harness/skills/frontend-design/SKILL.md` — frontend-design
- `.harness/skills/api-design-principles/SKILL.md` — api-design-principles
- `.harness/skills/test-driven-development/SKILL.md` — test-driven-development
- `.harness/skills/security-auditor/SKILL.md` — security-auditor
- `.harness/skills/create-pr/SKILL.md` — create-pr
- `.harness/skills/brainstorming-session/SKILL.md` — brainstorming-session