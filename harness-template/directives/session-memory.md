# Directive: Memória de Sessão

## Objetivo
Garantir continuidade entre sessões de trabalho — o agente retoma
exatamente de onde parou, sem reexplicação, sem perda de contexto.

## Quando Usar
- **Sempre** ao encerrar uma sessão de trabalho (`/wrap-session`)
- **Sempre** ao iniciar uma nova sessão (`/brief-session`)
- Ao trocar de runtime (ex: Claude Code → Antigravity)

## Estrutura de Arquivos

```
.harness/memory/
├── last-session.md              ← sempre a sessão mais recente
├── 2026-04-20-autenticacao.md   ← sessões por data e tema
├── 2026-04-21-contratos-pdf.md
└── INDEX.md                     ← índice de todas as sessões
```

## Fluxo de Encerramento (/wrap-session)

```
1. Coletar contexto da sessão atual
2. Salvar em .harness/memory/YYYY-MM-DD-[tema].md
3. Sobrescrever last-session.md
4. Atualizar INDEX.md
5. Aplicar Hashimoto se houver aprendizados
6. Confirmar para o usuário
```

## Fluxo de Inicialização (/brief-session)

```
1. Ler last-session.md (ou arquivo específico)
2. Ler AGENTS.md + docs/architecture.md
3. Apresentar briefing resumido
4. Aguardar instrução do usuário
```

## Troca de Runtime

Quando trocar de Claude Code para Antigravity (ou qualquer outro):

**No runtime que está saindo** — rode `/wrap-session`

**No novo runtime** — cole este prompt:

```
Leia o GEMINI.md (ou AGENTS.md) e em seguida leia
.harness/memory/last-session.md para entender o contexto
do projeto e onde paramos.

Apresente um briefing resumido e aguarde minha instrução.
```

## Regras

- Nunca inicie trabalho sem ler `last-session.md` se ele existir
- Nunca encerre sessão sem salvar o contexto
- O `last-session.md` é sempre sobrescrito — guarda apenas a sessão mais recente
- Arquivos por data são permanentes — nunca apague
- Aprendizados da sessão devem ir também para a directive correspondente (Hashimoto)

## Aprendizados
<!-- Atualize aqui quando encontrar melhorias no processo -->
- [data] [aprendizado]
