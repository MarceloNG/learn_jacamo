# Módulo 3 — Ambiente: Artefatos e Workspaces (CArtAgO)

> **Tecnologia:** CArtAgO
> **Pré-requisito:** Módulos 0–2
> **Arquivo principal:** `src/env/example/Counter.java`
> **Tempo estimado:** 2 sessões práticas

---

## Por que este módulo importa

Em Jason puro, agentes se comunicam apenas por troca de mensagens. Isso funciona para coordenação simples, mas quebra quando você precisa de **estado compartilhado** — um contador que múltiplos agentes incrementam, uma fila de tarefas, um placar, um sensor.

CArtAgO resolve isso com o conceito de **artefato**: um objeto de ambiente que os agentes podem *perceber* e *usar*. A diferença crucial em relação a um objeto Java comum é que o artefato:
- **Notifica automaticamente** os agentes quando seu estado muda (propriedades observáveis → crenças)
- **Serializa operações** — evita condições de corrida sem que o agente precise saber disso
- **Encapsula o protocolo** — muda o artefato, não os agentes

---

## Conceitos fundamentais

### 1. Artefato (Artifact)

Um artefato é uma classe Java que estende `Artifact`. Ele expõe:

| Elemento | Como definir | Como o agente vê |
|----------|-------------|-----------------|
| Propriedade observável | `defineObsProperty("nome", valor)` | Crença automática: `nome(valor)` |
| Operação | Método com `@OPERATION` | Ação no plano do agente |
| Sinal | `signal("nomeSinal")` | Evento: `+nomeSinal[artifact_id(Id)]` |

### 2. Propriedades observáveis → crenças automáticas

Quando um agente está **focando** (`focus`) em um artefato, cada propriedade observável do artefato vira uma crença automática no belief base do agente. Quando a propriedade muda, a crença é atualizada — sem que o agente precise fazer nada.

```
Counter com count=3
  ↓ (agente foca no artefato)
Crença automática: count(3)

Counter.inc() é chamado → count vira 4
  ↓ (CArtAgO notifica os agentes)
Crença atualizada: count(4)
  ↓ (Jason dispara o evento)
Plano +count(4) é executado (se existir)
```

### 3. Executando operações nos agentes

No `.asl`, uma operação de artefato é simplesmente **uma ação no corpo do plano**:

```prolog
+!incrementar
    <- inc.                          ← operação simples, sem retorno
       inc_get(5, NovoValor);        ← operação com parâmetro de entrada e retorno
       .print("Novo valor: ", NovoValor).
```

Se houver múltiplos artefatos com a mesma operação, especifique qual:
```prolog
inc[artifact_name(c1)].     ← executa inc no artefato chamado "c1"
```

### 4. Parâmetro de retorno (OpFeedbackParam)

Como Java não suporta múltiplos retornos nativamente, CArtAgO usa `OpFeedbackParam<T>`:

```java
@OPERATION
void inc_get(int delta, OpFeedbackParam<Integer> result) {
    // ...
    result.set(novoValor);   ← define o valor que o agente vai receber
}
```

No agente:
```prolog
inc_get(5, NovoValor).   ← NovoValor é ligado ao valor definido por result.set()
```

### 5. Workspace

O workspace é o **espaço compartilhado** onde artefatos vivem. Um agente só pode usar artefatos do workspace em que está. No `.jcm`:

```
workspace w {
    artifact c1: example.Counter(3)   ← artefato "c1", tipo Counter, init=3
}

agent bob: bob.asl {
    focus: w.c1    ← bob entra em w e foca em c1
}
```

---

## Leitura do código real do projeto

```java
// Arquivo: src/env/example/Counter.java

package example;
import cartago.*;

public class Counter extends Artifact {

    // ── INICIALIZAÇÃO ─────────────────────────────────────────────────
    void init(int initialValue) {
        // define propriedade observável "count" com valor inicial
        // todo agente que foca neste artefato terá crença count(initialValue)
        defineObsProperty("count", initialValue);
    }

    // ── OPERAÇÃO 1: incremento simples ────────────────────────────────
    @OPERATION                              ← torna este método acessível para agentes
    void inc() {
        ObsProperty prop = getObsProperty("count");   ← acessa a propriedade
        prop.updateValue(prop.intValue() + 1);         ← atualiza o valor
        signal("tick");                                ← emite sinal para agentes focando
    }

    // ── OPERAÇÃO 2: incremento com retorno ────────────────────────────
    @OPERATION
    void inc_get(int inc, OpFeedbackParam<Integer> newValueArg) {
        ObsProperty prop = getObsProperty("count");
        int newValue = prop.intValue() + inc;
        prop.updateValue(newValue);
        newValueArg.set(newValue);    ← retorna o novo valor para o agente
    }
}
```

**O que observar no Workspace Inspector (`http://localhost:3273`):**
- O artefato `c1` e sua propriedade `count` com o valor atual
- Quais agentes estão focando no artefato

---

## Reagindo a sinais no agente

```prolog
// O sinal "tick" emitido por Counter.inc() dispara este plano

+tick[artifact_id(AId)]           ← evento: sinal "tick" do artefato com id AId
    <- ?count(V);                 ← consulta o valor atual da crença count
       .print("Tick! Contador agora em: ", V).
```

---

## Criando artefatos em tempo de execução

Além de declarar artefatos no `.jcm`, o agente pode criar artefatos dinamicamente:

```prolog
+!criar_placar
    <- makeArtifact("placar", "example.Placar", [], Id);   ← cria o artefato
       focus(Id).                                           ← começa a percebê-lo
```

---

## Referências oficiais

- [CArtAgO by Examples (PDF)](https://github.com/CArtAgO-lang/cartago/blob/master/docs/cartago_by_examples/cartago_by_examples.pdf)
- [Tutorial Hello World JaCaMo — Parte III (ambiente)](http://jacamo-lang.github.io/jacamo/tutorials/hello-world/readme.html#part-iii-environment)
- [API CArtAgO (JavaDoc)](https://github.com/CArtAgO-lang/cartago/tree/master/docs)

---

## Antes de praticar — perguntas de auto-verificação

1. **O que é uma "propriedade observável"?** Como ela se transforma em crença no agente? O que acontece quando ela muda?

2. **Leia este trecho do `Counter.java`:**
   ```java
   prop.updateValue(prop.intValue() + 1);
   signal("tick");
   ```
   O que `updateValue` faz para os agentes que estão focando? O que `signal("tick")` faz de diferente de `updateValue`?

3. **No agente, qual é a diferença entre `inc.` e `inc_get(1, V).`?** Quando você usaria cada um?
