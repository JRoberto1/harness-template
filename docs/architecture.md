# Arquitetura do Projeto

> Fonte de verdade arquitetural. Atualizado em 2026-04-19.
> O agente lê aqui antes de qualquer decisão arquitetural.
> Atualize sempre que uma decisão importante for tomada (Regra de Hashimoto).

---

## Stack

| Camada | Tecnologia | Versão | Motivo da escolha |
|--------|-----------|--------|-------------------|
| Framework | Next.js (App Router) | 16.2.3 | SSR + Server Components + API Routes |
| UI | React + React DOM | 19.2.4 | Base do Next.js |
| Linguagem | TypeScript | 5.x | Strict mode ativado |
| Estilo | Tailwind CSS v4 | @tailwindcss/postcss@4 | Nova sintaxe CSS-first |
| Banco de dados | Supabase (PostgreSQL) | @supabase/supabase-js 2.103.0 | RLS nativo, sem ORM |
| Auth | Supabase Auth | @supabase/ssr 0.10.2 | Google OAuth + email/senha |
| Storage | Supabase Storage | — | PDFs privados (bucket contratos-pdf) |
| IA | Groq — llama-3.3-70b-versatile | groq (não listado diretamente) | Custo zero no tier free, 4096 tokens |
| Pagamentos | Stripe | 22.0.1 | Checkout sessions + webhooks |
| Pix | AbacatePay | — | Variável ABACATEPAY_API_KEY presente, integração pendente |
| E-mail | Resend | 6.10.0 | Transacional (boas-vindas, confirmação pagamento) |
| PDF | pdf-lib | 1.17.1 | Geração server-side sem API externa |
| Markdown | marked | 18.0.0 | Parser para renderização e PDF |
| Ícones | lucide-react | 0.468.0 | SVG components |
| Infra / Deploy | [NÃO ENCONTRADO — Vercel provável] | — | — |

**Sem ORM:** Supabase JS client direto. Sem Prisma, sem Drizzle.

---

## Arquitetura em Camadas

```
[Browser / Client Components]
        ↓
[Next.js App Router — Server Components + Route Handlers]
        ↓
[lib/ — groq.ts, pdf.ts, email.ts, stripe.ts, supabase/]
        ↓
[Supabase (PostgreSQL + RLS + Storage)]
        ↓
[types/contrato.ts — contratos de tipos]
```

**Regra:** Route Handlers (`app/api/`) chamam `lib/` diretamente. Nunca `app/` chama banco sem passar por `lib/supabase/`. Client Components nunca acessam `SUPABASE_SERVICE_ROLE_KEY`.

---

## Estrutura de Pastas

```
contratofacil-app/
├── src/
│   ├── app/                         # Next.js App Router
│   │   ├── api/                     # Route Handlers (POST/GET)
│   │   │   ├── atualizar-contrato/  # POST — incrementa downloads_count, promove status
│   │   │   ├── baixar-pdf-salvo/    # GET  — URL assinada Supabase Storage (5 min)
│   │   │   ├── criar-checkout/      # POST — cria sessão Stripe Checkout
│   │   │   ├── dev/liberar-perfil/  # POST — reset cota de contratos (dev only)
│   │   │   ├── duplicar-contrato/   # POST — clona contrato (status=rascunho, conteudo vazio)
│   │   │   ├── email/               # POST — Resend (header x-internal-secret obrigatório)
│   │   │   ├── gerar-contrato/      # POST — Groq IA + validação percentuais/multas + logs
│   │   │   ├── gerar-pdf/           # POST — markdown → PDF binário (download direto)
│   │   │   ├── salvar-contrato/     # POST — INSERT em contratos (status=rascunho)
│   │   │   └── stripe-webhook/      # POST — checkout.session.completed
│   │   ├── auth/callback/           # OAuth callback do Supabase
│   │   ├── contrato/[id]/           # Server Component (fetch + RLS) + EditarContratoClient
│   │   ├── gerar/                   # Wizard: seletor categoria → formulário → visualizador
│   │   ├── login/                   # Auth (Google OAuth + email/senha)
│   │   ├── meus-contratos/          # Dashboard Server Component
│   │   ├── modelo/[categoria]/      # Preview modelos públicos
│   │   ├── planos/                  # Preços (Grátis, Avulso, Mensal, Semestral, Anual)
│   │   ├── page.tsx                 # Homepage
│   │   └── layout.tsx               # Root layout (Header + Footer)
│   ├── components/
│   │   ├── auth/                    # LoginGuard + ModalLogin
│   │   ├── contrato/                # Formulario, VisualizadorContrato, DashboardContratosLayout
│   │   ├── layout/                  # Header, Footer, BottomNav (mobile)
│   │   └── ui/                      # Badge, Button, ProgressRibbon
│   ├── lib/
│   │   ├── categorias/index.ts      # 6 categorias com campos extras e cláusulas específicas
│   │   ├── email.ts                 # Templates HTML + funções Resend
│   │   ├── groq.ts                  # Cliente Groq (gerarContrato)
│   │   ├── pdf.ts                   # gerarPDFBuffer / gerarPDFBase64
│   │   ├── prompts/gerarPromptContrato.ts  # System prompt + user prompt da IA
│   │   ├── stripe.ts                # Cliente Stripe
│   │   └── supabase/
│   │       ├── client.ts            # Browser client (NEXT_PUBLIC_SUPABASE_ANON_KEY)
│   │       └── server.ts            # Server client com gestão de cookies
│   ├── types/contrato.ts            # Todos os tipos TypeScript do domínio
│   └── proxy.ts
├── supabase/
│   ├── migrations/                  # Histórico migrations SQL (cronológico)
│   └── schema.sql                   # Schema completo atual (fonte de verdade do DB)
└── docs/                            # Este diretório
```

---

## Padrões de Nomenclatura

| Elemento | Padrão | Exemplo |
|---------|--------|---------|
| Arquivos | kebab-case | `gerar-contrato.ts` |
| Componentes | PascalCase | `VisualizadorContrato.tsx` |
| Funções | camelCase | `gerarPromptContrato()` |
| Constantes | UPPER_SNAKE | `SUPABASE_SERVICE_ROLE_KEY` |
| Tabelas DB | snake_case | `logs_qualidade` |
| Variáveis de ambiente | UPPER_SNAKE | `GROQ_API_KEY` |
| Branches | kebab-case | `feat/status-concluido` |
| Rotas API | kebab-case | `/api/gerar-contrato` |

---

## Limites do Sistema

| Recurso | Limite | Motivo |
|---------|--------|--------|
| Tokens IA | 4096 max_tokens | Groq llama-3.3-70b |
| Timeout Groq | 60s | Configurado em groq.ts |
| URL assinada PDF | 5 minutos | Supabase Storage signed URL |
| E-mail interno | Header x-internal-secret | Proteção /api/email |
| Contratos plano grátis | 2/mês | Regra de negócio perfis.contratos_mes |

---

## Decisões Arquiteturais (ADRs)

### ADR-001: Sem ORM — Supabase JS direto
**Data:** 2026-04-17 | **Status:** Aceita

**Contexto:** RLS do Supabase funciona nativamente com o JS client. Prisma/Drizzle adicionariam camada de abstração sem benefício real.

**Decisão:** Usar `@supabase/supabase-js` e `@supabase/ssr` diretamente.

**Consequências:**
- ✅ RLS aplicado automaticamente, sem possibilidade de bypass acidental
- ✅ Menos dependências, menos boilerplate de migrations
- ⚠️ Sem tipagem automática de queries — tipos em `types/contrato.ts` são manuais

---

### ADR-002: PDF gerado server-side com pdf-lib
**Data:** 2026-04-17 | **Status:** Aceita

**Contexto:** Precisamos de PDF sem custo de API externa.

**Decisão:** `pdf-lib` com Helvetica Standard Font, paginação manual.

**Consequências:**
- ✅ Zero custo, zero dependência de serviço externo
- ⚠️ Sem suporte a formatação HTML/CSS rica — apenas texto puro

---

### ADR-003: IA via Groq (não OpenAI)
**Data:** 2026-04-17 | **Status:** Aceita

**Contexto:** GPT-free tem limite muito baixo. Groq tem tier gratuito generoso.

**Decisão:** `llama-3.3-70b-versatile`, temperature 0.2 (determinístico).

**Consequências:**
- ✅ Custo zero no tier atual
- ⚠️ Sem fallback implementado — se Groq cair, geração falha

---

### ADR-004: Imutabilidade via Trigger PostgreSQL
**Data:** 2026-04-18 | **Status:** Aceita (com bugfix)

**Contexto:** Contratos finalizados não devem ter conteúdo alterado.

**Decisão:** Trigger `prevent_imutavel_update` bloqueia UPDATE em `conteudo` quando `imutavel=true`.

**Consequências:**
- ✅ Garantia a nível de banco, impossível burlar pelo JS
- ⚠️ Trigger original bloqueava updates de status também — corrigido em 20260418_fix_check_imutavel.sql

---

### ADR-005: Downloads via URL Assinada (não URL pública)
**Data:** 2026-04-17 | **Status:** Aceita

**Contexto:** PDFs de contratos são documentos privados.

**Decisão:** Bucket `contratos-pdf` privado. Acesso via `/api/baixar-pdf-salvo` que valida RLS antes de assinar URL (5 min).

**Consequências:**
- ✅ Nunca expõe URL permanente de documento privado
- ⚠️ Link de download expira em 5 minutos — usuário precisa regenerar

---

## O que NUNCA Fazer

> Atualize conforme erros são encontrados (Regra de Hashimoto).

| Proibido | Motivo | Descoberto em |
|---------|--------|--------------|
| Usar `SUPABASE_SERVICE_ROLE_KEY` em Client Components | Expõe chave admin ao browser | Arquitetura inicial |
| Alterar `conteudo` de contrato com `imutavel=true` | Trigger PostgreSQL rejeita, gera erro 500 | 2026-04-18 |
| Usar `any` em TypeScript | Regra Absoluta #5 do AGENTS.md | — |
| Status `gerado` no banco | Renomeado para `concluido` em 20260418_status_concluido.sql | 2026-04-18 |
| Atualizar status via UPDATE direto após `imutavel=true` | Usar RPC `registrar_download()` que bypassa constraint | 2026-04-18 |
