# AGENTS.md — Harness Universal
<!-- Claude Code · Antigravity · OpenCode · Cursor · Copilot -->
<!-- Versão: 1.3.0 -->

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

## ⚡ Protocolo de Economia de Contexto *(v1.2.0+)*

### Lazy Loading de Directives

**NUNCA** carregue todas as directives automaticamente. Siga:

```
1. Leia .harness/index.md (leve — 1-2 linhas por directive)
2. Identifique qual directive tem match com a tarefa
3. Carregue APENAS a directive com match explícito
4. Se nenhuma fizer match → execute sem directive específica
```

### Progressive Disclosure — Leitura Incremental *(v1.3.0)*

**NUNCA** carregue arquivos inteiros quando só precisa de uma parte.
Use sempre a abordagem mínima necessária:

```bash
# ❌ Não faça — carrega tudo
cat src/services/contrato-service.ts

# ✅ Faça — lê só o necessário
grep -n "gerarPDF" src/services/contrato-service.ts
head -50 src/services/contrato-service.ts
grep -rn "função que preciso" src/
```

Regra: leia o mínimo necessário para executar a tarefa.
Se precisar de mais → leia incrementalmente.

### Observation Masking *(v1.3.0)*

Quando um output de ferramenta, log ou erro for longo (mais de 20 linhas),
**substitua pelo placeholder** em vez de incluir tudo no contexto:

```
[Output omitido — Resultado: FALHA | Causa: timeout na linha 42]
[Logs omitidos — 847 linhas | Resumo: 3 erros de tipagem em auth.ts]
[Teste omitido — Status: PASS | 47/47 testes passando]
```

Formato do placeholder:
```
[TIPO omitido — Resultado: STATUS | Detalhe relevante em 1 linha]
```

Isso é **52% mais barato** que pedir ao modelo para sumarizar o conteúdo.

### Roteamento de Modelos *(v1.3.0)*

Escolha o modelo antes de iniciar baseado no tipo de tarefa:

| Tipo de Tarefa | Modelo | Motivo |
|---------------|--------|--------|
| Arquitetura, decisões complexas, debugging difícil | **Opus / Pro** | precisa de raciocínio profundo |
| Geração de código, implementação, refatoração | **Sonnet / padrão** | equilíbrio custo/qualidade |
| Resumos, docs, formatação, testes simples | **Haiku / Mini** | tarefa mecânica, modelo caro é desperdício |
| Debug rápido, perguntas pontuais | **Sonnet / padrão** | suficiente para a maioria |

> No Claude Code: troque o modelo no seletor antes de iniciar.
> No Antigravity: use o modelo correspondente na configuração.
> Regra de bolso: se não tem certeza, use Sonnet. Suba para Opus só se travar.

### Uso de Sub-agentes *(v1.3.0)*

Dispare um sub-agente quando:
- Tarefa consome mais de **20k tokens estimados**
- Tarefa envolve auditar uma biblioteca ou repositório externo
- Tarefa é independente do contexto atual (não precisa do histórico)

O sub-agente processa em sua própria janela e retorna apenas
um resumo de **1.000-2.000 tokens** para o agente principal.

```
Directive de referência: directives/subagent-dispatch.md
```

### Regras de Output

| Situação | Formato obrigatório |
|----------|-------------------|
| Sucesso | Máximo 3 linhas — apenas o resultado |
| Falha | `ERRO:` / `CAUSA:` / `AÇÃO:` |
| Progresso | Uma linha por etapa concluída |
| Confirmação | "✓ feito" — sem repetir o que foi pedido |
| Output longo | Use Observation Masking |

**NUNCA:**
- Explicar o que vai fazer antes de fazer
- Repetir conteúdo já presente no contexto
- Carregar arquivos inteiros quando só precisa de um trecho
- Incluir logs ou outputs longos sem mascarar

### Compressão de Histórico

Após **8 turnos**, execute:
```bash
python execution/compress-history.py --auto
```

### Budget por Tipo de Tarefa

| Tipo | Max Contexto | Max Output | Modelo |
|------|-------------|-----------|--------|
| Análise simples | 8k | 1k | Haiku |
| Geração de código | 20k | 4k | Sonnet |
| Revisão de documento | 30k | 6k | Sonnet |
| Debug complexo | 40k | 8k | Opus |
| Arquitetura | 50k | 10k | Opus |

---

## Memória de Sessão *(v1.1.0)*

**Ao iniciar:** leia `.harness/memory/last-session.md` se existir.
**Ao encerrar:** salve contexto em `.harness/memory/last-session.md`.
**Claude Code:** `/wrap-session` e `/brief-session`.
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

- `.harness/skills/SKILL-template.md` → template

---

*Harness v1.3.0*
