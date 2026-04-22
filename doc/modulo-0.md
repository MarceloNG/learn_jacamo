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
