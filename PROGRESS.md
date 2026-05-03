## Módulo atual

- **Módulo:** 5 — Coordenação: As Três Dimensões
- **Status:** Quiz da aula concluído ✅ (3/3 corretas — aprovado)
- **Anterior:** Módulo 4 — ✅ Concluído

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
| 3      | intro         | Conectar `bob` ao `Counter(5)` com `focus: w.c1` e usar `inc_get(1, NovoValor)` | ✅ Aprovado | 26/04/2026 |
| 3      | consolidação  | `Termometro` com propriedade observável `temperatura`, agente `aquecedor` e agente `fiscal` | ✅ Aprovado c/ ressalvas | 26/04/2026 |
| 4      | conceitual    | Quiz da aula: estrutura/funcional/normativa, norma de obrigação, consulta por papel | ✅ 2/3 corretas | 02/05/2026 |
| 4      | intro         | Agentes `alice` e `bob` em papéis Moise; Alice envia saudação consultando `play(Ag, role2, _)` | ✅ Aprovado | 02/05/2026 |
| 4      | consolidação  | Organização própria com `scheme1`, `mission1`, norma `role2 -> mission1` e `org-obedient.asl` | ✅ Aprovado c/ ressalvas | 03/05/2026 |
| 5      | conceitual    | Quiz da aula: coordenação por artefato, Moise no `.jcm`, leilão em sistema aberto | ✅ 3/3 corretas | 03/05/2026 |
| 5      | intro         | Comparação entre coordenação por mensagens Jason e por artefato CArtAgO (`TarefaBoard`) | ✅ Aprovado c/ ressalvas | 03/05/2026 |

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

**Módulo 3 — exercício intro (26/04/2026)**
- `src/ex/mod3-ex1.jcm`: bob foca corretamente o artefato `w.c1`; workspace `w` declara `c1` como `example.Counter(5)`
- `src/agt/mod3_intro.asl`: plano `+!observar_contador : count(N)` lê a propriedade observável como crença, imprime `5`, chama `inc_get(1, NovoValor)` e imprime `6`
- Saída confirmada: workspace e artefato criados, bob focando `c1`, `Valor inicial do contador: 5`, `Valor do contador apos incremento: 6`
- Rubrica: corretude lógica ✅; sintaxe ✅; estrutura ✅; idioms JaCaMo ✅
- Ponto de destaque: boa integração entre JaCaMo `.jcm`, crença Jason derivada de propriedade observável CArtAgO e operação com retorno via `OpFeedbackParam`
- Próximo passo recomendado: exercício de consolidação do Módulo 3 com mais de um agente ou um artefato próprio simples

**Módulo 3 — exercício de consolidação (26/04/2026)**
- `src/env/example/Termometro.java`: artefato CArtAgO criado com propriedade observável `temperatura` e operação `ajustar(int delta)` usando `updateValue`
- `src/ex/mod3-ex2.jcm`: MAS `mod3_ex2` configurado com agentes `aquecedor` e `fiscal` focando o mesmo artefato `w.termometro`
- `src/agt/aquecedor_mod3.asl`: corrigido para manter `ajustar(3)`, `.wait(1000)` e recursão `!aquecer` dentro do mesmo plano
- `src/agt/fiscal_mod3.asl`: corrigido para usar dois planos com guarda, `T < 30` e `T >= 30`, sem plano genérico competindo pelo mesmo evento
- Rubrica: corretude lógica ✅; sintaxe ✅ após correção; estrutura ✅; idioms JaCaMo ⚠️ por confusão inicial entre ação interna Jason (`.wait`) e operação CArtAgO (`ajustar`)
- Ponto de atenção: em Jason, o ponto final encerra o plano; ações no corpo ficam entre `<-` e `.` separadas por `;`
- Ponto de atenção: ações internas Jason usam prefixo `.`, enquanto operações CArtAgO expostas por `@OPERATION` são chamadas sem `.`
- Próximo passo recomendado: revisar sinais CArtAgO (`signal`) e então avançar para a aula do Módulo 4 (Moise)

**Módulo 4 — quiz da aula (02/05/2026)**
- Q1 (especificações Moise): ✅ correto — distinguiu estrutural, funcional e normativa, incluindo a ligação papel→missão
- Q2 (norma de obrigação): ✅ correto — identificou que `role2` fica obrigado a cumprir `mission1`
- Q3 (consulta por papel): ⚠️ parcial — apontou `play(bob, role2, g1)`, mas para evitar acoplamento o padrão é consultar com variável: `play(Ag, role2, _)`
- Próximo passo: exercício intro do Módulo 4

**Módulo 4 — exercício intro (02/05/2026)**
- `src/ex/mod4-ex1.jcm`: MAS `mod4_ex1` criado com organização `o: org.xml`, grupo `g1: group1`, `alice role1` e `bob role2`
- `src/agt/alice_mod4.asl`: uso correto de `.wait(play(Ag, role2, _))` para descobrir o agente pelo papel antes de enviar `saudacao("bom dia")`
- `src/agt/bob_mod4.asl`: reação correta a `+saudacao(Texto)[source(Remetente)]`, imprimindo a mensagem e a origem
- Saída confirmada: `OrgBoard o created`, `group created: g1: group1`, agentes focando `g1` e `o`, e `[bob] recebi 'bom dia' de alice`
- Rubrica: corretude lógica ✅; sintaxe ✅; estrutura ✅; idioms JaCaMo ✅
- Ponto de destaque: consolidou o desacoplamento por papel — Alice não usa `.send(bob, ...)`, mas envia para a variável `Ag` obtida de `play(Ag, role2, _)`
- Próximo passo recomendado: exercício de consolidação do Módulo 4 com obrigações/missões ou reforço curto em `org-obedient.asl`

**Módulo 4 — exercício de consolidação (03/05/2026)**
- Objetivo: conectar `scheme`, `mission`, `norm` e `org-obedient.asl` para que o agente `trabalhador` cumpra objetivos organizacionais
- Dificuldade observada: entender que `<norm ... role="role2" mission="mission1"/>` no XML não basta sozinho; em runtime o `.jcm` também precisa instanciar o `scheme` e ligar o grupo com `responsible-for`
- Dificuldade observada: `scheme s1: scheme1` cria a instância do processo, mas `group g1` precisa declarar `responsible-for: s1` para que o grupo seja responsável por esse processo
- Dificuldade observada: o `org.xml` global tinha `goal2 -> goal3 -> goal4`, com `goal3` em `mission2`; isso confundiu a consolidação porque o exercício queria focar só `mission1` (`goal2` e `goal4`)
- Decisão didática: criar uma organização própria para o exercício (`src/org/org_mod4_ex2.xml`) com sequência simplificada `goal2 -> goal4`, evitando alterar o `src/org/org.xml` global
- `src/ex/mod4-ex2.jcm`: solução final usa `organisation o: org_mod4_ex2.xml`, `group g1: group1`, `responsible-for: s1`, `players: coordenadora role1 / trabalhador role2`, e `scheme s1: scheme1`
- `src/agt/trabalhador_mod4.asl`: planos `+!goal2` e `+!goal4` definidos e `org-obedient.asl` incluído para transformar obrigação Moise em objetivos Jason
- `src/agt/coordenadora_mod4.asl`: plano inicial observa a crença organizacional `play(Ag, role2, _)` e imprime quem joga `role2`
- Saída parcial confirmada pelo aluno: `scheme created: s1: scheme1`, `group created: g1: group1`, coordenadora percebe `trabalhador role2`, e trabalhador recebe obrigação: `I am obliged to commit to mission1 on s1... doing so`
- Rubrica: corretude lógica ✅ com ressalva operacional; sintaxe ✅; estrutura ✅; idioms JaCaMo ✅
- Ponto de atenção: o runtime JaCaMo não finaliza sozinho; use `timeout ...` ou interrompa com `Ctrl+C` depois de observar logs/inspetores
- Próximo passo recomendado: revisar no Organisation Inspector o estado de `s1`, `mission1`, `goal2` e `goal4`; depois avançar para o próximo passo do Módulo 4 ou para integração no Módulo 5

**Módulo 5 — quiz da aula (03/05/2026)**
- Q1 (coordenação por artefato): ✅ correto — identificou que estado/protocolo saem dos agentes e passam ao ambiente compartilhado, como em `Termometro.java`
- Q2 (trecho com `responsible-for` e `scheme`): ✅ correto — reconheceu que a coordenação principal é Moise, por papel/missão/norma
- Q3 (leilão com participantes dinâmicos): ✅ correto — escolheu organização como abordagem mais robusta para sistema aberto, por permitir atribuir responsabilidades por papel/missão em runtime
- Próximo passo: exercício intro do Módulo 5, comparando explicitamente coordenação por mensagens, artefato e organização

**Módulo 5 — exercício intro (03/05/2026)**
- Objetivo: implementar o mesmo fluxo de coordenação em duas versões mínimas: por mensagem direta Jason (`mod5_ex1_msg`) e por artefato compartilhado CArtAgO (`mod5_ex1_art`)
- `src/ex/mod5-ex1-msg.jcm`: MAS com `coordenadora` e `executor`; a coordenadora envia `tarefa(...)` por `.send`, e o executor responde com `concluida(...)`
- `src/ex/mod5-ex1-art.jcm`: MAS com os mesmos papéis de agentes, mas a coordenação passa pelo artefato `w.tarefaBoard`
- `src/env/example/TarefaBoard.java`: artefato criado com propriedade observável `status`, iniciando em `"pendente"`, e operação `concluir()` que muda para `"concluida"`
- Ponto de atenção: em Jason, variáveis começam com maiúscula; `s` é átomo literal, enquanto `Status` é variável
- Ponto de atenção: `.wait(status("pendente"))` lê/aguarda a crença observável sem modificar o artefato; quem modifica o estado é a operação CArtAgO `concluir`
- Rubrica: corretude lógica ✅; sintaxe ✅; estrutura ✅; idioms JaCaMo ✅ com ressalva didática sobre variáveis e percepts observáveis
- Próximo passo recomendado: exercício de consolidação do Módulo 5, integrando mensagem, artefato e organização em um fluxo único
