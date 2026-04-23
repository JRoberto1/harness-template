# /ship — Checklist de Produção

Não faça deploy sem passar por este checklist.
Se algum item falhar, não ship.

## Como usar

```
/ship
/ship v1.2.0
/ship feature/login
```

## Instrução para o Agente

Execute cada item na ordem. Registre PASS ou FAIL.
Se qualquer item for FAIL → não prossiga, corrija primeiro.

### Checklist

**Código**
- [ ] `/review` executado e aprovado
- [ ] Todos os testes passando (`npm test` / `pytest`)
- [ ] Sem `console.log` solto em produção
- [ ] Sem `any` em TypeScript
- [ ] Sem credenciais hardcoded

**Segurança**
- [ ] `.env` não commitado
- [ ] Protected paths do `config.json` respeitados
- [ ] Inputs validados nos endpoints novos
- [ ] Dependencies sem vulnerabilidades críticas (`npm audit`)

**Documentação**
- [ ] `docs/architecture.md` atualizado se houve decisão nova
- [ ] `docs/domain-rules.md` atualizado se houve regra nova
- [ ] Directive correspondente atualizada (Hashimoto)
- [ ] `.harness/VERSION` incrementado

**Deploy**
- [ ] Branch atualizada com main/master
- [ ] Build passa localmente
- [ ] Variáveis de ambiente do ambiente alvo configuradas
- [ ] Plano de rollback definido se algo quebrar

### Formato de Saída

```
## Ship Checklist — [versão/feature]

✅ PASS: [N] itens
❌ FAIL: [N] itens

Falhas:
- [item] → [o que corrigir]

Veredicto: PRONTO PARA DEPLOY | BLOQUEADO
```

### Anti-Rationalization

❌ "É urgente, vou pular alguns itens" → Urgência não cancela segurança
❌ "Já fiz isso antes sem problema" → Sorte não é processo
❌ "É só um hotfix pequeno" → Hotfixes sem checklist geram hotfixes de hotfix
