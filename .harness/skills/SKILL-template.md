# SKILL: [NOME DA SKILL]
<!-- Formato compatível com Claude Code · Antigravity · OpenCode · Cursor -->
<!-- Coloque em .harness/skills/<nome>/SKILL.md -->

## Descrição
[O que esta skill faz em uma linha]

## Quando Usar
[Descreva as situações em que esta skill deve ser invocada]

## Pré-condições
- [Condição 1 — ex: "Directive correspondente foi lida"]
- [Condição 2 — ex: "Variáveis de ambiente configuradas"]

## Procedimento

### Passo 1 — [Nome do passo]
[Instrução clara e específica]
```
[Comando ou código se aplicável]
```

### Passo 2 — [Nome do passo]
[Instrução]

### Passo N — Verificar resultado
[Como confirmar que a skill foi executada com sucesso]

## Output Esperado
```json
{
  "status": "success",
  "resultado": {}
}
```

## Erros Conhecidos

| Erro | Causa | Ação |
|------|-------|------|
| [mensagem de erro] | [causa] | [o que fazer] |

## Aprendizados (Self-Annealing)
<!-- Atualize quando descobrir edge cases ou melhorias -->
- [data] [aprendizado]

---

## Como Invocar Esta Skill

**Claude Code:**
```
/nome-da-skill [contexto]
```

**Antigravity:**
```
Use @nome-da-skill para [contexto]
```

**OpenCode:**
```
Use nome-da-skill [contexto]
```

**No prompt manual:**
```
Leia .harness/skills/nome-da-skill/SKILL.md e execute o procedimento
para [contexto específico].
```
