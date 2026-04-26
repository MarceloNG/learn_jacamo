## Módulo atual

- **Módulo:** 3 — Ambiente: Artefatos e Workspaces (CArtAgO)
- **Status:** Quiz da aula concluído ✅ (3/3 corretas — aprovado)
- **Anterior:** Módulo 2 — ✅ Concluído

## Histórico de exercícios

| Módulo | Nível         | Exercício                                                       | Status               | Data       |
|--------|---------------|-----------------------------------------------------------------|----------------------|------------|
| 0      | intro         | Declarar `modulo_atual(0)` e imprimir o valor via `+!start`     | ✅ Concluído          | 22/04/2026 |
| 0      | consolidação  | BDI completo: `humor(mau)→bom` com gatilho de crença `+humor(bom)` | ✅ Aprovado c/ ressalvas | 22/04/2026 |
| 0      | conceitual    | Perguntas de auto-verificação BDI + dimensões + `focus`         | ✅ Q1 e Q2 corretas; Q3 parcial (percept→crença não articulado) | 23/04/2026 |
| 1      | conceitual    | Quiz da aula: instâncias independentes, focus, beliefs iniciais | ✅ 3/3 corretas                                                  | 23/04/2026 |
| 1      | intro         | Segundo artefato `c2` no workspace + `focus` diferente para alice e bob | ✅ Aprovado | 23/04/2026 |
| 1      | consolidação  | MAS com 3 agentes, 2 artefatos, `focused-by`, `goals:` e `worker.asl`   | ✅ Aprovado | 23/04/2026 |
| 2      | conceitual    | Quiz da aula: guarda de plano, gatilho de crença, plano com condição inicial | ✅ Q2 correta; Q1 e Q3 parciais (2/3 aprovado) | 23/04/2026 |
| 2      | intro         | Dois planos alternativos para `+!apresentar` usando guarda `turno(manha)` e fallback | ✅ Aprovado | 25/04/2026 |
| 2      | consolidação  | Três agentes com `.send(..., tell, saudacao(...))` e planos alternativos por `[source(A)]` | ✅ Aprovado | 25/04/2026 |
| 3      | conceitual    | Quiz da aula: propriedades observáveis, `updateValue` vs `signal`, `inc` vs `inc_get` | ✅ 3/3 corretas | 26/04/2026 |

## Observações do tutor

**Módulo 0 — consolidação (22/04/2026)**
- Ponto de atenção: operador `-+X` — o argumento é o **destino**, não a origem
- Ponto de atenção: distinção entre `+!meta` (gatilho de meta) e `+crença(X)` (gatilho de crença)
- Ponto de atenção: contexto de guarda usa `not crença(X)` para testar ausência; `-crença(X)` só vale no corpo do plano

**Módulo 0 — perguntas de auto-verificação (23/04/2026)**
- Q1 (Belief vs Intention): ✅ conceito correto, especialmente distinção Desire vs Intention; faltou exemplo cotidiano explícito
- Q2 (separação em dimensões): ✅ correto — separação de responsabilidades, independência, processos distribuídos
- Q3 (focus: w.c1): ⚠️ parcialmente correto — identificou percepção do artefato, mas não articulou que sem `focus` os percepts (ex: `count(N)`) não viram crenças no belief base
- Próximo passo recomendado: exercício intro do Módulo 1 (estrutura do projeto `.jcm`)

**Módulo 1 — quiz da aula (23/04/2026)**
- Q1 (instâncias independentes): ✅ correto — `.asl` é tipo, cada declaração cria objeto distinto com belief base próprio
- Q2 (sem focus): ✅ correto — percepts não viram crenças; agente não percebe o artefato
- Q3 (beliefs iniciais): ✅ correto — `beliefs: papel(supervisora)` dentro do bloco `agent`; implementado e executado em `src/ex/mod1-ex1.jcm`
- Próximo passo recomendado: exercício intro do Módulo 1

**Módulo 1 — exercício intro (23/04/2026)**
- `mod1-ex2.jcm`: ambos os TODOs resolvidos corretamente — `artifact c2: example.Counter(10)` e `focus: w.c2` para alice
- Saída confirmada: bob percebe `count(3)` e alice percebe `count(10)` como esperado
- Descoberta proativa: identificou bug em `sample_agent.asl` — plano `+!monitorar_contador` chamava `inc` sem checar o valor inicial; corrigido com `if (N < 6) { inc }`
- Ponto de destaque: uso idiomático do `if` dentro do corpo de plano — padrão importante para controle de fluxo em AgentSpeak
- Próximo passo recomendado: exercício de consolidação do Módulo 1

**Módulo 1 — exercício de consolidação (23/04/2026)**
- `mod1-ex3.jcm`: MAS montado do zero com bob, alice e carlos usando arquivos `.asl` distintos
- Ponto de destaque: compreensão de que `goals:` no `.jcm` **adiciona** goals (não substitui) — solução correta foi criar `worker.asl` sem `!monitorar_contador`
- Ponto de destaque: `focused-by` dentro do bloco do artefato vs `focus:` no bloco do agente — distinção importante
- Ponto de atenção: `goals:` no `.jcm` não pode remover goals declarados no `.asl`; para controlar comportamento por instância, a abordagem idiomática é usar arquivos `.asl` distintos
- Módulo 1 concluído ✅ — pronto para Módulo 2 (Agentes: Beliefs, Goals e Plans)

**Módulo 2 — quiz da aula (23/04/2026)**
- Q1 (contexto/guarda): ⚠️ parcial — correto que plano não executa, mas faltou que Jason tenta o próximo plano aplicável antes de falhar
- Q2 (gatilho de crença `+temperatura(T)`): ✅ correto — identificou disparador, guarda, print e adição de crença
- Q3 (plano com crença inicial): ⚠️ parcial — lógica correta, mas faltou ponto em `.print` e argumento no goal era redundante com a guarda
- Próximo passo: exercício intro do Módulo 2

**Módulo 2 — exercício intro (25/04/2026)**
- `mod2_intro.asl`: solução final usa dois planos para o mesmo gatilho `+!apresentar`, com plano específico para `turno(manha)` e fallback genérico
- Ponto de destaque: entendeu que fallback deve ser outro plano `+!apresentar`, não um plano de falha `-!apresentar`
- Ponto de atenção: Jason seleciona um plano aplicável para o evento; ele não executa todos os planos cujas guardas são verdadeiras
- Próximo passo recomendado: exercício de consolidação do Módulo 2

**Módulo 2 — exercício de consolidação (25/04/2026)**
- `alice_mod2.asl` e `carlos_mod2.asl`: uso correto de `.send(bob, tell, saudacao(...))` com nome de agente em minúsculo
- `bob_mod2.asl`: corrigido para reagir a crença recebida com `+saudacao(M)[source(A)]`, usando guarda `confio_em(A)` e fallback
- Ponto de destaque: consolidou a diferença entre `tell` gerando evento de crença (`+crenca`) e achievement goal (`+!meta`)
- `src/ex/mod2-ex2.jcm`: MAS próprio do exercício declarado como `mod2_ex2`
- Módulo 2 concluído ✅ — pronto para Módulo 3 (Ambiente: Artefatos e Workspaces)

**Módulo 3 — quiz da aula (26/04/2026)**
- Q1 (propriedade observável): ✅ correto — identificou que `defineObsProperty` vira crença automática para agentes com `focus` e é atualizada quando o Java muda
- Q2 (`updateValue` vs `signal`): ✅ correto — distinguiu atualização de crença observável de emissão de sinal/evento separado
- Q3 (`inc` vs `inc_get`): ✅ correto — entendeu operação sem retorno vs operação com retorno via variável ligada no plano
- Próximo passo: exercício intro do Módulo 3
