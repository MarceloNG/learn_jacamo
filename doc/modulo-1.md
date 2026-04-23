# Módulo 1 — O Projeto: estrutura e primeiros passos

> **Tecnologia:** JaCaMo (.jcm)
> **Pré-requisito:** Módulo 0
> **Tempo estimado:** 1 sessão prática

---

## Por que este módulo importa

Todo sistema JaCaMo começa com um arquivo `.jcm`. Sem entender esse arquivo, você não consegue nem executar o projeto, muito menos adicionar agentes, artefatos ou organização.

O `.jcm` é o **ponto de entrada declarativo** do MAS — análogo ao `docker-compose.yml` de uma aplicação em containers, ou ao `pom.xml` de um projeto Maven. Ele não implementa nada; ele **descreve o estado inicial** do sistema: quais agentes existem, em qual ambiente eles vivem, e em qual organização participam.

Dominar o `.jcm` significa conseguir montar e desmontar cenários de teste com facilidade, sem mexer no código dos agentes.

---

## Conceitos fundamentais

### 1. Estrutura do arquivo `.jcm`

Um arquivo `.jcm` tem três blocos opcionais dentro do bloco `mas`:

```
mas <nome-do-sistema> {

    agent <nome>: <arquivo.asl> {    ← BLOCO DE AGENTE
        // configurações do agente
    }

    workspace <nome> {               ← BLOCO DE AMBIENTE
        // artefatos
    }

    organisation <nome>: <arquivo.xml> {   ← BLOCO DE ORGANIZAÇÃO
        // instâncias de grupos e schemes
    }
}
```

Todos os três blocos são **opcionais** — você pode ter um MAS com apenas agentes, sem ambiente nem organização.

### 2. Configurações do agente no `.jcm`

```
agent bob: sample_agent.asl {
    focus: w.c1              ← bob percebe o artefato c1 no workspace w
    roles: role1 in g1       ← bob joga role1 no grupo g1
    join: w                  ← bob entra no workspace w (implícito se focus está definido)
    beliefs: amigo(alice)    ← crenças iniciais adicionais (além das do .asl)
    goals:   !saudar         ← objetivos iniciais adicionais
}
```

**Múltiplos agentes do mesmo tipo:**
```
agent alice: worker.asl
agent bob:   worker.asl    ← alice e bob usam o mesmo .asl, mas são instâncias independentes
agent carlos: worker.asl
```

Cada instância tem seu próprio belief base, suas próprias intenções. O arquivo `.asl` define o *tipo*, não a instância.

### 3. Workspace e artefatos

```
workspace w {
    artifact c1: example.Counter(3)            ← artefato com construtor (valor inicial 3)
    artifact placar: example.Placar() {
        focused-by: alice, bob                 ← esses agentes percebem o artefato ao iniciar
    }
}
```

O `workspace` é o **espaço de trabalho compartilhado**. Artefatos dentro dele são acessíveis a qualquer agente que entre no workspace.

### 4. Organização

```
organisation o: org.xml {
    group g1: group1 {                         ← instância g1 do tipo de grupo group1
        players: alice role1                   ← alice joga role1
                 bob   role2                   ← bob joga role2
    }
    scheme s1: hello_sch                       ← instância s1 do tipo de scheme hello_sch
}
```

`org.xml` define os *tipos* (group1, hello_sch). O `.jcm` cria *instâncias* (g1, s1) e atribui agentes a papéis.

---

## Leitura do código real do projeto

```
// Arquivo: learn_jacamo.jcm

mas learn_jacamo {                        ← nome do MAS

    agent bob: sample_agent.asl {         ← agente "bob", comportamento em sample_agent.asl
      focus: w.c1                         ← bob percebe o artefato c1 que está em w
    }

    workspace w {                         ← workspace chamado "w"
      artifact c1: example.Counter(3)     ← artefato c1 do tipo Counter, iniciando em 3
    }                                     ← Counter está em src/env/example/Counter.java

    organisation o: org.xml {            ← organização "o", especificada em org.xml
      group g1 : group1 {               ← instância g1 do tipo group1 definido em org.xml
        players: bob role1              ← bob adota o papel "role1" em g1
      }
    }
}
```

**Experimento:** remova o bloco `workspace` e o `focus` e execute. O que muda no comportamento de bob?

---

## Estrutura de arquivos do projeto

```
learn_jacamo/
├── learn_jacamo.jcm          ← ponto de entrada (este módulo)
├── src/
│   ├── agt/
│   │   └── sample_agent.asl  ← código do agente bob (Módulo 2)
│   ├── env/
│   │   └── example/
│   │       └── Counter.java  ← artefato de ambiente (Módulo 3)
│   └── org/
│       └── org.xml           ← especificação organizacional (Módulo 4)
├── build.gradle              ← dependências (jacamo 1.3.0)
└── gradlew                   ← executar com: ./gradlew -q --console=plain
```

### Executar o projeto

```bash
./gradlew -q --console=plain
```

Saída esperada:
```
[Cartago] Workspace w created.
[Cartago] artifact c1: example.Counter(3) at w created.
[bob] join workspace /main/w: done
[bob] hello world.
```

### Inspecionar em tempo real (enquanto o MAS está rodando)

| URL | O que mostra |
|-----|-------------|
| `http://localhost:3272` | Mind Inspector — crenças, objetivos e intenções de cada agente |
| `http://localhost:3273` | Workspace Inspector — artefatos e suas propriedades |
| `http://localhost:3271` | Organisation Inspector — grupos, papéis e schemes |

---

## Referências oficiais

- [Referência completa do arquivo .jcm](https://jacamo-lang.github.io/jacamo/jcm.html)
- [Tutorial Hello World — Parte I (setup)](http://jacamo-lang.github.io/jacamo/tutorials/hello-world/readme.html)
- [Getting Started JaCaMo](https://jacamo-lang.github.io/getting-started)

---

## Antes de praticar — perguntas de auto-verificação

1. **No `.jcm`, qual é a diferença entre `agent alice: worker.asl` e `agent bob: worker.asl`?** São o mesmo agente ou agentes diferentes? Compartilham crenças?

2. **O que acontece se você remover o bloco `organisation` do `.jcm`?** O MAS ainda roda? Bob ainda funciona?

3. **O que significa `artifact c1: example.Counter(3)` — o que é `example.Counter` e o que significa o `3`?**

---

## Respostas de auto-verificação — 23/04/2026

| # | Pergunta | Resposta do aluno | Status | Feedback |
|---|----------|-------------------|--------|----------|
| Q1 | `alice` e `bob` com mesmo `.asl` compartilham beliefs? | Não — são instâncias independentes com beliefs e intenções próprias | ✅ | Correto. O `.asl` define o tipo; cada declaração cria um objeto distinto com seu próprio belief base. |
| Q2 | O que muda sem `focus: w.c1`? | Bob perde acesso às propriedades do Counter e não consegue reagir a alterações | ✅ | Correto. Sem `focus`, os percepts de `c1` nunca viram crenças — o agente literalmente não sabe que o artefato existe. |
| Q3 | Como declarar `alice` com crença inicial `papel(supervisora)`? | `agent alice: sample_agent.asl { beliefs: papel(supervisora) }` | ✅ | Sintaxe exata e idiomática. Múltiplas crenças podem ser separadas por vírgula: `beliefs: papel(supervisora), turno(manha)`. |

**Resultado: 3/3 ✅ — Aula concluída. Pronto para exercícios do Módulo 1.**

---

## Exercício intro — 23/04/2026

**Enunciado:** Declarar segundo artefato `c2: example.Counter(10)` no workspace e configurar `focus: w.c2` para alice, de modo que bob e alice monitorem artefatos distintos.

**Arquivo:** `src/ex/mod1-ex2.jcm`

**Resultado:** ✅ Aprovado

| Critério         | Nota | Observação |
|------------------|------|------------|
| Corretude lógica | ✅   | bob percebeu `count(3)`, alice percebeu `count(10)` — cada agente no seu artefato |
| Sintaxe          | ✅   | `artifact c2: example.Counter(10)` e `focus: w.c2` corretos |
| Estrutura        | ✅   | Blocos `workspace` e `agent` organizados de forma clara |
| Idioms JaCaMo    | ✅   | Sintaxe `.jcm` idiomática em todos os pontos |

**Descoberta bônus:** identificou que `+!monitorar_contador` em `sample_agent.asl` chamava `inc` incondicionalmente, causando comportamento inesperado quando o artefato começa em valor ≥ 6. Corrigiu com `if (N < 6) { inc }` — uso correto do controle de fluxo dentro do corpo de plano AgentSpeak.
