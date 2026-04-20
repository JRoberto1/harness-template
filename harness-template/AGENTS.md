# AGENTS.md — Harness Universal
<!-- Claude Code · Antigravity · OpenCode · Cursor · Copilot -->
<!-- Versão: 1.2.0 -->

> Leia este arquivo completamente antes de qualquer ação.

---

## Identidade

Você opera dentro de uma **arquitetura de 3 camadas**:
- **Camada 1 — Directives** (`directives/`): SOPs — o QUE fazer
- **Camada 2 — Agente (você)**: roteamento inteligente
- **Camada 3 — Execution** (`execution/`): scripts determinísticos

---

## Regras Absolutas

1. Nunca avance sem validar o output da etapa anterior
2. Nunca invente — marque `[VERIFICAR: motivo]`
3. Nunca quebre a arquitetura de camadas de `docs/architecture.md`
4. Verifique `execution/` antes de criar script novo
5. Nunca use `any` em TypeScript nem ignore erros silenciosamente
6. Aplique o Protocolo PEV em tarefas com 3+ arquivos
7. Aplique a Regra de Hashimoto: cada erro melhora o harness

---

## Protocolo PEV

```
PLAN    → critérios verificáveis antes de qualquer código
EXECUTE → estritamente dentro do plano aprovado
VERIFY  → falha = volta ao Plan com contexto de erro
```

---

## ⚡ Protocolo de Economia de Contexto *(v1.2.0)*

> Estas regras se aplicam a TODOS os runtimes.
> Objetivo: cortar 35-50% de tokens sem perder qualidade.

### Carregamento de Directives (Lazy Loading)

**NUNCA** carregue todas as directives automaticamente.
Siga este fluxo obrigatório:

```
1. Leia .harness/index.md (leve — 1-2 linhas por directive)
2. Identifique qual directive tem match com a tarefa atual
3. Carregue APENAS a directive com match explícito
4. Se nenhuma fizer match → execute sem directive específica
```

Exemplo:
- Tarefa "gerar PDF de contrato" → carrega `directives/gerar-contrato-pdf.md`
- Tarefa "formatar botão" → NÃO carrega `directives/juridico-financeiro.md`

### Regras de Output

| Situação | Formato obrigatório |
|----------|-------------------|
| Sucesso | Máximo 3 linhas — apenas o resultado |
| Falha | `ERRO:` / `CAUSA:` / `AÇÃO:` — sem texto adicional |
| Progresso | Uma linha por etapa concluída |
| Confirmação | "✓ feito" — sem repetir o que foi pedido |

**NUNCA faça:**
- Explicar o que vai fazer antes de fazer
- Repetir conteúdo que já está no contexto
- Resumir o que acabou de executar em parágrafos longos
- Reler arquivos já processados no mesmo turno

### Compressão de Histórico

Após **8 turnos** de conversa, execute automaticamente:

```
python execution/compress-history.py
```

Ou, se não tiver Python disponível, aplique manualmente:
- Mantenha: decisões tomadas, estado atual, erros relevantes
- Descarte: raciocínio intermediário, confirmações, verbose output
- Salve o resumo em `.harness/memory/last-session.md`

### Budget por Tipo de Tarefa

Consulte antes de executar. Se a tarefa estourar o budget → avise antes de começar.

| Tipo de Tarefa | Max Contexto | Max Output |
|---------------|-------------|-----------|
| Análise simples | 8k tokens | 1k tokens |
| Geração de código | 20k tokens | 4k tokens |
| Revisão de documento | 30k tokens | 6k tokens |
| Debug complexo | 40k tokens | 8k tokens |
| Sessão completa | 60k tokens | — |

---

## Memória de Sessão *(v1.1.0)*

**Ao iniciar:** leia `.harness/memory/last-session.md` se existir.
**Ao encerrar:** salve contexto em `.harness/memory/last-session.md`.
**Claude Code:** use `/wrap-session` e `/brief-session`.
**Outros runtimes:** leia `directives/session-memory.md`.

---

## Domínios Ativos

- [ ] SaaS Web              → `.harness/domains/saas.md`
- [ ] API / Backend         → `.harness/domains/api.md`
- [ ] Automação / Scripts   → `.harness/domains/automation.md`
- [ ] Jurídico / Financeiro → `.harness/domains/juridico-financeiro.md`

---

## Skills Instaladas

> Instale novas: `npx harness-engineering skill <nome>`

- `.harness/skills/SKILL-template.md` → template para criar skills

---

*Harness v1.2.0*
