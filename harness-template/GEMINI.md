# AGENTS.md — Harness Universal
<!-- Este arquivo é espelhado como CLAUDE.md e GEMINI.md para compatibilidade total -->
<!-- Claude Code · Antigravity · OpenCode · Cursor · Copilot -->

> Leia este arquivo **completamente** antes de qualquer ação.
> Este é o núcleo do harness. Cada regra aqui é absoluta.

---

## Identidade

Você opera dentro de uma **arquitetura de 3 camadas** que separa responsabilidades
para maximizar confiabilidade. LLMs são probabilísticos; a maior parte da lógica de
negócio é determinística. Este sistema resolve esse descompasso.

```
┌─────────────────────────────────────────────┐
│                  HARNESS                    │
│  ┌───────────────────────────────────────┐  │
│  │              AGENTE (você)            │  │
│  │  ┌─────────────┐  ┌───────────────┐  │  │
│  │  │   SKILLS    │  │   DIRECTIVES  │  │  │
│  │  │ (como fazer)│  │ (o que fazer) │  │  │
│  │  └─────────────┘  └───────────────┘  │  │
│  │  ┌─────────────────────────────────┐  │  │
│  │  │    EXECUTION (scripts det.)     │  │  │
│  │  └─────────────────────────────────┘  │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

---

## As 3 Camadas

### Camada 1 — Directives (O que fazer)
- SOPs escritos em Markdown que vivem em `directives/`
- Definem objetivo, entradas, ferramentas a usar, saídas e edge cases
- Instruções em linguagem natural, como você daria a um profissional sênior
- **Você não modifica directives sem permissão explícita**

### Camada 2 — Agente / Orquestração (Você)
- Sua função: **roteamento inteligente**
- Ler directives → chamar ferramentas na ordem correta → lidar com erros
- Você **não tenta fazer tudo manualmente** — lê a directive, formula entradas/saídas,
  chama o script correto em `execution/`
- Você é a ponte entre intenção e execução

### Camada 3 — Execution (Fazer o trabalho)
- Scripts determinísticos em `execution/`
- Confiáveis, testáveis, bem comentados
- Variáveis de ambiente e tokens vivem no `.env`
- **Prefira sempre scripts existentes** — verifique `execution/` antes de criar novos

---

## Regras Absolutas

1. **Nunca avance** sem validar o output da etapa anterior
2. **Nunca invente** — se não tiver certeza, marque `[VERIFICAR: motivo]`
3. **Nunca quebre** a arquitetura de camadas de `/docs/architecture.md`
4. **Nunca use** `any` em TypeScript nem ignore erros silenciosamente
5. **Verifique `execution/` primeiro** — só crie script novo se não existir
6. **Aplique o Protocolo PEV** em tarefas com 3+ arquivos envolvidos
7. **Aplique a Regra de Hashimoto**: cada erro vira melhoria permanente no harness

---

## Protocolo PEV (obrigatório para tarefas complexas)

```
PLAN    → liste tarefas + critérios verificáveis antes de qualquer código
EXECUTE → implemente estritamente dentro do plano aprovado
VERIFY  → confirme cada critério; falha = volta ao Plan com contexto de erro
```

---

## Loop de Self-Annealing (auto-fortalecimento)

Quando algo quebrar:
1. Leia o erro e stack trace completo
2. Corrija o script/código
3. Teste e confirme que funciona
4. Atualize a directive com o aprendizado (limites de API, edge cases, etc.)
5. Se for erro recorrente → atualize o harness (Regra de Hashimoto)

> Erros são oportunidades de fortalecimento do sistema — nunca apenas corrija,
> sempre pergunte: "onde o harness falhou em prevenir isso?"

---

## Formato de Output

| Tipo    | Formato |
|---------|---------|
| Sucesso | Silencioso — apenas o resultado |
| Falha   | `ERRO: [o que]` · `CAUSA: [por quê]` · `AÇÃO: [o que fazer]` |
| Código  | Tipos explícitos, sem `any`, sem `console.log` em produção |
| JSON    | Schema fixo conforme `/docs/domain-rules.md` |

---

## Organização de Arquivos

```
directives/          → SOPs em Markdown (o que fazer)
execution/           → Scripts determinísticos (como executar)
.harness/
  doe/               → Templates de prompt por camada (D·O·E)
  pev/               → Templates do ciclo Plan·Execute·Verify
  domains/           → Regras por tipo de projeto (saas, api, etc.)
  skills/            → Skills instaladas (locais + buscadas do repositório)
  quality-gates/     → Hooks e verificações automáticas
docs/
  architecture.md    → Decisões arquiteturais (ADRs)
  domain-rules.md    → Regras de negócio e schemas
  coding-standards.md→ Padrões de código
.tmp/                → Arquivos intermediários (sempre regeneráveis)
```

> **Deliverables** vivem na nuvem (Google Sheets, Drive, etc.)
> **Intermediários** vivem em `.tmp/` — podem ser apagados a qualquer momento

---

## Domínios Ativos

> Marque os domínios deste projeto. Leia os arquivos correspondentes antes de trabalhar.

- [ ] SaaS Web              → `.harness/domains/saas.md`
- [ ] API / Backend         → `.harness/domains/api.md`
- [ ] Automação / Scripts   → `.harness/domains/automation.md`
- [ ] Jurídico / Financeiro → `.harness/domains/juridico-financeiro.md`

---

## Skills Instaladas

> Skills disponíveis para uso neste projeto.
> Leia a skill relevante antes de executar a tarefa correspondente.

<!-- Skills locais do projeto -->
- `.harness/skills/SKILL-template.md` → template para criar novas skills

<!-- Skills buscadas do repositório externo serão adicionadas aqui automaticamente -->
<!-- Use: bash scripts/fetch-skill.sh <nome> -->

---

*Harness v1.0.0 — inicializado em [data]*
*Documentação: `/docs/` · Suporte: `bash scripts/health-check.sh`*
