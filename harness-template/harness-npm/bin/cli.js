#!/usr/bin/env node
// ============================================================
// Bifrost — Harness Engineering CLI
// v2.0.0 — Todos os Sprints A+B+C+D incluídos
// ============================================================

const fs   = require("fs");
const path = require("path");
const https = require("https");
const readline = require("readline");

const VERSION = "2.0.0";
const TARGET  = process.cwd();
const REPO    = "https://raw.githubusercontent.com/sickn33/antigravity-awesome-skills/main/skills";

const c = {
  reset:"\x1b[0m", bold:"\x1b[1m", green:"\x1b[32m",
  yellow:"\x1b[33m", blue:"\x1b[34m", cyan:"\x1b[36m", red:"\x1b[31m"
};
const ok   = s => console.log(`  ${c.green}✓${c.reset} ${s}`);
const warn = s => console.log(`  ${c.yellow}⚠${c.reset} ${s}`);
const info = s => console.log(`  ${c.cyan}→${c.reset} ${s}`);

function ask(q, def="") {
  const rl = readline.createInterface({input:process.stdin,output:process.stdout});
  return new Promise(r => rl.question(def?`${q} [${def}]: `:`${q}: `, a=>{rl.close();r(a.trim()||def);}));
}
function askYN(q){return ask(`${q} [s/n]`,"n").then(a=>a.toLowerCase()==="s");}

function write(p,content,overwrite=false){
  const full=path.join(TARGET,p);
  fs.mkdirSync(path.dirname(full),{recursive:true});
  if(!overwrite&&fs.existsSync(full))return false;
  fs.writeFileSync(full,content,"utf8");
  return true;
}

function fetchSkill(name){
  return new Promise(resolve=>{
    const url=`${REPO}/${name}/SKILL.md`;
    const dest=path.join(TARGET,`.harness/skills/${name}`);
    fs.mkdirSync(dest,{recursive:true});
    const file=fs.createWriteStream(path.join(dest,"SKILL.md"));
    https.get(url,{rejectUnauthorized:false},res=>{
      if(res.statusCode!==200){file.close();fs.rmSync(dest,{recursive:true,force:true});resolve(false);return;}
      res.pipe(file);file.on("finish",()=>{file.close();resolve(true);});
    }).on("error",()=>{file.close();resolve(false);});
  });
}

const BUNDLES = {
  essentials:["brainstorming","debugging-strategies","doc-coauthoring","lint-and-validate","create-pr"],
  saas:["brainstorming","architecture","frontend-design","api-design-principles","test-driven-development","security-auditor","create-pr"],
  api:["api-design-principles","api-security-best-practices","test-driven-development","debugging-strategies","typescript-expert"],
  security:["security-auditor","api-security-best-practices","sql-injection-testing","vulnerability-scanner"],
  automation:["workflow-automation","debugging-strategies","python-patterns","lint-and-validate"],
  ai:["rag-engineer","prompt-engineer","brainstorming","architecture"],
  sdlc:["spec-driven-development","planning-and-task-breakdown","incremental-implementation","test-driven-development","code-review-and-quality","security-and-hardening","git-workflow-and-versioning","shipping-and-launch"],
};

// ── Conteúdo dos arquivos ──────────────────────────────────

function agentsMd(name,desc,stack,domains){
  const m=v=>v?"x":" ";
  return `# AGENTS.md — ${name}
<!-- Claude Code · Antigravity · OpenCode · Cursor · Copilot -->
<!-- Bifrost v${VERSION} -->

> Leia este arquivo completamente antes de qualquer ação.

## Identidade

Você é um agente de engenharia do projeto **${name}**.
${desc}

Stack: ${stack}

## Arquitetura de 3 Camadas

\`\`\`
Camada 1 — directives/      → SOPs: o QUE fazer
                ↓
Camada 2 — .harness/doe/    → Orquestração: COMO o agente age
                ↓
Camada 3 — execution/       → Scripts determinísticos: FAZ
\`\`\`

## Regras Absolutas

1. Nunca avance sem validar o output da etapa anterior
2. Nunca invente — marque \`[VERIFICAR: motivo]\`
3. Nunca quebre a arquitetura de \`docs/architecture.md\`
4. Verifique \`execution/\` antes de criar script novo
5. Nunca use \`any\` em TypeScript nem ignore erros
6. Aplique o Protocolo PEV em tarefas com 3+ arquivos
7. Aplique a Regra de Hashimoto: cada erro melhora o harness
8. Classifique a intenção antes de executar (Intent Gate)

## Intent Gate

| Intenção | Ação |
|----------|------|
| Pesquisa | Responda direto, sem carregar directives |
| Implementação | Carregue directive + PEV |
| Investigação | Carregue \`directives/diagnose.md\` |
| Correção | Carregue directive + PEV + Hashimoto |
| Revisão | Carregue \`directives/observation-masking.md\` |

## Protocolo PEV

\`\`\`
PLAN    → critérios verificáveis antes de qualquer código
EXECUTE → dentro do plano aprovado
VERIFY  → falha = volta ao Plan com contexto de erro
\`\`\`

## Frases Proibidas

| Proibido | Tokens | Substituto |
|---------|--------|-----------|
| "Vou ser feliz em ajudar..." | 8 | [execute] |
| "O motivo pelo qual isto..." | 7 | [causa direta] |
| "Eu recomendaria que..." | 7 | [afirme] |
| "Claro, deixa eu ver isso" | 8 | [veja e responda] |

## Memória

Ao iniciar: leia \`.harness/memory/last-session.md\` se existir.
Ao encerrar: salve em \`.harness/memory/last-session.md\`.
Claude Code: \`/wrap-session\` e \`/brief-session\`.

## Domínios Ativos

- [${m(domains.saas)}] SaaS Web              → \`.harness/domains/saas.md\`
- [${m(domains.api)}] API / Backend         → \`.harness/domains/api.md\`
- [${m(domains.auto)}] Automação / Scripts   → \`.harness/domains/automation.md\`
- [${m(domains.jf)}] Jurídico / Financeiro → \`.harness/domains/juridico-financeiro.md\`

## Skills

> Instale: \`npx harness-engineering skill <nome>\`

*Bifrost v${VERSION} — ${new Date().toISOString().split("T")[0]}*
`;
}

const DOMAINS = {
  saas:`# Domínio: SaaS / Produto Web\n\n## Regras\n- Ações destrutivas exigem confirmação\n- JWT: máx 24h · Refresh em httpOnly cookie\n- Validação no cliente E servidor\n- Dados sensíveis fora dos logs\n\n## Quality Gates\n- [ ] Sem console.error em produção\n- [ ] Imagens com alt · Formulários acessíveis\n- [ ] Variáveis de ambiente validadas no startup\n`,
  api:`# Domínio: API / Backend\n\n## Regras\n- Versioning: /api/v1/\n- Envelope: { success, data, error, meta }\n- Rate limiting em endpoints públicos\n- SQL: sempre parametrizado\n\n## Quality Gates\n- [ ] Schema de validação em todos endpoints\n- [ ] Timeout em chamadas externas\n- [ ] Health check em /health\n`,
  automation:`# Domínio: Automações / Scripts\n\n## Regras\n- Idempotência: pode rodar N vezes\n- Falha explícita: nunca silenciosa\n- Estado persistido para retomada\n- --dry-run obrigatório\n\n## Quality Gates\n- [ ] Script tem --dry-run\n- [ ] Logs com job_id, step, timestamp\n- [ ] Retry com backoff exponencial\n`,
  jf:`# Domínio: Jurídico / Financeiro\n\n## Regras Absolutas\n- NUNCA gere cláusula sem base legal (CC/2002, CLT, LGPD)\n- NUNCA omita campos — use [DADO_AUSENTE: descrição]\n- Valores monetários: SEMPRE centavos (integer), nunca float\n- Cálculos: use biblioteca de precisão (Decimal.js)\n\n## Quality Gates\n- [ ] Identificação completa das partes\n- [ ] Cláusulas: objeto, valor, prazo, rescisão, foro\n- [ ] Para TI: cláusula de propriedade intelectual\n- [ ] Para dados pessoais: cláusula de LGPD\n- [ ] Nenhum [DADO_AUSENTE] no documento final\n- [ ] Todos os valores em centavos\n`,
};

const CONFIG_JSON = `{
  "$schema": "./.harness/config.schema.json",
  "version": "${VERSION}",
  "protected_paths": [".env", ".env.*", "secrets/", "credentials/", "terraform/", "infra/", "*.pem", "*.key"],
  "allowed_paths": ["src/", "app/", "components/", "lib/", "pages/", "directives/", "execution/", "docs/", "AGENTS.md", "CLAUDE.md", "GEMINI.md"],
  "tech_choice_mode": "ask",
  "session": { "auto_wrap_on_stop": true, "compress_after_turns": 8, "memory_path": ".harness/memory" },
  "quality_gate": { "block_secrets": true, "block_console_log": true, "block_typescript_any": true, "block_float_monetary": false, "block_env_commit": true }
}`;

const INDEX_MD = `# .harness/index.md — Índice Central do Bifrost\n<!-- v${VERSION} -->\n\n> Leia PRIMEIRO. Carregue apenas o que tiver match.\n\n## Directives\n\n| Arquivo | Palavras-chave | Quando carregar |\n|---------|---------------|----------------|\n| \`directives/session-memory.md\` | sessão, memória, retomar, parar, continuar | ao iniciar/encerrar |\n| \`directives/context-management.md\` | tokens, contexto, compressão, budget | ao gerenciar tokens |\n| \`directives/subagent-dispatch.md\` | subagente, delegar, tarefa pesada | tarefa > 20k tokens |\n| \`directives/observation-masking.md\` | log longo, output longo, masking | output > 20 linhas |\n| \`directives/harness-evolution.md\` | evolução, hashimoto, melhoria, erro recorrente | ao melhorar harness |\n| \`directives/diagnose.md\` | diagnóstico, investigar, por que quebrou | ao investigar falhas |\n| \`directives/spec-driven.md\` | spec, especificação, requisitos, antes de código | ao iniciar feature |\n\n## Domínios\n\n| Arquivo | Palavras-chave |\n|---------|---------------|\n| \`.harness/domains/saas.md\` | frontend, UI, autenticação, JWT, produto web |\n| \`.harness/domains/api.md\` | endpoint, API, REST, backend, rota |\n| \`.harness/domains/automation.md\` | script, automação, batch, pipeline |\n| \`.harness/domains/juridico-financeiro.md\` | contrato, cláusula, LGPD, valor, pagamento |\n\n## Camada 2 — DOE\n\n| Arquivo | Quando usar |\n|---------|------------|\n| \`.harness/doe/diretrizes.md\` | ao configurar system prompt global |\n| \`.harness/doe/orquestracao.md\` | ao montar prompt do planejador |\n| \`.harness/doe/execucao.md\` | ao montar prompt de subagente |\n`;

const LAST_SESSION = `# Última Sessão\n\n> Use /wrap-session ao encerrar · /brief-session ao retomar\n\nNenhuma sessão registrada ainda.\n`;

// ── Instalar ─────────────────────────────────────────────────
async function cmdInstall(){
  console.log(`\n${c.bold}╔══════════════════════════════════════╗${c.reset}`);
  console.log(`${c.bold}║    🌉 Bifrost Harness v${VERSION}          ║${c.reset}`);
  console.log(`${c.bold}╚══════════════════════════════════════╝${c.reset}\n`);

  if(fs.existsSync(path.join(TARGET,".harness/VERSION"))){
    const v=fs.readFileSync(path.join(TARGET,".harness/VERSION"),"utf8").trim();
    warn(`Bifrost ${v} já instalado.`);
    info(`Instalar skills: npx harness-engineering skill --bundle essentials`);
    info(`Verificar: npx harness-engineering check`);
    return;
  }

  console.log(`${c.bold}[ 1/4 ] Sobre o projeto\n${c.reset}`);
  const name  = await ask("Nome do projeto");
  const desc  = await ask("Descrição em uma linha");
  const stack = await ask("Stack (ex: Next.js + Node + PostgreSQL)","não definida");

  console.log(`\n${c.bold}[ 2/4 ] Domínios ativos\n${c.reset}`);
  const domains={
    saas: await askYN("  SaaS / Produto Web?"),
    api:  await askYN("  API / Backend?"),
    auto: await askYN("  Automação / Scripts?"),
    jf:   await askYN("  Jurídico / Financeiro?"),
  };

  console.log(`\n${c.bold}[ 3/4 ] Instalando arquivos...\n${c.reset}`);

  // Core
  const agents=agentsMd(name,desc,stack,domains);
  write("AGENTS.md",agents,true); write("CLAUDE.md",agents,true); write("GEMINI.md",agents,true);
  ok("AGENTS.md · CLAUDE.md · GEMINI.md");

  write(".harness/VERSION",VERSION,true); ok(".harness/VERSION");
  write(".harness/index.md",INDEX_MD,true); ok(".harness/index.md");
  write(".harness/config.json",CONFIG_JSON,true); ok(".harness/config.json");
  write(".harness/memory/last-session.md",LAST_SESSION,true); ok(".harness/memory/");

  // Domínios
  if(domains.saas){write(".harness/domains/saas.md",DOMAINS.saas,true);ok("domain: saas");}
  if(domains.api) {write(".harness/domains/api.md",DOMAINS.api,true);ok("domain: api");}
  if(domains.auto){write(".harness/domains/automation.md",DOMAINS.automation,true);ok("domain: automation");}
  if(domains.jf)  {write(".harness/domains/juridico-financeiro.md",DOMAINS.jf,true);ok("domain: juridico-financeiro");}

  // PEV
  write(".harness/pev/pev.md",`# PEV — Plan · Execute · Verify\n\nPLAN    → critérios verificáveis antes de qualquer código\nEXECUTE → dentro do plano aprovado\nVERIFY  → falha = volta ao Plan com contexto de erro\n`,true);
  ok(".harness/pev/pev.md");

  // SKILL template
  write(".harness/skills/SKILL-template.md",`# SKILL: [NOME]\n\n## Quando Usar\n[Descreva]\n\n## Procedimento\n1. [Passo 1]\n\n## Output\n[Descreva]\n`,true);

  // Directives
  write("directives/DIRECTIVE-template.md",`# Directive: [NOME]\n\n## Objetivo\n[Uma frase]\n\n## Fluxo\n1. [Passo]\n\n## Aprendizados\n- [data] [aprendizado]\n`,true);
  ok("directives/");

  // Execution
  write("execution/SCRIPT-template.py",`#!/usr/bin/env python3\n"""Script determinístico — Camada 3 do Bifrost.\nUso: python execution/SCRIPT-template.py --input "valor" [--dry-run]\n"""\nimport argparse,json,sys\n\ndef main():\n    p=argparse.ArgumentParser()\n    p.add_argument("--input",required=True)\n    p.add_argument("--dry-run",action="store_true")\n    args=p.parse_args()\n    if args.dry_run:\n        print(json.dumps({"status":"success","dry_run":True,"simulacao":args.input}))\n        sys.exit(0)\n    print(json.dumps({"status":"success","resultado":args.input}))\n\nif __name__=="__main__":main()\n`,true);
  ok("execution/SCRIPT-template.py");

  // Claude commands — Sprint B
  const cmds={
    "spec.md":`# /spec — Spec-Driven Development\n\nEscreva a spec ANTES de qualquer código.\n\n## Instrução\nCrie um documento de spec com: visão geral, problema, escopo (inclui/não inclui), critérios de aceitação, impacto técnico.\nSalve em docs/specs/[nome].md. Aguarde aprovação antes de implementar.\n\n## Anti-Rationalization\n❌ "É urgente" → Urgência é motivo para ter spec, não para pular\n❌ "É simples" → Spec descobre complexidade antes do código\n`,
    "plan.md":`# /plan — Decomposição em Tarefas\n\nDecomponha em tarefas com critérios verificáveis.\n\n## Instrução\nLeia a spec em docs/specs/ se existir. Crie tabela com: tarefa, arquivo(s), critério verificável, dependência.\nAguarde aprovação antes de executar.\n\n## Anti-Rationalization\n❌ "As tarefas são óbvias" → Se é óbvio, leva 2min escrever. Escreva.\n❌ "Posso fazer tudo de uma vez" → Tarefas grandes = contexto pesado = erros\n`,
    "review.md":`# /review — Code Review Multi-Dimensional\n\nQuality gate antes de merge.\n\n## 5 Dimensões\n1. Correção — faz o que a spec diz?\n2. Legibilidade — nomes claros, responsabilidade única?\n3. Arquitetura — segue as camadas?\n4. Segurança — inputs validados, sem credenciais hardcoded?\n5. Performance — sem N+1, sem loops desnecessários?\n\n## Anti-Rationalization\n❌ "Eu escrevi, sei que está certo" → Revisão existe por isso\n❌ "Testes passam, está bom" → Testes passam código errado o tempo todo\n`,
    "ship.md":`# /ship — Checklist de Produção\n\nNão faça deploy sem este checklist.\n\n## Checklist\n- [ ] /review executado e aprovado\n- [ ] Todos os testes passando\n- [ ] Sem console.log em produção\n- [ ] .env não commitado\n- [ ] docs/architecture.md atualizado se houve decisão nova\n- [ ] Build passa localmente\n- [ ] Plano de rollback definido\n\n## Anti-Rationalization\n❌ "É urgente, vou pular alguns" → Urgência não cancela segurança\n❌ "É só um hotfix" → Hotfixes sem checklist geram hotfixes de hotfix\n`,
    "wrap-session.md":`# /wrap-session — Encerrar Sessão\n\nSalva o contexto antes de parar. Usa ~500 tokens na próxima sessão em vez de 20k.\n\n## Instrução\nResuma: decisões tomadas, tarefas concluídas, tarefas pendentes (com prioridade), próximo passo exato, aprendizados Hashimoto.\nSalve em .harness/memory/last-session.md e em .harness/memory/YYYY-MM-DD-[tema].md.\n`,
    "brief-session.md":`# /brief-session — Retomar Sessão\n\nLê o contexto salvo. Economiza 97% dos tokens de reintrodução.\n\n## Instrução\nLeia .harness/memory/last-session.md. Apresente: o que foi concluído, o que está pendente, próximo passo. Aguarde instrução antes de executar.\n`,
    "context-check.md":`# /context-check — Verificar Contexto\n\n## Instrução\nReporte: directives carregadas, turnos desta sessão, tokens estimados.\nSe --compress: execute python execution/compress-history.py --auto\n`,
    "model-select.md":`# /model-select — Selecionar Modelo\n\n## Tabela\n| Tarefa | Modelo |\n|--------|--------|\n| Docs, testes, formatação | Haiku / Mini |\n| Código, implementação | Sonnet / padrão |\n| Arquitetura, debugging | Opus / Pro |\n\n## Instrução\nSe o usuário passou uma descrição, classifique e recomende em 2 linhas.\n`,
  };
  for(const[f,content] of Object.entries(cmds)){
    write(`.claude/commands/${f}`,content,true);
  }
  ok(".claude/commands/ (8 comandos)");

  // Docs templates
  write("docs/architecture.md",`# Arquitetura\n\n> Preencha com a stack REAL do projeto.\n\n## Stack\n\n| Camada | Tecnologia |\n|--------|----------|\n| Frontend | ${stack} |\n\n## Camadas e Dependências\n\n\`\`\`\n[descreva as camadas]\n\`\`\`\n\n## ADRs\n\n### ADR-001: [Decisão]\n**Data:** | **Status:** Aceita\n**Contexto:** [por quê]\n**Decisão:** [o que]\n`,true);
  write("docs/domain-rules.md",`# Regras de Domínio\n\n> Preencha com as regras de negócio REAIS.\n> Atualize sempre que encontrar uma regra nova (Hashimoto).\n\n## Schemas\n\n\`\`\`typescript\n// defina seus tipos aqui\n\`\`\`\n\n## Regras de Negócio\n\n### RN-001: [Nome]\n**Descrição:** [o que impõe]\n**Motivo:** [por que existe]\n`,true);
  write("docs/coding-standards.md",`# Padrões de Código\n\n## Regras\n- Sem \`any\` em TypeScript\n- Erros tratados explicitamente\n- Logs estruturados\n- Commits: \`tipo(escopo): descrição\`\n  - feat, fix, docs, refactor, test, harness\n`,true);
  ok("docs/ (architecture, domain-rules, coding-standards)");

  // Agents
  write("agents/code-reviewer.md",`# Agente: Code Reviewer\n\nRevisor sênior com framework de 5 dimensões: Correção · Legibilidade · Arquitetura · Segurança · Performance.\n\n## Ferramentas\nRead, Bash(grep:*), Bash(npm test:*), Bash(npm run lint:*)\n`,true);
  write("agents/security-auditor.md",`# Agente: Security Auditor\n\nAuditor focado em OWASP Top 10. Viés: tudo é vulnerável até provar o contrário.\n\n## Ferramentas\nRead, Bash(grep:*) — NUNCA Write ou Edit\n`,true);
  ok("agents/ (code-reviewer, security-auditor)");

  // .tmp e .gitignore
  fs.mkdirSync(path.join(TARGET,".tmp"),{recursive:true});
  write(".tmp/.gitkeep","# Temporários\n",true);
  const gi=path.join(TARGET,".gitignore");
  const toAdd=[".env",".env.*","!.env.example",".tmp/",".harness/skills/.index-cache.json"];
  let existing=fs.existsSync(gi)?fs.readFileSync(gi,"utf8"):"";
  const newLines=toAdd.filter(l=>!existing.includes(l));
  if(newLines.length)fs.appendFileSync(gi,"\n# Bifrost\n"+newLines.join("\n")+"\n");
  ok(".gitignore atualizado");

  // Skills essenciais
  console.log(`\n${c.bold}[ 4/4 ] Instalando skills essenciais...\n${c.reset}`);
  const bundle=domains.saas?"saas":"essentials";
  const skills=BUNDLES[bundle];
  let installed=0;
  for(const skill of skills){
    process.stdout.write(`  ${skill}... `);
    const s=await fetchSkill(skill);
    console.log(s?`${c.green}✓${c.reset}`:`${c.yellow}offline${c.reset}`);
    if(s)installed++;
  }

  // Registrar skills no AGENTS.md
  const ap=path.join(TARGET,"AGENTS.md");
  if(fs.existsSync(ap)&&installed>0){
    let content=fs.readFileSync(ap,"utf8");
    if(!content.includes("## Skills Instaladas")){
      content+="\n\n## Skills Instaladas\n\n> Instale mais: `npx harness-engineering skill --bundle essentials`\n\n";
      for(const s of skills)content+=`- \`.harness/skills/${s}/SKILL.md\`\n`;
      fs.writeFileSync(ap,content);
      fs.writeFileSync(path.join(TARGET,"CLAUDE.md"),content);
      fs.writeFileSync(path.join(TARGET,"GEMINI.md"),content);
    }
  }

  console.log(`\n${c.bold}╔══════════════════════════════════════╗${c.reset}`);
  console.log(`${c.bold}║      🌉 Bifrost Instalado!           ║${c.reset}`);
  console.log(`${c.bold}╚══════════════════════════════════════╝${c.reset}\n`);
  console.log(`  Projeto: ${c.blue}${name}${c.reset}`);
  console.log(`  Skills:  ${c.blue}${installed}/${skills.length} instaladas${c.reset}\n`);
  console.log(`${c.bold}  Próximos passos:${c.reset}`);
  info(`Preencha ${c.cyan}docs/architecture.md${c.reset} com sua stack real`);
  info(`Preencha ${c.cyan}docs/domain-rules.md${c.reset} com suas regras de negócio`);
  info(`Mais skills: ${c.cyan}npx harness-engineering skill --bundle sdlc${c.reset}`);
  info(`Verificar: ${c.cyan}npx harness-engineering check${c.reset}`);
  console.log();
}

// ── Skill ────────────────────────────────────────────────────
async function cmdSkill(args){
  if(!fs.existsSync(path.join(TARGET,".harness/VERSION"))){
    console.log(`\n${c.red}Bifrost não instalado.${c.reset} Rode: npx harness-engineering\n`);return;
  }
  if(!args.length||args[0]==="--list"){
    console.log(`\n${c.bold}Bundles disponíveis:\n${c.reset}`);
    for(const[b,s]of Object.entries(BUNDLES))console.log(`  ${c.cyan}${b}${c.reset}: ${s.join(", ")}`);
    console.log(`\nUso: npx harness-engineering skill <nome>`);
    console.log(`     npx harness-engineering skill --bundle <bundle>\n`);return;
  }
  let skillNames=[];
  if(args[0]==="--bundle"){
    const b=args[1]||"essentials";
    skillNames=BUNDLES[b]||[];
    if(!skillNames.length){console.log(`\n${c.red}Bundle '${b}' não existe.${c.reset}\n`);return;}
    console.log(`\nInstalando bundle '${c.cyan}${args[1]}${c.reset}' (${skillNames.length} skills)...\n`);
  }else{skillNames=[args[0]];console.log(`\nInstalando '${c.cyan}${args[0]}${c.reset}'...\n`);}
  let installed=0;
  for(const skill of skillNames){
    process.stdout.write(`  ${skill}... `);
    const s=await fetchSkill(skill);
    console.log(s?`${c.green}✓${c.reset}`:`${c.red}✗${c.reset}`);
    if(s)installed++;
  }
  // Registrar
  const ap=path.join(TARGET,"AGENTS.md");
  if(fs.existsSync(ap)){
    let content=fs.readFileSync(ap,"utf8");
    if(!content.includes("## Skills Instaladas"))content+="\n\n## Skills Instaladas\n\n";
    for(const s of skillNames){
      if(!content.includes(s))content+=`- \`.harness/skills/${s}/SKILL.md\`\n`;
    }
    fs.writeFileSync(ap,content);
    for(const m of["CLAUDE.md","GEMINI.md"])
      if(fs.existsSync(path.join(TARGET,m)))fs.writeFileSync(path.join(TARGET,m),content);
  }
  console.log(`\n${c.green}✅ ${installed}/${skillNames.length} instaladas${c.reset}\n`);
}

// ── Check ─────────────────────────────────────────────────────
function cmdCheck(){
  console.log(`\n${c.bold}🌉 Bifrost Check${c.reset}\n${"=".repeat(30)}\n`);
  const checks=[
    ["AGENTS.md","AGENTS.md"],["CLAUDE.md","CLAUDE.md"],["GEMINI.md","GEMINI.md"],
    ["directives/","directives"],["execution/","execution"],
    [".harness/index.md",".harness/index.md"],[".harness/config.json",".harness/config.json"],
    [".harness/pev/pev.md",".harness/pev/pev.md"],[".harness/skills/",".harness/skills"],
    ["docs/architecture.md","docs/architecture.md"],
    ["docs/domain-rules.md","docs/domain-rules.md"],
    ["docs/coding-standards.md","docs/coding-standards.md"],
    [".claude/commands/spec.md",".claude/commands/spec.md"],
    [".claude/commands/wrap-session.md",".claude/commands/wrap-session.md"],
  ];
  let issues=0;
  for(const[label,p] of checks){
    const exists=fs.existsSync(path.join(TARGET,p));
    if(exists)ok(label); else{console.log(`  ${c.red}✗${c.reset} ${label}`);issues++;}
  }
  const sd=path.join(TARGET,".harness/skills");
  const sc=fs.existsSync(sd)?fs.readdirSync(sd).filter(f=>fs.statSync(path.join(sd,f)).isDirectory()).length:0;
  sc>0?ok(`${sc} skill(s) instalada(s)`):warn("Sem skills — rode: npx harness-engineering skill --bundle essentials");
  console.log(`\n${"=".repeat(30)}`);
  if(issues===0)console.log(`${c.green}✅ Bifrost íntegro${c.reset}\n`);
  else console.log(`${c.red}❌ ${issues} problema(s)${c.reset} — rode: npx harness-engineering\n`);
}

// ── Entry point ───────────────────────────────────────────────
const[,,cmd,...rest]=process.argv;
switch(cmd){
  case"skill":   cmdSkill(rest);break;
  case"check":   cmdCheck();break;
  case"stats":   require("./stats.js").printStats();break;
  case"--version":case"-v": console.log(`bifrost-harness v${VERSION}`);break;
  case"--help":case"-h":
    console.log(`\n${c.bold}🌉 Bifrost Harness Engineering v${VERSION}${c.reset}\n\nnpx harness-engineering              Instala o Bifrost\nnpx harness-engineering skill <nome> Instala uma skill\nnpx harness-engineering skill --bundle <bundle>\nnpx harness-engineering skill --list  Lista disponíveis\nnpx harness-engineering check         Verifica integridade\n\n${c.bold}Bundles:${c.reset} essentials · saas · api · security · automation · ai · sdlc\n`);break;
  default: cmdInstall();
}
