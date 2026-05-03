# Módulo 4 — Organização: Grupos, Papéis e Esquemas (Moise)

> **Tecnologia:** Moise
> **Arquivos:** `src/org/org.xml`, `learn_jacamo.jcm`
> **Pré-requisito:** Módulo 3 (CArtAgO)
> **Tempo estimado:** 2–3 sessões práticas

---

## Por que este módulo importa

Nos módulos anteriores, quando `alice` precisava de `bob`, ela chamava `.send(bob, ...)` — usando o **nome** diretamente. Isso funciona, mas cria acoplamento: se você renomear `bob`, `alice` quebra.

Moise resolve isso com uma camada de **organização**: alice e bob adotam **papéis**, e a coordenação acontece via papéis, não nomes. O código dos agentes não precisa saber quem é quem.

Além disso, quando você quer garantir que certas tarefas sejam feitas — independente de qual agente esteja disponível — a organização define **esquemas de objetivos** com obrigações e permissões.

---

## Conceitos fundamentais

### 1. As três especificações de Moise

O arquivo `org.xml` é dividido em três partes:

```
org.xml
├── structural-specification   → quem pode existir (grupos e papéis)
├── functional-specification   → o que deve ser feito (esquemas e missões)
└── normative-specification    → quem é obrigado/permitido a fazer o quê
```

### 2. Especificação estrutural

Define **grupos** e **papéis** dentro dos grupos:

```xml
<structural-specification>
  <group-specification id="group1">
    <roles>
      <role id="role1" min="1" max="1"/>
      <role id="role2" min="1" max="3"/>
    </roles>
    <links>
      <link from="role1" to="role2" type="authority"/>
    </links>
  </group-specification>
</structural-specification>
```

| Elemento | Significado |
|----------|-------------|
| `min/max` | Quantos agentes podem jogar este papel |
| `type="authority"` | role1 tem autoridade sobre role2 (pode enviar ordens) |
| `type="acquaintance"` | role1 conhece role2 (pode se comunicar) |
| `type="communication"` | Bidirecional |

### 3. Especificação funcional

Define **esquemas de objetivos** — sequências de objetivos que o grupo deve alcançar coletivamente:

```xml
<functional-specification>
  <scheme id="hello_sch">
    <goal id="hello">
      <plan operator="sequence">
        <goal id="greet"/>
        <goal id="confirm"/>
      </plan>
    </goal>
    <mission id="m_leader" min="1" max="1">
      <goal id="greet"/>
    </mission>
    <mission id="m_worker" min="1" max="3">
      <goal id="confirm"/>
    </mission>
  </scheme>
</functional-specification>
```

**Analogia:** um `scheme` é como um processo de negócio — define os passos e quem é responsável por cada um.

### 4. Especificação normativa

Define **obrigações** e **permissões**:

```xml
<normative-specification>
  <norm id="n_leader" type="obligation"
        role="role1" mission="m_leader"/>
  <norm id="n_worker" type="obligation"
        role="role2" mission="m_worker"/>
</normative-specification>
```

Quando um agente adota o papel `role1`, a norma `n_leader` cria uma **obrigação** para ele cumprir a missão `m_leader`.

### 5. O ciclo completo

```
Especificação (org.xml)
        ↓
Instância de grupo (g1: group1)   ← no .jcm
        ↓
Agentes adotam papéis (alice → role1, bob → role2)
        ↓
Instância de scheme (s1: hello_sch)
        ↓
Grupo é responsável pelo scheme
        ↓
Normas geram obrigações para os agentes
        ↓
Agentes com org-obedient.asl executam seus planos automaticamente
```

### 6. Crenças organizacionais

Quando alice adota o papel `role1`, ela recebe automaticamente estas crenças:

```prolog
play(alice, role1, g1)           % alice joga role1 no grupo g1
play(bob, role2, g1)             % bob joga role2 no grupo g1
obligation(alice, _, greet, _)   % alice tem obrigação de cumprir 'greet'
```

Alice pode consultar quem joga `role2` sem conhecer o nome:

```prolog
+!saudar
    <- .findall(Ag, play(Ag, role2, _), Lista);
       .print("Agentes com role2: ", Lista).
```

---

## Código anotado — `org.xml` do projeto

```xml
<!-- src/org/org.xml -->
<organisational-specification>

  <structural-specification>
    <!-- Um grupo chamado "group1" -->
    <group-specification id="group1">
      <roles>
        <!-- role1: exatamente 1 agente, obrigatório -->
        <role id="role1" min="1" max="1"/>
        <!-- role2: entre 1 e 3 agentes -->
        <role id="role2" min="1" max="3"/>
      </roles>
    </group-specification>
  </structural-specification>

  <functional-specification>
    <!-- Esquema de objetivos "hello_sch" -->
    <scheme id="hello_sch">
      <goal id="do_mission"/>
      <!-- Missão para quem tem role1 -->
      <mission id="m1" min="1" max="1">
        <goal id="do_mission"/>
      </mission>
    </scheme>
  </functional-specification>

  <normative-specification>
    <!-- role1 é obrigado a cumprir m1 -->
    <norm id="n1" type="obligation" role="role1" mission="m1"/>
  </normative-specification>

</organisational-specification>
```

---

## Código anotado — agente obediente

Para que o agente respeite automaticamente suas obrigações, inclua no `.asl`:

```prolog
// src/agt/sample_agent.asl

// Inclui o comportamento de "agente obediente à organização"
// Quando a organização criar uma obrigação, este include
// automaticamente cria a intenção de cumpri-la
{ include("$moise/asl/org-obedient.asl") }

// Seu plano para o objetivo que a organização vai obrigar
+!do_mission : true
    <- .print("Cumprindo minha missão organizacional!").
```

Sem o `org-obedient.asl`, o agente recebe a crença `obligation(...)` mas não faz nada com ela automaticamente — você teria que escrever um plano para reagir.

---

## Como inspecionar a organização

Com o projeto rodando (`./gradlew -q --console=plain`):

- `http://localhost:3271` → **Organisation Inspector**
  - Ver grupos instanciados e papéis adotados
  - Ver schemes em execução e estado dos goals
  - Ver obrigações ativas, cumpridas e violadas

- `http://localhost:3272` → **Mind Inspector** → selecione um agente
  - Procure crenças `play(...)` e `obligation(...)`

---

## Referências oficiais

- [Tutorial Hello World — Parte IV (organização)](http://jacamo-lang.github.io/jacamo/tutorials/hello-world/readme.html#part-iv-organisation)
- [Documentação Moise](http://moise.sourceforge.net/doc)
- [ORA4MAS — artefatos organizacionais](http://moise.sourceforge.net/doc/ora4mas)
- [Gramática do org.xml](http://moise.sourceforge.net/doc/os-spec-BNF.html)

---

## Antes de praticar — auto-verificação

Responda sem consultar antes:

1. Qual a diferença entre `structural-specification` e `functional-specification` no `org.xml`?
2. Se `role2` tem `min="2"` e só um agente adotou o papel, o que acontece com o scheme?
3. O que `{ include("$moise/asl/org-obedient.asl") }` faz que sem ele não aconteceria?

> Use `/aula 4` no chat para discutir as respostas com o tutor antes de ir para os exercícios.

---

## Respostas de auto-verificação (02/05/2026)

| # | Pergunta | Resposta do aluno | Status | Feedback |
|---|----------|-------------------|--------|----------|
| 1 | Diferença entre especificações estrutural, funcional e normativa | Estrutural define quem pode existir; funcional define o que precisa ser feito; normativa define quem deve fazer o quê e liga papel a missão. | ✅ Correto | Boa síntese das três camadas de Moise: estrutura social, processo coletivo e vínculo normativo. |
| 2 | O que faz a norma `norm1` | Define que o papel `role2` tem obrigação de cumprir `mission1`. | ✅ Correto | Exato: a norma associa um papel a uma missão por obrigação. |
| 3 | Como mandar mensagem para quem tem `role2` sem escrever `bob` | `play(bob, role2, g1)`. | ⚠️ Parcial | A crença está no caminho certo, mas para desacoplar de `bob` o plano deve consultar com variável, por exemplo `play(Ag, role2, _)`, e então usar `Ag`. |

---

## Exercício intro — registro de correção (02/05/2026)

**Arquivos avaliados:**
- `src/ex/mod4-ex1.jcm`
- `src/agt/alice_mod4.asl`
- `src/agt/bob_mod4.asl`

**Resultado:** ✅ Aprovado

### O que foi validado

- **Moise / `.jcm`:** o MAS `mod4_ex1` instancia a organização `o: org.xml`, cria o grupo `g1: group1` e atribui `alice role1` e `bob role2`.
- **Jason em Alice:** o plano `+!saudar_por_papel` consulta `play(Ag, role2, _)`, espera a crença organizacional existir e envia a saudação para a variável `Ag`.
- **Jason em Bob:** o plano `+saudacao(Texto)[source(Remetente)]` reage ao `tell` recebido e imprime a origem da mensagem.

### Saída confirmada

```text
[Moise] OrgBoard o created.
[Moise] group created: g1: group1 using artifact ora4mas.nopl.GroupBoard
[bob] focusing on artifact g1 (at workspace /main/o) using namespace default
[alice] focusing on artifact g1 (at workspace /main/o) using namespace default
[bob] focusing on artifact o (at workspace /main/o) using namespace default
[alice] focusing on artifact o (at workspace /main/o) using namespace default
[bob] recebi 'bom dia' de alice
```

### Rubrica

| Critério | Status | Observação |
|----------|--------|------------|
| Corretude lógica | ✅ | Alice descobre o destinatário por papel e Bob recebe a saudação. |
| Sintaxe | ✅ | `.jcm` e `.asl` executam corretamente. |
| Estrutura | ✅ | Separação clara entre configuração organizacional e planos dos agentes. |
| Idioms JaCaMo | ✅ | Uso correto de `play(Ag, role2, _)`, `.wait(...)`, `.send(...)` e `[source(Remetente)]`. |

**Próximo passo recomendado:** praticar uma consolidação com missão/obrigação, usando `org-obedient.asl` para conectar normas Moise a objetivos Jason.
