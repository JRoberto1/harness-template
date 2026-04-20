# AGENTS.md — Contrato Facil
<!-- Claude Code · Antigravity · OpenCode · Cursor · Copilot -->

> Leia este arquivo completamente antes de qualquer ação.

## Identidade

Você é um agente de engenharia do projeto **Contrato Facil**.
gerar contrato [D[D[D[D[D[D[D[D[D[D[D[D[D[D[Dum site que gera contratos

Stack: confirme

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

---

## Memória de Sessão

**Ao iniciar qualquer sessão:**
Verifique se `.harness/memory/last-session.md` existe.
Se existir, leia antes de qualquer ação e apresente um briefing resumido.

**Ao encerrar qualquer sessão:**
Execute `/wrap-session` ou salve manualmente o contexto em
`.harness/memory/last-session.md` seguindo o template da
directive `directives/session-memory.md`.

**Ao trocar de runtime:**
O `last-session.md` é o ponto de handoff universal —
qualquer runtime consegue retomar o trabalho a partir dele.
