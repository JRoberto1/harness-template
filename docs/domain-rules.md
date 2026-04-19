# Regras de Domínio

> O agente lê este arquivo antes de qualquer implementação de lógica de negócio.
> **Atualize aqui** ao encontrar regra não documentada (Regra de Hashimoto).
> Cada entrada é memória permanente do sistema.

---

## Schemas Centrais

### Contrato (tabela `contratos`)

```typescript
interface Contrato {
  id: string;                  // UUID v4
  referencia: string;          // Sequencial por usuário (ex: "CF-0001")
  usuario_id: string;          // FK → perfis.id
  categoria: CategoriaContrato;
  categoria_custom: string | null;
  prestador_nome: string;
  prestador_doc: string;       // CPF ou CNPJ
  cliente_nome: string;
  cliente_doc: string;
  servico_descricao: string;
  servico_valor: number;       // NUMERIC — valor em reais
  servico_prazo: string;
  servico_pagamento: string;
  tipo: TipoContrato;
  conteudo: string;            // Markdown gerado pela IA
  status: StatusContrato;
  pdf_url: string | null;      // Path no Storage (não URL direta)
  pdf_gerado_em: string | null;
  pago: boolean;
  stripe_session_id: string | null;
  pago_em: string | null;
  criado_em: string;
  atualizado_em: string;
  downloads_count: number;
  imutavel: boolean;
}

type CategoriaContrato =
  | "fotografo" | "videomaker" | "designer-grafico"
  | "desenvolvedor-web" | "social-media" | "redator"
  | "ilustrador" | "motion-designer" | "editor-de-video"
  | "consultor" | "servicos-gerais" | "outros"

type TipoContrato =
  | "completo-formal"   // 3-5 páginas
  | "simplificado"      // 1-2 páginas
  | "executivo"         // 1.5-2.5 páginas
  | "minimalista"       // até 1 página

type StatusContrato =
  | "rascunho"   // criado, ainda não gerado pela IA ou não baixado
  | "concluido"  // teve pelo menos 1 download registrado
  | "pago"       // pagamento Stripe confirmado
  | "enviado"    // enviado por e-mail
```

---

### Perfil (tabela `perfis`)

```typescript
interface Perfil {
  id: string;              // UUID — mesmo id do auth.users
  email: string;
  nome: string | null;
  avatar_url: string | null;
  plano: PlanoAssinatura;
  contratos_mes: number;   // contratos gerados no mês atual
  periodo_reset: string;   // DATE — quando zera contratos_mes
  criado_em: string;
  atualizado_em: string;
}

type PlanoAssinatura = "gratis" | "avulso" | "mensal" | "semestral" | "anual"
```

---

### Formulário (estrutura de entrada)

```typescript
interface FormularioContrato {
  categoria: CategoriaContrato;
  categoriaCustom?: string;
  prestador: DadosPrestador;
  cliente: DadosCliente;
  servico: DadosServico;
  modoAssinatura: "fisica_com_testemunhas" | "fisica_sem_testemunhas" | "eletronica";
}

interface DadosPrestador {
  nomeCompleto: string;
  cpfCnpj: string;         // Formato: "000.000.000-00" ou "00.000.000/0001-00"
  cidade: string;
  estado: string;          // UF (ex: "SP")
  email: string;
  tipoPessoa?: "PF" | "PJ";
  nacionalidade: string;
  estadoCivil: string;
  profissao: string;
  representanteLegal?: string;   // PJ only
  cargoRepresentante?: string;   // PJ only
}

interface DadosCliente {   // mesma estrutura de DadosPrestador
  nomeCompleto: string;
  cpfCnpj: string;
  cidade: string;
  estado: string;
  email: string;
  tipoPessoa?: "PF" | "PJ";
  nacionalidade: string;
  estadoCivil: string;
  profissao: string;
  representanteLegal?: string;
  cargoRepresentante?: string;
}

interface DadosServico {
  descricao: string;
  valor: string;                     // Formato BR: "1.500,00"
  prazoEntrega: string;
  formaPagamento: string;            // Texto livre (ex: "À vista na entrega")
  formaPagamentoTipo: FormaPagamentoOpcao;
  formaPagamentoDetalhes?: FormaPagamentoDetalhes;
  prazoPagamentoAposEntrega?: string;
  numeroPedido?: string;
  multaRescisao?: string;            // Percentual (ex: "20")
  jurosAtraso?: string;              // Percentual ao mês
  localPrestacao?: string;
  formaEntrega?: string;
  clausulasEspeciais?: string;
  camposExtrasCategoria: Record<string, string | boolean | number>;
}

type FormaPagamentoOpcao = "unico" | "entrada_saldo" | "parcelado" | "a_combinar"

type FormaPagamentoDetalhes =
  | { quandoUnico: "assinatura" | "entrega" | "data"; dataUnico?: string }
  | { percentualEntrada: string; quandoSaldo: "entrega" | "dias"; diasSaldo?: string }
  | {
      comEntrada: boolean;
      percentualEntrada?: string;
      numeroParcelas: string;
      vencimentoParcelas: "dia_mes" | "dias_apos";
      diaMesVencimento?: string;
    }
```

---

## Categorias Implementadas

### 1. designer — Designer Gráfico / UI / Social Media
**Campos extras:**
- `prazoAprovacao`: prazo para aprovação de artes
- `numeroRevisoes`: número de revisões incluídas
- `formatosEntrega`: formatos dos arquivos entregues

**Cláusulas automáticas:**
- Cessão de Propriedade Intelectual
- Direito de portfólio
- Limite de revisões (sem custo extra)

---

### 2. dev — Desenvolvedor Web / App / Sistemas
**Campos extras:**
- `tecnologias`: stack técnica usada
- `hospedagem`: responsável pela hospedagem
- `codigoAberto`: se o código é open-source

**Cláusulas automáticas:**
- Propriedade do código-fonte
- Isenção por bibliotecas de terceiros
- Garantia de correção de bugs (prazo)

---

### 3. photo — Fotógrafo / Videomaker
**Campos extras:**
- `localEvento`: local de realização
- `dataHoraEvento`: data e hora do evento
- `quantidadeFotos`: quantidade de fotos/vídeos entregues

**Cláusulas automáticas:**
- Autorização de uso de imagem
- Direito de portfólio
- Reagendamento (condições)

---

### 4. consultant — Consultor / Professor / Coach
**Campos extras:**
- `formatoAulas`: presencial, remoto, híbrido
- `quantidadeSessoes`: número de sessões
- `gravacaoAutorizada`: se há autorização de gravação

**Cláusulas automáticas:**
- Obrigação de meio (não de resultado)
- NDA (sigilo profissional)
- Tolerância de 15 minutos de atraso
- Cancelamento com 24h de antecedência

---

### 5. maintenance — Eletricista / Encanador / Serviços Gerais
**Campos extras:**
- `fornecimentoMateriais`: quem fornece os materiais
- `descartes`: responsabilidade pelo descarte de resíduos
- `horarioPermitido`: horários permitidos para serviço

**Cláusulas automáticas:**
- Responsabilidade sobre materiais
- Responsabilidade civil
- Garantia de mão de obra

---

### 6. other — Outros / Genérico
**Campos extras:** nenhum
**Cláusulas:** adaptáveis pelo tipo de contrato (presencial, remoto, criativo, técnico, saúde, educacional)

---

## Regras de Negócio

### RN-001: Cota de Contratos por Plano
**Descrição:** Cada plano tem um limite de contratos por mês.
**Regra:**
- `gratis`: 2 contratos/mês
- `avulso`: 1 por pagamento avulso
- `mensal`, `semestral`, `anual`: ilimitado

**Verificação:** `perfis.contratos_mes` vs limite do plano. Reset em `perfis.periodo_reset`.
**Descoberta em:** Schema inicial

---

### RN-002: Status de Contrato é Progressivo
**Descrição:** Um contrato nunca volta a status anterior.
**Transições válidas:**
```
rascunho → concluido  (ao registrar o 1º download via RPC registrar_download)
rascunho → pago       (via webhook Stripe)
concluido → enviado   (ao enviar por e-mail)
```
**Verificação:** Trigger `prevent_imutavel_update` bloqueia edição de conteúdo após finalização.
**Descoberta em:** 2026-04-18

---

### RN-003: Imutabilidade de Conteúdo
**Descrição:** Se `contratos.imutavel = true`, o campo `conteudo` não pode ser alterado.
**Implementação:** Trigger PostgreSQL `prevent_imutavel_update` em nível de banco.
**Exceções:** Updates de `status`, `pdf_url`, `downloads_count`, `pago`, `pago_em` são permitidos mesmo com `imutavel=true`.
**Descoberta em:** 2026-04-18 (bug: trigger original bloqueava tudo — corrigido)

---

### RN-004: Percentuais e Multas Apenas se Informados
**Descrição:** A IA não pode inventar percentuais, juros ou cláusulas penais não informados no formulário.
**Implementação:** Função `validarContrato()` em `/api/gerar-contrato/route.ts`:
- Detecta qualquer `\d+%` no texto gerado
- Compara com `multaRescisao` e `percentualEntrada` autorizados
- Detecta palavras "juros" sem `servico.jurosAtraso` informado
- Detecta "cláusula penal" sem `servico.multaRescisao` informado
- Alertas registrados em `logs_qualidade`

**Verificação:** Tabela `logs_qualidade` — se `alertas` não vazio, houve anomalia.
**Descoberta em:** 2026-04-17

---

### RN-005: Valor Monetário Parsado do Formato BR
**Descrição:** O formulário aceita valores no formato BR (`"1.500,00"`). A rota `/api/salvar-contrato` converte para NUMERIC antes de inserir.
**Formato de entrada:** `"1.500,00"` → `1500.00` (NUMERIC PostgreSQL)
**Descoberta em:** 2026-04-17

---

### RN-006: Referência Sequencial por Usuário
**Descrição:** Cada contrato tem uma referência sequencial por usuário no formato `CF-XXXX`.
**Implementação:** Campo `referencia` gerado na inserção, único por `usuario_id`.
**Descoberta em:** 2026-04-17

---

### RN-007: Download via URL Assinada (não pública)
**Descrição:** PDFs são privados. Sempre acessados via `/api/baixar-pdf-salvo` que valida propriedade (RLS) antes de gerar URL assinada de 5 minutos.
**Implementação:** Supabase Storage `createSignedUrl()` com `expiresIn: 300`
**Descoberta em:** 2026-04-17

---

### RN-008: CPF/CNPJ com Máscara
**Descrição:** CPF e CNPJ são armazenados COM máscara no banco (ex: `"123.456.789-09"`).
**Formato CPF:** `000.000.000-00`
**Formato CNPJ:** `00.000.000/0001-00`
**Descoberta em:** 2026-04-18 (commit: "CPF/CNPJ mask")

---

## Cláusulas Obrigatórias em Todos os Contratos

Conforme `src/lib/prompts/gerarPromptContrato.ts`, a IA SEMPRE inclui:

1. **Inexistência de vínculo empregatício** — CLT não se aplica
2. **Nota Fiscal** — obrigação de emitir RPA/NFS-e
3. **Sigilo / NDA** — informações confidenciais
4. **LGPD** — tratamento de dados pessoais
5. **Foro** — comarca do prestador (eleição contratual)
6. **Validade** — vigência e condições de encerramento

---

## Estados e Transições

```
[rascunho] ──(1º download via RPC)──→ [concluido]
[rascunho] ──(Stripe webhook)────────→ [pago]
[concluido] ──(envio por e-mail)─────→ [enviado]

Transições INVÁLIDAS (retornam erro):
- Qualquer outra transição
- Alterar conteudo de contrato imutavel=true
```

---

## Campos Obrigatórios por Entidade

| Entidade | Campos Obrigatórios | Validação |
|---------|-------------------|-----------|
| Contrato | `usuario_id`, `categoria`, `tipo`, `status` | FK + CHECK constraint |
| Prestador (form) | `nomeCompleto`, `cpfCnpj`, `cidade`, `estado`, `email` | Frontend |
| Cliente (form) | `nomeCompleto`, `cpfCnpj`, `cidade`, `estado`, `email` | Frontend |
| Serviço (form) | `descricao`, `valor`, `prazoEntrega`, `formaPagamento` | Frontend |
| Perfil | `id` (= auth.users.id), `plano` | Trigger `handle_new_user` |

---

## Erros de Domínio

| Código | Quando ocorre | Ação esperada |
|--------|--------------|--------------|
| `imutavel_violation` | UPDATE em `conteudo` de contrato com `imutavel=true` | Usar RPC `registrar_download()` ou não alterar conteúdo |
| `cota_excedida` | `contratos_mes >= limite_plano` | Redirecionar para `/planos` |
| `contrato_nao_encontrado` | RLS bloqueia acesso a contrato de outro usuário | 404 ou redirect login |
| `percentual_nao_autorizado` | IA gerou `X%` que não estava no formulário | Log em `logs_qualidade`, retornar mesmo assim |
| `groq_timeout` | Groq não respondeu em 60s | Erro 500 — sem retry automático |

---

## Glossário

| Termo | Definição precisa |
|-------|------------------|
| Prestador | Quem presta o serviço (freelancer, autônomo) |
| Cliente/Contratante | Quem contrata e paga pelo serviço |
| Tipo de contrato | Formato de tamanho/formalidade (completo-formal, simplificado, executivo, minimalista) |
| Categoria | Área profissional do serviço (designer, dev, fotógrafo, etc.) |
| Rascunho | Contrato salvo sem nenhum download registrado |
| Concluído | Contrato com pelo menos 1 download registrado |
| Imutável | Contrato com `imutavel=true` — conteúdo bloqueado por trigger PostgreSQL |
| Referência | Código sequencial por usuário no formato `CF-XXXX` |
| Cota | Limite de contratos do mês conforme plano do perfil |
| RPC | Remote Procedure Call — função PostgreSQL chamada via Supabase `.rpc()` |

---

*Última atualização: 2026-04-19*
