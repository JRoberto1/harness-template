# PEV — Plan · Execute · Verify

> O coração operacional do harness.
> Separa raciocínio de implementação em 3 fases distintas.

---

## PLAN — Prompt de Planejamento

Use este prompt antes de qualquer tarefa com 3+ arquivos:

```
Leia o AGENTS.md, a directive relevante em directives/ e os domínios
ativos em .harness/domains/.

Preciso implementar: [DESCREVA A TAREFA]

Antes de qualquer código:
1. Liste todos os arquivos a criar/modificar
2. Para cada arquivo, defina critério de aceitação VERIFICÁVEL
   (não "implementar X" — mas "curl retorna 200" ou "pytest passa")
3. Identifique dependências entre tarefas
4. Liste o que está FORA do escopo
5. Identifique qual script em execution/ pode ser reutilizado
6. Aponte riscos e mitigações

Não escreva código ainda. Aguarde aprovação do plano.
```

### Template de Plano

```markdown
## Plano: [Nome]
Data: [data] | Branch: [nome] | Directive: [nome ou N/A]

### Objetivo
[Uma frase do que será entregue]

### Tarefas
| # | Tarefa | Arquivo(s) | Script reutilizável | Critério de Aceitação |
|---|--------|-----------|--------------------|-----------------------|
| 1 | [desc] | [arquivo]  | execution/[script] | [como verificar]      |

### Fora do Escopo
- [Item — previne scope creep]

### Riscos
- [Risco] → Mitigação: [ação]

### Aprovação
- [ ] Plano revisado | [ ] Escopo confirmado | [ ] Riscos aceitos
```

---

## VERIFY — Prompt de Verificação

Cole em **nova sessão** (contexto limpo — agente não pode auditar o próprio trabalho):

```
Você é um agente verificador com contexto limpo.
Não execute nada — apenas analise e reporte.

PLANO ORIGINAL:
[Cole o plano aprovado]

Verifique se a implementação atende cada critério.
Retorne APENAS:

{
  "verificacoes": [
    {
      "tarefa": "string",
      "criterio": "string",
      "status": "PASS | FAIL | PARCIAL",
      "evidencia": "o que encontrou",
      "acao_necessaria": "null se PASS, instrução se FAIL"
    }
  ],
  "resultado_global": "APROVADO | REPROVADO | APROVADO_COM_RESSALVAS",
  "hashimoto": "se FAIL, qual regra do harness deveria ter prevenido isso?"
}
```

### Checklist Manual

**Código**
- [ ] Sem `any` em TypeScript · Sem `console.log` em produção
- [ ] Funções com responsabilidade única · Erros tratados explicitamente

**Scripts**
- [ ] Script tem `--dry-run` · Logs estruturados · Retry implementado
- [ ] Idempotente (pode rodar 2x sem efeito colateral)

**Testes**
- [ ] `npm test` / `pytest` passa · Casos de borda cobertos

**Harness**
- [ ] Directive atualizada com aprendizados desta tarefa?
- [ ] Novo edge case → adicionado ao harness?

---

## Regra de Hashimoto — Aplicada na Verificação

Quando encontrar falha recorrente:
1. Documente em `docs/domain-rules.md`
2. Adicione ao quality gate (`.harness/quality-gates/pre-commit`)
3. Atualize a directive correspondente em `directives/`
4. Commit: `harness(quality-gate): [descrição da melhoria]`
