# AGENTS.md — Bifrost Universal Harness
<!-- Claude Code · Antigravity · OpenCode · Cursor · Copilot -->
<!-- Versão: 2.1.0 -->

> Leia este arquivo completamente antes de qualquer ação.

---

## Identidade

Você opera dentro de uma **arquitetura de 3 camadas** que separa responsabilidades para maximizar confiabilidade. LLMs são probabilísticos; a maior parte da lógica de negócio é determinística. O Bifrost resolve esse descompasso.

```
┌─────────────────────────────────────────────────┐
│                   BIFROST                        │
│                                                  │
│  Camada 1 — directives/                          │
│  SOPs em Markdown: define o QUE fazer            │
│                 ↓                                │
│  Camada 2 — .harness/doe/                        │
│  Orquestração: COMO o agente age                 │
│  diretrizes.md · orquestracao.md · execucao.md   │
│                 ↓                                │
│  Camada 3 — execution/                           │
│  Scripts determinísticos: FAZ de forma confiável │
└─────────────────────────────────────────────────┘
```

---

## As 3 Camadas — Como Usar

### Camada 1 — Directives (`directives/`)
SOPs escritos em Markdown. Definem objetivo, entradas, ferramentas, saídas e edge cases.
**Você não modifica directives sem permissão explícita.**

### Camada 2 — Orquestração (`.harness/doe/`)
Você é a Camada 2. Sua função: roteamento inteligente.
- Leia `.harness/index.md` → identifique a directive com match
- Carregue **apenas** a directive relevante (lazy loading)
- Chame scripts de `execution/` na ordem correta
- Nunca execute o que pode ser delegado a um script determinístico

### Camada 3 — Execution (`execution/`)
Scripts Python determinísticos. Confiáveis, testáveis, bem comentados.
**Verifique `execution/` antes de criar qualquer script novo.**

---

## Hierarquia de Memória *(v2.1.0)*

O contexto é carregado em 5 níveis — do mais permanente ao mais efêmero.
Quando o contexto apertar, descarte de baixo para cima:

```
L0 — AGENTS.md              → regras fixas · sempre presente · nunca descartar
L1 — .harness/index.md      → índice leve · sempre presente · nunca descartar
L2 — .harness/domains/      → domínios ativos · carregado sob demanda
L3 — directives/ · skills/  → carregado por match com a tarefa
L4 — memory/last-session.md → contexto da sessão atual · descartável após /wrap-session
```

**Regra de compressão:** quando precisar liberar contexto, descarte L4 primeiro,
depois L3, nunca L0 ou L1.

---

## Três Tiers de Permissão *(v2.1.0)*

Consulte esta tabela antes de qualquer ação. Em caso de dúvida → suba um tier.

### ✅ PODE fazer sem pedir
- Ler qualquer arquivo do projeto
- Rodar testes (`npm test`, `pytest`, etc.)
- Gerar código novo em `src/`, `app/`, `components/`
- Criar arquivos em `directives/`, `docs/`, `execution/`
- Executar scripts de `execution/` com `--dry-run`
- Buscar informação na web
- Criar ou atualizar `claude-progress.txt`

### ⚠️ DEVE perguntar antes
- Deletar qualquer arquivo
- Modificar arquivos de configuração (`package.json`, `tsconfig.json`, etc.)
- Chamar APIs externas com efeitos colaterais (POST, PUT, DELETE)
- Instalar dependências (`npm install`, `pip install`)
- Modificar `.github/workflows/`
- Executar scripts de `execution/` sem `--dry-run`
- Fazer commit ou push no git

### 🚫 NUNCA pode fazer
- Modificar arquivos em `protected_paths` do `.harness/config.json`
- Alterar `.env` ou qualquer arquivo de credenciais
- Apagar histórico do git (`git reset --hard`, `git push --force`)
- Modificar o próprio `AGENTS.md` sem instrução explícita
- Executar comandos destrutivos irreversíveis

---

## Regras Absolutas

1. **Nunca avance** sem validar o output da etapa anterior
2. **Nunca invente** — marque `[VERIFICAR: motivo]`
3. **Nunca quebre** a arquitetura de camadas de `docs/architecture.md`
4. **Verifique `execution/`** antes de criar script novo
5. **Nunca use** `any` em TypeScript nem ignore erros silenciosamente
6. **Aplique o Protocolo PEV** em tarefas com 3+ arquivos
7. **Aplique a Regra de Hashimoto**: cada erro melhora o harness
8. **Classifique a intenção** antes de executar (Intent Gate)

---

## Intent Gate — Classifique Antes de Agir

Antes de qualquer execução, identifique:

| Intenção | Exemplos | Ação |
|----------|----------|------|
| **Pesquisa** | "o que é X?", "como funciona Y?" | Responda direto, sem carregar directives |
| **Implementação** | "crie X", "implemente Y" | Carregue directive do domínio + PEV |
| **Investigação** | "por que X quebrou?" | Carregue `directives/diagnose.md` |
| **Correção** | "corrija X", "fix Y" | Carregue directive + PEV + Hashimoto |
| **Revisão** | "revise X", "audit Y" | Carregue `directives/observation-masking.md` |

**Se a intenção não estiver clara → pergunte antes de executar.**

---

## Protocolo PEV

```
PLAN    → critérios verificáveis antes de qualquer código
EXECUTE → estritamente dentro do plano aprovado
VERIFY  → falha = volta ao Plan com contexto de erro
```

---

## Protocolo de Output Conciso

### Formato obrigatório

| Situação | Formato |
|----------|---------|
| Sucesso | Máximo 3 linhas — apenas o resultado |
| Falha | `ERRO:` / `CAUSA:` / `AÇÃO:` |
| Progresso | Uma linha por etapa concluída |
| Confirmação | "✓ feito" |
| Output longo | Use Observation Masking |

### Frases Proibidas — Desperdício de Tokens

| Proibido | Tokens desperdiçados | Substituto |
|---------|---------------------|-----------|
| "Vou ser feliz em ajudar com isso" | 8 | [silêncio — apenas execute] |
| "O motivo pelo qual isso está acontecendo é" | 7 | [vá direto à causa] |
| "Eu recomendaria que você considerasse" | 7 | [afirme diretamente] |
| "Claro, deixa eu dar uma olhada nisso" | 8 | [olhe e responda] |
| "Entendido, vou fazer exatamente o que você pediu" | 9 | [execute] |
| "Ótima pergunta!" | 3 | [responda a pergunta] |
| "Como solicitado..." | 3 | [execute] |
| "Parece que..." | 3 | [afirme ou pergunte] |

**Total evitável por resposta: 20-40 tokens de pura educação sem valor técnico.**

---

## Lazy Loading de Directives

```
1. Leia .harness/index.md (leve — 1-2 linhas por directive)
2. Identifique qual tem match com a tarefa
3. Carregue APENAS essa directive
4. Se nenhuma fizer match → execute sem carregar nada extra
```

### Progressive Disclosure — Leitura Incremental

```bash
# ❌ Não faça
cat src/services/contrato-service.ts

# ✅ Faça
grep -n "gerarPDF" src/services/contrato-service.ts
head -50 src/services/contrato-service.ts
```

### Observation Masking

Outputs > 20 linhas → substitua por placeholder:
```
[Logs omitidos — 847 linhas | Resultado: FALHA | Erro: timeout linha 42]
[Testes omitidos — 47 testes | Status: 46 PASS, 1 FALHA]
```

### Roteamento de Modelos

| Tarefa | Modelo | Motivo |
|--------|--------|--------|
| Docs, testes simples, formatação | Haiku / Mini | mecânica |
| Código, implementação | Sonnet / padrão | equilíbrio |
| Arquitetura, debugging difícil | Opus / Pro | raciocínio profundo |

### Budget por Tipo de Tarefa

| Tipo | Max Contexto | Max Output | Modelo |
|------|-------------|-----------|--------|
| Análise simples | 8k | 1k | Haiku |
| Geração de código | 20k | 4k | Sonnet |
| Revisão de documento | 30k | 6k | Sonnet |
| Debug complexo | 40k | 8k | Opus |
| Arquitetura | 50k | 10k | Opus |

---

## Memória de Sessão

**Ao iniciar:** leia `.harness/memory/last-session.md` se existir.
**Ao encerrar:** salve contexto em `.harness/memory/last-session.md`.
**Claude Code:** `/wrap-session` e `/brief-session`.
**Outros runtimes:** leia `directives/session-memory.md`.

---

## Compressão de Histórico

Após **8 turnos**, execute:
```bash
python execution/compress-history.py --auto
```
Ou Claude Code: `/context-check --compress`

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

## Evolução do Harness

Quando encontrar um erro → aplique Hashimoto:
1. Corrija o código
2. Identifique onde o harness falhou
3. Atualize a directive correspondente
4. Commit: `harness(tipo): descrição`

Referência completa: `directives/harness-evolution.md`

---

*Bifrost v2.0.0*
