# 🗺️ Roteiro de Aprendizado — JaCaMo

> Baseado na documentação oficial, tutoriais e exemplos do projeto JaCaMo.  
> O projeto `learn_jacamo` que você criou **já é nosso laboratório vivo** — vamos evoluí-lo a cada módulo.

---

## Como funciona este roteiro

Cada módulo tem:
- **Conceito** — por que isso existe e o que resolve
- **Prática** — modificações reais no projeto
- **Experimento** — o que observar rodando
- **Links** — documentação de referência

Execute o projeto a qualquer momento com:
```bash
./gradlew -q --console=plain
```

Inspecione o estado em tempo real pelos browsers:
- `http://localhost:3272` → Mind Inspector (agentes)
- `http://localhost:3273` → Workspace Inspector (ambiente)
- `http://localhost:3271` → Organisation Inspector (organização)

---

## O mapa completo

```
MÓDULO 0  →  MÓDULO 1  →  MÓDULO 2  →  MÓDULO 3  →  MÓDULO 4  →  MÓDULO 5  →  MÓDULO 6
 Teoria       Projeto      Agentes      Ambiente    Organização  Coordenação   Avançado
 (MAOP/BDI)  (estrutura)  (Jason)      (CArtAgO)    (Moise)      (3 modos)    (Mineradores)
```

---

## Módulo 0 — O que é JaCaMo e por que existe?

**Tempo estimado:** 1 sessão de leitura + discussão

### Conceito

Sistemas multi-agentes (MAS) são sistemas onde múltiplos agentes autônomos interagem. JaCaMo é uma plataforma que integra **três dimensões** para programar esses sistemas:

| Dimensão | Tecnologia | O que programa |
|----------|-----------|----------------|
| **Agentes** | Jason / AgentSpeak | O *raciocínio* de cada agente |
| **Ambiente** | CArtAgO | O *mundo compartilhado* onde os agentes vivem e agem |
| **Organização** | Moise | As *regras sociais* que coordenam os agentes |

O modelo mental central é o **BDI (Belief-Desire-Intention)**:
- **Belief (Crença):** o que o agente *sabe* sobre o mundo
- **Desire (Desejo):** o que o agente *quer* alcançar (= objetivos/goals)
- **Intention (Intenção):** o que o agente *decidiu* fazer agora (= planos em execução)

### Por que isso importa?

Compare com programação tradicional:
- Num programa Java, você define *o que fazer passo a passo* (imperativo)
- Em Jason, você declara *como reagir a eventos e como alcançar objetivos* (declarativo + reativo)

Um agente BDI não espera ser chamado — ele reage ao ambiente, mantém objetivos de longo prazo e raciocina sobre o que fazer, mesmo com incerteza.

### Leitura recomendada

- [JaCaMo — visão geral](https://jacamo-lang.github.io/)
- [Getting Started oficial](https://jacamo-lang.github.io/getting-started)
- Conceito BDI na [Wikipedia](https://en.wikipedia.org/wiki/Belief%E2%80%93desire%E2%80%93intention_software_model)

---

## Módulo 1 — O Projeto: estrutura e primeiros passos

**Tempo estimado:** 1 sessão prática

### Conceito

O arquivo `.jcm` é o **ponto de entrada** de todo sistema JaCaMo. Ele descreve o estado inicial do MAS: quais agentes existem, qual ambiente eles habitam e em qual organização participam.

### Explorando o projeto atual

Abra `learn_jacamo.jcm` e leia cada bloco:

```
mas learn_jacamo {

    agent bob: sample_agent.asl {   ← agente chamado "bob", código em sample_agent.asl
      focus: w.c1                   ← bob presta atenção no artefato c1 do workspace w
    }

    workspace w {
      artifact c1: example.Counter(3)   ← artefato Counter iniciando com valor 3
    }

    organisation o: org.xml {
      group g1 : group1 {
        players: bob role1              ← bob joga o papel "role1"
      }
    }
}
```

### Prática — Execute e observe

```bash
./gradlew -q --console=plain
```

O que você verá:
```
[Cartago] Workspace w created.
[Cartago] artifact c1: example.Counter(3) at w created.
[bob] join workspace /main/w: done
[bob] hello world.
```

Abra `http://localhost:3272` → clique em "bob" → veja as crenças dele.

### Prática — Simplifique o projeto

Para entender melhor, **remova tudo** e deixe apenas o agente:

```
mas learn_jacamo {
    agent bob: sample_agent.asl
}
```

Execute novamente. O que mudou? Bob ainda diz "hello world"?

### Estrutura de arquivos

```
src/
├── agt/
│   └── sample_agent.asl    ← código do agente (Jason/AgentSpeak)
├── env/
│   └── example/
│       └── Counter.java    ← artefato de ambiente (CArtAgO)
└── org/
    └── org.xml             ← especificação organizacional (Moise)
```

### Links

- [Referência do arquivo .jcm](https://jacamo-lang.github.io/jacamo/jcm.html)

---

## Módulo 2 — Agentes: Beliefs, Goals e Plans (Jason/AgentSpeak)

**Tempo estimado:** 2–3 sessões práticas

### Conceito

Um agente Jason é um arquivo `.asl` com três partes:

```prolog
// --- BELIEFS (crenças iniciais) ---
feliz(bob).
idioma(pt).

// --- GOALS (objetivos iniciais) ---
!saudar.

// --- PLANS (planos) ---
+!saudar : feliz(bob) & idioma(I)
    <- .concat("Olá! Idioma: ", I, Msg);
       .print(Msg).
```

**Sintaxe de um plano:**
```
+!evento : contexto <- corpo.
  │           │          │
  │           │          └─ sequência de ações separadas por ;
  │           └─ condição avaliada nas crenças (pode ser vazia: true)
  └─ evento que dispara o plano (+! = novo objetivo, + = nova crença)
```

### Prática 2.1 — Dois agentes conversando

Crie `src/agt/alice.asl`:
```prolog
!dizer_oi.

+!dizer_oi
    <- .send(bob, tell, saudacao("oi mundo")).

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
```

Crie `src/agt/bob.asl`:
```prolog
+saudacao(M)[source(A)]
    <- .print("Recebi '", M, "' de ", A).

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
```

Atualize `learn_jacamo.jcm`:
```
mas learn_jacamo {
    agent alice: alice.asl
    agent bob:   bob.asl
}
```

**O que observar:** A crença de bob no Mind Inspector inclui `saudacao("oi mundo")[source(alice)]`. A anotação `[source(alice)]` é automática — toda crença sabe de onde veio.

### Prática 2.2 — Planos alternativos (contextos)

Adicione ao `bob.asl`:
```prolog
confio_em(alice).

+saudacao(M)[source(A)] : confio_em(A)[source(self)]
    <- .print("(fonte confiável) Recebi '", M, "' de ", A).

+saudacao(M)[source(A)]
    <- .print("(fonte desconhecida) Ignorando mensagem de ", A).
```

O plano mais específico (com contexto) é tentado primeiro. `[source(self)]` garante que apenas crenças que o próprio bob estabeleceu contam — não outra agente dizendo "confio_em(alice)".

### Prática 2.3 — Loops e reatividade

```prolog
!contar.

+!contar
    <- .print("contando...");
       .wait(1000);
       !contar.    // recursão = loop persistente
```

### Conceitos importantes desta fase

| Conceito | Sintaxe | Significado |
|----------|---------|-------------|
| Nova crença | `+crenca(X)` | Evento de adição de crença |
| Crença removida | `-crenca(X)` | Evento de remoção de crença |
| Novo objetivo | `+!objetivo` | Evento de novo objetivo |
| Falha de objetivo | `-!objetivo` | Plano de tratamento de falha |
| Consulta | `?crenca(X)` | Busca X nas crenças (bloqueia se não encontrar) |
| Variável | `X`, `Msg`, `V` | Começa com maiúscula |
| Átomo | `alice`, `ok`, `42` | Começa com minúscula ou é número |

### Ações internas úteis (prefixo `.`)

```prolog
.print("mensagem", Variavel).     // imprime
.send(Agente, tell, conteudo).    // envia crença
.send(Agente, achieve, !objetivo). // envia objetivo
.broadcast(tell, conteudo).        // manda para todos
.wait(1000).                       // espera 1 segundo
.my_name(Nome).                    // descobre próprio nome
.findall(X, crenca(X), Lista).     // coleta resultados em lista
.length(Lista, N).                 // tamanho da lista
.nth(0, Lista, Primeiro).          // elemento por índice
```

### Exercícios do Módulo 2

1. Crie um agente `carlos.asl` que diz "bom dia" para todos os outros agentes ao iniciar
2. Faça bob responder diferente dependendo do dia da semana (use `.date(Y,M,D)`)
3. Implemente um contador regressivo: bob começa em 10 e conta até 0, imprimindo cada número

### Links

- [Tutorial BDI Hello World (Jason)](https://jason-lang.github.io/jason/tutorials/hello-bdi/readme.html)
- [API de ações internas](http://jason-lang.github.io/api/jason/stdlib/package-summary.html)

---

## Módulo 3 — Ambiente: Artefatos e Workspaces (CArtAgO)

**Tempo estimado:** 2 sessões práticas

### Conceito

O ambiente em JaCaMo é composto de **artefatos** — objetos compartilhados que os agentes podem *perceber* e *usar*. Um artefato é análogo a uma ferramenta do mundo real:

- Tem **propriedades observáveis** → viram crenças dos agentes que focam nele
- Tem **operações** → agentes as executam como ações
- Pode emitir **sinais** → eventos que os agentes reagem

O `Counter.java` que já existe no projeto é um artefato simples. Veja:

```java
public class Counter extends Artifact {
    void init(int initialValue) {
        defineObsProperty("count", initialValue);  // propriedade observável
    }

    @OPERATION
    void inc() {
        ObsProperty prop = getObsProperty("count");
        prop.updateValue(prop.intValue() + 1);     // muda o estado
        signal("tick");                             // emite sinal
    }

    @OPERATION
    void inc_get(int inc, OpFeedbackParam<Integer> newValueArg) {
        ObsProperty prop = getObsProperty("count");
        int newValue = prop.intValue() + inc;
        prop.updateValue(newValue);
        newValueArg.set(newValue);                 // retorno via parâmetro
    }
}
```

### Prática 3.1 — Dois agentes usando o mesmo Counter

Atualize `learn_jacamo.jcm`:
```
mas learn_jacamo {

    agent alice: alice.asl {
        focus: w.c1
    }
    agent bob: bob.asl {
        focus: w.c1
    }

    workspace w {
        artifact c1: example.Counter(0)
    }
}
```

`alice.asl`:
```prolog
!contar.

+!contar
    <- inc_get(1, NovoValor);
       .print("Alice pegou o valor único: ", NovoValor);
       .wait(800);
       !contar.

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
```

`bob.asl`:
```prolog
!contar.

+!contar
    <- inc;
       .wait(1200);
       !contar.

+count(X)
    <- .print("Bob percebe: contador = ", X).

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
```

**O que observar:**
- Alice usa `inc_get` (recebe o valor novo via parâmetro de retorno)
- Bob usa `inc` (sem retorno, mas reage à mudança da propriedade observável `count`)
- A crença `count(X)` de bob é atualizada automaticamente pelo artefato
- Em `http://localhost:3273` você vê o estado do artefato em tempo real

### Prática 3.2 — Criando seu próprio artefato

Crie `src/env/example/Placar.java`:

```java
package example;

import cartago.*;

public class Placar extends Artifact {

    void init() {
        defineObsProperty("pontos_alice", 0);
        defineObsProperty("pontos_bob",   0);
    }

    @OPERATION
    void marcar_ponto(String agente) {
        String prop = "pontos_" + agente;
        ObsProperty p = getObsProperty(prop);
        if (p != null) {
            p.updateValue(p.intValue() + 1);
        } else {
            failed("Agente desconhecido: " + agente);
        }
    }
}
```

Adicione ao `.jcm`:
```
workspace w {
    artifact c1:      example.Counter(0)
    artifact placar:  example.Placar() {
        focused-by: alice, bob
    }
}
```

Nos agentes, use `marcar_ponto("alice")` como uma ação normal.

### Conceitos desta fase

| Conceito | Como usar no agente |
|----------|-------------------|
| Propriedade observável | Vira crença automática: `count(X)` |
| Executar operação | Como ação: `inc.` ou `inc_get(1, V).` |
| Selecionar artefato específico | `inc[artifact_name(c1)].` |
| Sinal emitido | Reaja com plano: `+tick[artifact_id(AId)]` |
| Criar artefato em runtime | `makeArtifact("nome", "Classe", [], Id).` |
| Focar em artefato | `focus(Id).` |

### Exercícios do Módulo 3

1. Crie um artefato `Termometro` com propriedade `temperatura` e operação `ajustar(Delta)`. Faça um agente ajustar a temperatura periodicamente e outro reagir quando ela sair de um intervalo
2. Crie um artefato `FilaDeTrabalho` onde agentes podem `depositar(Tarefa)` e `pegar(Tarefa)`. Dois agentes competem para pegar tarefas

### Links

- [CArtAgO by Examples (PDF)](https://github.com/CArtAgO-lang/cartago/blob/master/docs/cartago_by_examples/cartago_by_examples.pdf)
- [Tutorial Hello World — Parte III (ambiente)](http://jacamo-lang.github.io/jacamo/tutorials/hello-world/readme.html#part-iii-environment)

---

## Módulo 4 — Organização: Grupos, Papéis e Esquemas (Moise)

**Tempo estimado:** 2–3 sessões práticas

### Conceito

A organização define as **regras sociais** do MAS. Com Moise, você especifica:

- **Estrutural:** quais grupos existem, quais papéis (roles) cada grupo tem, quantos agentes podem jogar cada papel
- **Funcional:** quais objetivos coletivos existem (schemes), como se decompõem, quais missões distribuem os objetivos
- **Normativo:** quais papéis têm *permissão* ou *obrigação* de cumprir quais missões

A vantagem: o **código do agente não precisa saber quem é quem**. A organização cuida da coordenação.

### O arquivo org.xml atual

Abra `src/org/org.xml` e identifique as três partes:
1. `<structural-specification>` — grupos e roles
2. `<functional-specification>` — schemes e missões
3. `<normative-specification>` — normas (obrigações e permissões)

### Prática 4.1 — Papéis sem código de coordenação

Atualize `learn_jacamo.jcm`:
```
mas learn_jacamo {

    agent alice: alice.asl {
        focus: w.c1
        roles: role1 in g1
    }
    agent bob: bob.asl {
        focus: w.c1
        roles: role2 in g1
    }

    workspace w {
        artifact c1: example.Counter(0)
    }

    organisation o: org.xml {
        group g1: group1 {
            players: alice role1
                     bob   role2
        }
    }
}
```

Em `alice.asl`, troque o envio de mensagem para usar o papel em vez do nome:
```prolog
+!saudar
    <- .wait(play(Ag, role2, _));   // espera até saber quem joga role2
       .send(Ag, tell, oi("mundo")).
```

Alice não sabe que é bob quem está lá — ela sabe apenas que existe alguém com `role2`. Se trocar o agente, o código de alice não muda.

### Prática 4.2 — Inspecionando a organização

Execute o projeto e abra `http://localhost:3271`. Você verá:
- O grupo `g1` com os papéis atribuídos
- As crenças organizacionais nos agentes (use o Mind Inspector)

Crenças organizacionais importantes nos agentes:
- `play(alice, role1, g1)` — alice joga role1 no grupo g1
- `play(bob,   role2, g1)` — bob   joga role2 no grupo g1

### Prática 4.3 — Agentes obedientes

Para que agentes respeitem automaticamente suas obrigações organizacionais, inclua no `.asl`:
```prolog
{ include("$moise/asl/org-obedient.asl") }
```

Com isso, quando a organização criar uma obrigação para o agente cumprir um objetivo, ele automaticamente tenta cumpri-lo usando seus planos.

### O ciclo completo de uma organização

```
Especificação (org.xml)
        ↓
  Instância de grupo (g1: group1)
        ↓
  Agentes adotam papéis (alice → role1)
        ↓
  Instância de scheme (hello_eng: hello_sch)
        ↓
  Grupo é responsável pelo scheme
        ↓
  Normas geram obrigações para os agentes
        ↓
  Agentes obedientes executam seus planos
```

### Exercícios do Módulo 4

1. Crie uma organização simples com 3 papéis: `coordenador`, `trabalhador`, `relator`. O coordenador envia tarefas (via org, não por mensagem direta), trabalhadores executam, relator imprime o resultado
2. Modifique `org.xml` para exigir ao mínimo 2 trabalhadores. Observe o que acontece com apenas 1

### Links

- [Tutorial Hello World — Parte IV (organização)](http://jacamo-lang.github.io/jacamo/tutorials/hello-world/readme.html#part-iv-organisation)
- [Documentação Moise](http://moise.sourceforge.net/doc)

---

## Módulo 5 — Coordenação: As Três Dimensões

**Tempo estimado:** 3+ sessões práticas

### Conceito

Este é o ponto central do JaCaMo. O mesmo problema de coordenação pode ser resolvido de **três formas diferentes**, cada uma com trade-offs:

| Abordagem | Via | Vantagem | Desvantagem |
|-----------|-----|----------|-----------|
| **Agente** | Troca de mensagens | Simples, flexível | Acoplamento entre agentes |
| **Ambiente** | Artefatos compartilhados | Encapsula o protocolo | Artefato deve ser projetado bem |
| **Organização** | Normas e esquemas | Declarativo, auditável | Mais complexo de especificar |

### Exemplo — Leilão em três versões

O tutorial de coordenação oficial implementa um sistema de leilão de três formas. Replique cada uma:

#### Versão 1: Por mensagens (agente-centrada)

```
auctioneer.asl broadcasts auction →
participants send bids →
auctioneer collects 4 bids, announces winner
```

Problema: auctioneer precisa saber quantos participantes existem (`L,4` hardcoded).

#### Versão 2: Por ambiente (artefato de leilão)

```
AuctionArtifact.java encapsula o protocolo:
  - operação start(Desc)
  - operação bid(Valor)
  - operação stop()
  - propriedade observável winner

Agentes apenas percebem e agem no artefato.
```

Vantagem: mudar o protocolo = mudar o artefato, não os agentes.

#### Versão 3: Por organização (normas e esquemas)

```
org-spec define:
  - role auctioneer obrigado a: start, decide
  - role participant obrigado a: bid (dentro de 10s)

Organização controla sequência, deadlines e sanções.
```

Vantagem: a coordenação é **declarativa** — você descreve o que deve acontecer, não como implementar.

### Prática 5.1 — Implemente a versão por mensagens

Crie o projeto `auction_ag` dentro do seu workspace e siga o [tutorial de coordenação](http://jacamo-lang.github.io/jacamo/tutorials/coordination/readme.html).

### Prática 5.2 — Evolua para a versão por artefato

Compare os arquivos `.asl` das duas versões. O que mudou? O que permaneceu igual?

### Perguntas para reflexão

- Em um sistema **aberto** (participantes entram e saem), qual abordagem é mais robusta?
- Se o protocolo mudar, em qual versão você toca menos código?
- Como tratar participantes que não cumprem obrigações (em cada versão)?

### Links

- [Tutorial de Coordenação completo](http://jacamo-lang.github.io/jacamo/tutorials/coordination/readme.html)

---

## Módulo 6 — Exemplo Avançado: Gold Miners

**Tempo estimado:** 2–4 sessões

### Conceito

Um ambiente de mineração com:
- **Mineradores** que exploram o grid em busca de ouro
- **Líder** que coordena e coleta pontuações
- **Depósito** onde o ouro é entregue

Este exemplo é ótimo para entender:
- Agentes reativos vs. pró-ativos em ação real
- Comunicação em um sistema com múltiplos agentes da mesma "espécie"
- Raciocínio sobre desejos e intenções em andamento

### Baixar e explorar

```bash
wget https://jacamo.sourceforge.net/tutorial/gold-miners/initial-gold-miners.zip
unzip initial-gold-miners.zip
cd initial-gold-miners
./gradlew -q --console=plain
```

### Progressão dos exercícios

| Exercício | Habilidade praticada |
|-----------|---------------------|
| a) Imprimir posição alvo | `.print`, planos básicos |
| b) Diferenciar motivos | Planos alternativos com contexto |
| c) Contar ouro dropado | Atualizar crenças (`-+score(Y)`) |
| d) Localização dinâmica do depósito | Consulta ao belief base no contexto |
| e) Enviar pontuação ao líder | `.send`, comunicação inter-agente |
| f) Líder anuncia o vencedor | Lógica de comparação, atualização de crença |
| g) Broadcast do vencedor | `.broadcast` |
| h) Minerador se vangloria | Reação a mensagem recebida |
| i) Pegar ouro no caminho | `.desire`, `.drop_desire` — gestão de intenções |

### Links

- [Tutorial Gold Miners](https://jacamo-lang.github.io/jacamo/tutorials/gold-miners/readme.html)

---

## Módulo 7 — Ferramentas: Debug, Testes e Boas Práticas

**Tempo estimado:** 1–2 sessões

### Debug

**Mind Inspector** (`http://localhost:3272`):
- Veja crenças, objetivos, intenções de cada agente em tempo real
- Identifique por que um plano não foi selecionado (contexto falhou)
- Monitore intenções suspensas

**Workspace Inspector** (`http://localhost:3273`):
- Estado de todos os artefatos
- Quais agentes estão focando em quais artefatos

**Organisation Inspector** (`http://localhost:3271`):
- Estado dos grupos e schemes
- Obrigações em aberto, cumpridas, violadas

**Logging** — configure `logging.properties` para ver detalhes:
```properties
jason.level = FINE     # logs detalhados de Jason
cartago.level = FINE   # logs de CArtAgO
```

### Testes

JaCaMo suporta **testes orientados a objetivos**. Veja a pasta `src/test/`:

```
mas tests.jcm {
    agent test_sample: test-sample.asl {
        # agente de teste
    }
}
```

Um agente de teste verifica se outros agentes alcançam os objetivos esperados. Execute com:
```bash
./gradlew test
```

### Boas práticas

- **Nomeie planos** com comentários descritivos
- **Evite hardcode** de nomes de agentes — use papéis organizacionais
- **Encapsule protocolos** em artefatos quando possível
- **Use `[source(self)]`** para crenças que só você mesmo pode estabelecer
- **Trate falhas** com planos `-!objetivo[error(Tipo)]`
- **Prefira `org-obedient.asl`** para agentes que devem respeitar a organização

### Links

- [Debugging em JaCaMo](https://jacamo-lang.github.io/jacamo/debug.html)
- [Goal-Oriented TDD para JaCaMo](https://jacamo-lang.github.io/jacamo/tutorials/tdd/readme.html)
- [Padrões úteis em Jason](https://jason-lang.github.io/jason/tech/patterns.html)

---

## Módulo 8 — Projeto Final: Construindo algo seu

**Tempo estimado:** livre

Aplique tudo que aprendeu construindo um sistema com:

- Pelo menos **3 agentes** com comportamentos distintos
- Um ou mais **artefatos de ambiente** que encapsulam estado compartilhado
- Uma **organização** com papéis e pelo menos um scheme
- **Coordenação mista**: parte via mensagens, parte via artefato, parte via organização

### Ideias de projetos

| Projeto | Complexidade | Conceitos |
|---------|-------------|-----------|
| Sistema de estoque com fornecedores e compradores | Média | Artefatos, mensagens |
| Sala de reunião com agenda compartilhada | Média | Artefatos, organização |
| Time de robôs de limpeza colaborativos | Alta | BDI avançado, coordenação |
| Mercado de ações simulado | Alta | Todas as três dimensões |
| Sistema de monitoramento com alertas | Média | Reatividade, artefatos |

---

## Referências rápidas

### Documentação oficial
- [JaCaMo Site](https://jacamo-lang.github.io/)
- [Getting Started](https://jacamo-lang.github.io/getting-started)
- [Documentação completa](https://jacamo-lang.github.io/doc)
- [Referência do .jcm](https://jacamo-lang.github.io/jacamo/jcm.html)

### Tutoriais
- [Hello World JaCaMo](http://jacamo-lang.github.io/jacamo/tutorials/hello-world/readme.html)
- [BDI Hello World (Jason)](https://jason-lang.github.io/jason/tutorials/hello-bdi/readme.html)
- [Coordenação (3 dimensões)](http://jacamo-lang.github.io/jacamo/tutorials/coordination/readme.html)
- [Gold Miners](https://jacamo-lang.github.io/jacamo/tutorials/gold-miners/readme.html)

### APIs
- [Jason stdlib](http://jason-lang.github.io/api/jason/stdlib/package-summary.html)
- [CArtAgO API](https://github.com/CArtAgO-lang/cartago/tree/master/docs)
- [ORA4MAS (Org Artifacts)](http://moise.sourceforge.net/doc/ora4mas)

### Exemplos no repositório oficial
- [House Building](https://github.com/jacamo-lang/jacamo/tree/main/examples/house-building)
- [Auction](https://github.com/jacamo-lang/jacamo/tree/main/examples/auction)
- [Writing Paper](https://github.com/jacamo-lang/jacamo/tree/main/examples/writing-paper)

---

*Roteiro criado para o projeto `learn_jacamo` — JaCaMo 1.3.0*
