# Módulo 7 — Ferramentas: Debug, Testes e Boas Práticas

> **Tecnologia:** JaCaMo + Jason + ferramentas de debug
> **Arquivos:** `logging.properties`, `src/test/`
> **Pré-requisito:** Módulos 2–4 (para ter o que debugar)
> **Tempo estimado:** 1–2 sessões

---

## Por que este módulo importa

Um agente BDI pode falhar de formas silenciosas: o plano não é selecionado porque a guarda falhou, a crença nunca foi criada, o artefato não emitiu o sinal esperado. Sem as ferramentas certas, fica difícil distinguir "o agente não quer fazer" de "o agente não consegue fazer".

Este módulo ensina a usar os três inspetores de JaCaMo, configurar logging, escrever testes orientados a objetivos, e aplicar boas práticas que evitam os problemas mais comuns.

---

## Conceitos fundamentais

### 1. Os três inspetores — visão geral

Enquanto o projeto está rodando (`./gradlew -q --console=plain`):

| Inspector | URL | O que mostra |
|-----------|-----|-------------|
| Mind Inspector | `http://localhost:3272` | Estado mental de cada agente |
| Workspace Inspector | `http://localhost:3273` | Artefatos e propriedades observáveis |
| Organisation Inspector | `http://localhost:3271` | Grupos, papéis, obrigações |

### 2. Mind Inspector — diagnosticar um agente

Abra `http://localhost:3272` e clique em um agente. Você verá três seções:

**Beliefs (crenças):**
```
count(3)                      ← crença criada por percepção de artefato
started(2026,4,22,10,30,0)    ← crença criada pelo próprio agente
play(bob, role1, g1)          ← crença criada pela organização
```

**Goals (objetivos ativos):**
```
!start                        ← objetivo disparado pelo sistema
!processar(item1)             ← sub-objetivo criado por um plano
```

**Intentions (intenções em execução):**
```
Intention 1: !start → !processar(item1) → ...
  [em execução]
Intention 2: !monitorar
  [suspensa, aguardando percepção]
```

**Como usar para diagnóstico:**
- Plano não está sendo executado? Veja se o goal existe em *Goals*
- Goal existe mas plano não roda? O contexto (guarda) da regra está falhando — cheque as crenças relevantes
- Intenção suspensa há muito tempo? Provavelmente `.wait` aguardando algo que nunca chega

### 3. Workspace Inspector — diagnosticar artefatos

Abra `http://localhost:3273`. Para cada artefato você verá:

```
Artifact: c1 (example.Counter)
  Observable Properties:
    count = 3           ← valor atual da propriedade
  Operations:
    inc()
    inc_get(int, OpFeedbackParam)
```

**Como usar para diagnóstico:**
- Agente não percebeu mudança no artefato? Verifique se ele está com `focus` no workspace correto
- Operação foi chamada mas crença não atualizou? O agente pode não ter `focus` neste artefato

### 4. Organisation Inspector — diagnosticar organização

Abra `http://localhost:3271`. Você verá:

```
Group g1 (group1):
  alice → role1  ✓
  bob   → role2  ✓

Scheme s1 (hello_sch):
  do_mission: achieved ✓

Obligations:
  alice: cumprir m1 → SATISFIED
  bob:   cumprir m2 → PENDING (deadline: ...)
```

**Como usar para diagnóstico:**
- Scheme não avança? Algum goal não foi alcançado — veja qual está `pending`
- Obrigação `violated`? O agente não cumpriu no prazo — verifique o código e o deadline

### 5. Configurar logging detalhado

O arquivo `logging.properties` na raiz do projeto controla o nível de log:

```properties
# logging.properties

# Log padrão — INFO: só mensagens importantes
handlers = java.util.logging.ConsoleHandler
.level = INFO

# Log detalhado de Jason — FINE: mostra seleção de planos, ciclos de raciocínio
jason.level = FINE

# Log detalhado de CArtAgO — FINE: mostra operações e sinais
cartago.level = FINE

# Formato da mensagem
java.util.logging.ConsoleHandler.formatter = java.util.logging.SimpleFormatter
java.util.logging.SimpleFormatter.format = [%1$tT] %4$s %2$s: %5$s%n
```

Com `jason.level = FINE` você verá no console:
```
[10:30:01] FINE jason: Agent bob selected plan +!start for trigger +!start
[10:30:01] FINE jason: Agent bob: executing action .print("hello world.")
```

### 6. Testes orientados a objetivos

JaCaMo suporta testes onde um agente verifica se outro alcançou um objetivo. A estrutura de teste já existe no projeto:

```
src/test/
├── tests.jcm          ← projeto de teste separado
└── agt/
    └── test-sample.asl  ← agente de teste
```

**`src/test/tests.jcm`:**
```
mas tests {
    agent test_bob: test-sample.asl {
        focus: w.c1
    }
    workspace w {
        artifact c1: example.Counter(3)
    }
}
```

**`src/test/agt/test-sample.asl`:**
```prolog
// Testa se o Counter inicializou com o valor esperado
!test_counter_init.

+!test_counter_init
    <- ?count(V);                           // consulta o valor
       .assert(V == 3,
           "Counter deveria inicializar com 3").

// Testa se inc() incrementa corretamente
!test_counter_inc.

+!test_counter_inc
    <- ?count(Before);
       inc;                                 // opera o artefato
       .wait(50);                           // aguarda propagação da percepção
       ?count(After);
       .assert(After == Before + 1,
           "inc() deveria incrementar em 1").
```

**Executar os testes:**
```bash
./gradlew test
```

---

## Boas práticas

### Nomeie planos com labels

```prolog
// Ruim — sem nome, difícil de rastrear no Mind Inspector
+!processar(X) : condicao(X) <- acao(X).

// Bom — label descritivo facilita debug
@processar_quando_valido
+!processar(X) : condicao(X) <- acao(X).

@processar_fallback
+!processar(X) : not condicao(X) <- .print("Ignorando ", X).
```

### Evite hardcode de nomes de agentes

```prolog
// Ruim — acoplado ao nome "bob"
+!notificar <- .send(bob, tell, resultado(ok)).

// Bom — usa papel organizacional
+!notificar
    <- .findall(Ag, play(Ag, role_receptor, _), [Receptor|_]);
       .send(Receptor, tell, resultado(ok)).
```

### Trate falhas explicitamente

```prolog
// Sem tratamento — falha silenciosa
+!operacao_critica <- acao_que_pode_falhar.

// Com tratamento — plano de recuperação
+!operacao_critica <- acao_que_pode_falhar.
-!operacao_critica[error(Tipo), error_msg(Msg)]
    <- .print("Falha em operacao_critica: ", Tipo, " - ", Msg);
       !plano_de_recuperacao.
```

### Use `[source(self)]` para crenças internas

```prolog
// Crença que só você mesmo pode criar (não vem de percepção nem de outro agente)
+estado_interno(processando)[source(self)].

// Ao verificar, garante que veio de você mesmo
?estado_interno(X)[source(self)].
```

### Prefira artefatos para estado compartilhado

```prolog
// Ruim — agente A mantém estado que B precisa consultar via mensagem
// (acoplamento, atraso, risco de dessincronização)

// Bom — artefato compartilhado que ambos observam
// A e B fazem `focus` no mesmo artefato
// Mudanças são percebidas automaticamente por todos
```

---

## Referências oficiais

- [Debugging em JaCaMo](https://jacamo-lang.github.io/jacamo/debug.html)
- [Goal-Oriented TDD para JaCaMo](https://jacamo-lang.github.io/jacamo/tutorials/tdd/readme.html)
- [Padrões úteis em Jason](https://jason-lang.github.io/jason/tech/patterns.html)
- [Configuração de logging — Jason](https://jason-lang.github.io/jason/tech/faq.html)

---

## Antes de praticar — auto-verificação

Responda sem consultar antes:

1. Um agente tem o objetivo `!processar` nos *Goals* do Mind Inspector, mas nunca entra nos *Intentions*. O que isso indica?
2. Você chama `inc()` no Counter mas a crença `count(N)` do agente não atualiza. Qual ferramenta você usa para diagnosticar, e o que você procura?
3. O que o prefixo `-!objetivo[error(Tipo)]` significa em um plano Jason?

> Use `/aula 7` no chat para discutir as respostas com o tutor antes de ir para os exercícios.
