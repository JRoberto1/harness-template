# Domínio: Jurídico / Financeiro

> Ative: marque `[x] Jurídico / Financeiro` no AGENTS.md
> Tolerância zero para ambiguidade.

## Regras Absolutas
- **Nunca** gere cláusula sem base legal explícita citada (CC/2002, CLT, LGPD...)
- **Nunca** omita campos obrigatórios — use `[DADO_AUSENTE: descrição]`
- **Nunca** infira intenção jurídica — seja explícito ou marque `[VERIFICAR]`
- Valores monetários: **sempre em centavos (integer)**, nunca float
- Cálculos: use biblioteca de precisão (Decimal.js / Python `decimal`)
- Arredondamento: documentar qual regra (ABNT, bancária) antes de implementar

## Schemas
```typescript
type Clausula = {
  numero: string;        // "1.1", "2.3.a"
  conteudo: string;
  base_legal: string;   // "Art. 593 do CC/2002"
  obrigatoria: boolean;
};

type Transacao = {
  valor_centavos: number;     // SEMPRE inteiro
  idempotency_key: string;   // previne duplicação
  status: "pendente" | "confirmada" | "estornada" | "falha";
};
```

## Quality Gates (antes de gerar qualquer documento final)
- [ ] Identificação completa de todas as partes
- [ ] Cláusula de objeto, valor, prazo, rescisão e foro presentes
- [ ] Para contratos de TI: cláusula de propriedade intelectual
- [ ] Para dados pessoais: cláusula de LGPD
- [ ] Nenhum `[DADO_AUSENTE]` no documento final
- [ ] Todos os valores em centavos (nenhum float)
- [ ] Idempotency key em toda transação

## Erros Projetados
```
VIOLAÇÃO JURÍDICO-FINANCEIRO: valor em float
SEVERIDADE: CRÍTICA
ARQUIVO: src/payments/calc.ts:88
AÇÃO: Converta para centavos (integer). Ex: 1999 em vez de 19.99
REF: .harness/domains/juridico-financeiro.md
```
