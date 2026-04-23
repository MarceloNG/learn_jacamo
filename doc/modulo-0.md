# Módulo 0 — O que é JaCaMo e por que existe?

> **Tecnologia:** Conceitual (Jason + CArtAgO + Moise)
> **Pré-requisito:** nenhum
> **Tempo estimado:** 1 sessão de leitura + discussão

---

## Por que este módulo importa

Antes de escrever qualquer linha de código JaCaMo, você precisa entender **por que essa plataforma existe** e **que problema ela resolve** — caso contrário, as três camadas (agentes, ambiente, organização) parecerão complexidade desnecessária.

A maioria dos sistemas que conhecemos é **centralizada**: um programa principal que sabe tudo e controla tudo. Essa abordagem falha quando o sistema precisa ser distribuído, adaptativo, aberto (com partes que entram e saem), ou quando múltiplas entidades autônomas precisam tomar decisões independentes.

JaCaMo existe para programar **sistemas multi-agentes (MAS)** de forma estruturada, separando claramente três preocupações que em sistemas tradicionais ficam todas misturadas no mesmo código.

---

## Conceitos fundamentais

### 1. Sistema Multi-Agente (MAS)

Um MAS é um sistema composto por múltiplos **agentes autônomos** que interagem entre si e com um ambiente compartilhado. Cada agente:

- Tem seus próprios **objetivos** (o que quer alcançar)
- Tem sua própria **visão parcial** do mundo (não conhece tudo)
- Toma **decisões independentes** (não precisa de um coordenador central)
- **Reage** a eventos do ambiente e de outros agentes

**Analogia Java:** pense em `Thread` — mas em vez de threads executando método chamados de fora, cada agente *raciocina sobre seus objetivos* e decide por conta própria o que fazer a seguir.

### 2. Modelo BDI (Belief-Desire-Intention)

O modelo mental de cada agente em JaCaMo segue o padrão **BDI**:

| Componente | Nome | O que representa | Analogia |
|-----------|------|-----------------|----------|
| **B** | Belief (Crença) | O que o agente *sabe* sobre o mundo | Variáveis / estado |
| **D** | Desire (Desejo) | O que o agente *quer* alcançar | Requisitos / objetivos |
| **I** | Intention (Intenção) | O que o agente *decidiu fazer agora* | Thread em execução |

Em vez de chamar `agente.executarTarefa()`, o agente BDI recebe eventos, consulta suas crenças, e seleciona qual plano executar para alcançar seus objetivos. O raciocínio é **declarativo**: você descreve o que o agente sabe e quer, não o fluxo de execução passo a passo.

### 3. As três dimensões de JaCaMo

JaCaMo integra três tecnologias, cada uma responsável por uma **dimensão** do sistema:

```
┌─────────────────────────────────────────────────────────┐
│                      JaCaMo                             │
│                                                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐ │
│  │   JASON      │  │   CArtAgO   │  │     MOISE       │ │
│  │             │  │             │  │                 │ │
│  │  Agentes    │  │  Ambiente   │  │  Organização    │ │
│  │  (BDI)      │  │  (Artefatos)│  │  (Normas)       │ │
│  │             │  │             │  │                 │ │
│  │  src/agt/   │  │  src/env/   │  │  src/org/       │ │
│  │  *.asl      │  │  *.java     │  │  *.xml          │ │
│  └─────────────┘  └─────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

| Dimensão | Tecnologia | O que programa | Arquivo |
|----------|-----------|----------------|---------|
| **Agentes** | Jason / AgentSpeak | O *raciocínio* de cada agente | `src/agt/*.asl` |
| **Ambiente** | CArtAgO | O *mundo compartilhado* onde os agentes vivem e agem | `src/env/**/*.java` |
| **Organização** | Moise | As *regras sociais* que coordenam os agentes | `src/org/*.xml` |
| **Projeto MAS** | JaCaMo (.jcm) | Como tudo se conecta | `learn_jacamo.jcm` |

### 4. Por que separar em três dimensões?

**Sem JaCaMo (tudo no mesmo código Java):**
```java
// Agente, ambiente e organização todos misturados
class Bob extends Thread {
    Map<String, Object> beliefs = new HashMap<>();
    List<String> goals = new ArrayList<>();
    SharedCounter counter; // estado compartilhado — quem controla o acesso?
    OrgRules rules;        // regras — como garantir que são seguidas?
    // ...
}
```

**Com JaCaMo (cada dimensão no seu lugar):**
```
bob.asl         → raciocínio do agente (puro)
Counter.java    → artefato de ambiente (puro)
org.xml         → regras organizacionais (puro)
learn_jacamo.jcm → composição dos três
```

Cada parte pode ser modificada, testada e reutilizada **independentemente**.

---

## Leitura do código real do projeto

O arquivo `learn_jacamo.jcm` mostra as três dimensões juntas:

```
mas learn_jacamo {

    agent bob: sample_agent.asl {   ← dimensão AGENTE: bob, código em sample_agent.asl
      focus: w.c1                   ← bob "percebe" o artefato c1 do workspace w
    }

    workspace w {                   ← dimensão AMBIENTE: workspace chamado w
      artifact c1: example.Counter(3)  ← artefato Counter, inicializado com valor 3
    }

    organisation o: org.xml {       ← dimensão ORGANIZAÇÃO: especificação em org.xml
      group g1 : group1 {
        players: bob role1          ← bob joga o papel "role1" no grupo g1
      }
    }
}
```

> **Nota importante:** Caso um segundo artefato do mesmo tipo (ex.: outro `Counter`) seja adicionado ao workspace, ambos exporiam a propriedade `count`. Isso causaria um conflito no belief base do agente `bob`, pois ele receberia múltiplas crenças `count(N)` (ex.: `count(3)` e `count(10)`) sem distinção de origem. Para evitar esse problema, é necessário diferenciar as propriedades ou usar nomes únicos para cada artefato.

Mesmo neste projeto mínimo, as três dimensões já estão presentes. Nos módulos seguintes, cada uma será aprofundada separadamente.

---

## Referências oficiais

- [JaCaMo — visão geral e Getting Started](https://jacamo-lang.github.io/)
- [Getting Started oficial](https://jacamo-lang.github.io/getting-started)
- [Artigo original JaCaMo (Boissier et al.)](https://doi.org/10.1016/j.scico.2011.10.004)
- [BDI na Wikipedia](https://en.wikipedia.org/wiki/Belief%E2%80%93desire%E2%80%93intention_software_model)
- [Jason — página oficial](https://jason-lang.github.io/jason/)
- [CArtAgO — repositório](https://github.com/CArtAgO-lang/cartago)
- [Moise — documentação](http://moise.sourceforge.net/doc)

---

## Antes de praticar — perguntas de auto-verificação

Responda antes de usar `/exercicio 0`. Sem olhar as respostas — discuta com `@jacamo-tutor` se tiver dúvida.

1. **Qual é a diferença entre um *Belief* e uma *Intention* no modelo BDI?** Dê um exemplo do cotidiano para cada um.

2. **Por que separar agente, ambiente e organização em arquivos diferentes?** O que você perderia se tudo estivesse num único arquivo Java?

3. **No arquivo `learn_jacamo.jcm`, o que significa `focus: w.c1`?** O que acontece se remover essa linha?

---

## Respostas de auto-verificação

| # | Pergunta (resumo) | Resposta do aluno (resumo) | Status | Feedback do tutor | Data |
|---|-------------------|---------------------------|--------|-------------------|------|
| 1 | Diferença Belief vs Intention; exemplo cotidiano | Belief = visão parcial do mundo; Desire = objetivos; Intention = Desire comprometido/ativo em execução. Destacou: agente pode ter muitos Desires mas poucas Intentions ativas | ⚠️ | Conceito correto e bem articulado; faltou fornecer exemplo cotidiano explícito para cada componente | 23/04/2026 |
| 2 | Por que separar em arquivos? O que se perde sem separação? | Separação de responsabilidades, independência de alteração/reuso, possibilidade de rodar em processos separados | ✅ | Completo — capturou os três benefícios principais | 23/04/2026 |
| 3 | O que é `focus: w.c1`? O que acontece sem ela? | O agente passa a reconhecer o artefato e ver suas propriedades | ⚠️ | Parcialmente correto — identificou percepção do artefato, mas não articulou que sem `focus` os percepts (ex: `count(N)`) não viram crenças no belief base, tornando planos dependentes de `count(N)` inoperantes | 23/04/2026 |

---

## Sintaxe AgentSpeak — referência rápida

### Crença inicial

```jason
modulo_atual(0).
//  ↑            ↑
//  nome(valor)  ponto final obrigatório
//  constantes/nomes = minúscula
//  valores = números, átomos (minúscula) ou estruturas
```

### Objetivo inicial

```jason
!start.
// "!" = goal (objetivo)
// disparado automaticamente ao criar o agente
```

### Anatomia de um plano

```
+  !  start  :  modulo_atual(Mod)  <-  ação1 ;  ação2 .
│  │  │      │  │                  │        │        │
│  │  nome   │  contexto guarda    │   sep. │     fim plano
│  goal      separador             corpo
gatilho (+adição)
```

| Símbolo | Papel | Quando usar |
|---|---|---|
| `+` no cabeçalho | Gatilho de adição de evento | Sempre em planos reativos |
| `!` | Marca que o evento é um goal | Goals usam `!`, crenças não |
| `:` | Separador de contexto | Divide cabeçalho do corpo |
| `true` | Contexto sem condição | Quando o plano sempre pode rodar |
| `crença(Var)` | Contexto com consulta | Lê e liga variável ao mesmo tempo |
| `<-` | Início do corpo do plano | Separa guarda das ações |
| `;` | Separador de ações | Entre cada ação (exceto a última) |
| `.` | Fim do plano | Na última ação do corpo |
| `+crença(...)` no corpo | Adiciona crença ao belief base | Memorizar algo persistente |

### Variáveis vs. constantes

```jason
modulo_atual(0).    // 0 = constante numérica
modulo_atual(abc).  // abc = constante átomo (minúscula)
modulo_atual(Mod).  // Mod = VARIÁVEL (maiúscula) — ligada ao valor ao consultar
```

---

## Erros comuns e correções

### ❌ Crença com variável não ligada

```jason
// ERRADO: variáveis não podem aparecer em crenças iniciais
M = 0.
modulo_atual(M).

// CERTO: fato concreto com valor literal
modulo_atual(0).
```

### ❌ Ponto antes do nome (ação interna)

```jason
// ERRADO: ".nome" = ação interna Jason (como .print, .date)
.modulo_atual(0).

// CERTO: crença inicial não tem ponto no início
modulo_atual(0).
```

### ❌ Conflito de variável

```jason
// ERRADO: M usada como módulo E como Mês em .date(Y,M,D)
+!start : modulo_atual(M) <- .date(Y,M,D).

// CERTO: nomes distintos para cada variável
+!start : modulo_atual(Mod) <- .date(Year,Mon,Day).
```

---

## Exercícios realizados

| Nível | Tarefa | Resultado | Data |
|---|---|---|---|
| intro | Declarar `modulo_atual(0)` e imprimir o valor via plano `+!start` | ✅ | 22/04/2026 |
| consolidação | BDI completo: `humor(mau→bom)` com gatilho de crença `+humor(bom)`, plano de fallback com `not` no contexto | ✅ Aprovado c/ ressalvas | 22/04/2026 |
| conceitual | Perguntas de auto-verificação BDI + dimensões + `focus` | ✅ Q1 e Q2 corretas; Q3 parcial (percept→crença não articulado) | 23/04/2026 |
