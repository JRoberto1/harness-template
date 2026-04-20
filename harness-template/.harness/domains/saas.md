# Domínio: SaaS / Produto Web

> Ative: marque `[x] SaaS Web` no AGENTS.md

## Regras
- Ações destrutivas exigem confirmação explícita do usuário
- Loading obrigatório em operações assíncronas · Erros com mensagem acionável
- JWT: máx 24h · Refresh tokens em httpOnly cookie (nunca localStorage)
- Logout invalida token no servidor · Rotas protegidas verificam no servidor
- Validação no cliente **e** no servidor — nunca só um dos dois
- Dados sensíveis (CPF, cartão) nunca nos logs

## Arquitetura
```
Tipos/Schemas → lib/ → components/ui → components/features → pages/
```
Dependências fluem em uma direção — nunca inverta.

## Quality Gates
- [ ] Sem console.error em produção
- [ ] Imagens com atributo `alt` · Formulários acessíveis (labels associados)
- [ ] Variáveis de ambiente validadas no startup

## Erros Projetados
```
VIOLAÇÃO SaaS: token em localStorage
ARQUIVO: src/lib/auth.ts:42
AÇÃO: Mova para httpOnly cookie com setAuthCookie()
REF: .harness/domains/saas.md
```
