# Módulo 5 — Coordenação: As Três Dimensões

> **Tecnologia:** Jason + CArtAgO + Moise (integração)
> **Pré-requisito:** Módulos 2, 3 e 4
> **Tempo estimado:** 3+ sessões práticas

---

## Por que este módulo importa

Este é o ponto central de JaCaMo. Os módulos anteriores ensinaram cada dimensão separadamente. Agora você vai ver o mesmo problema resolvido de **três formas diferentes** — e entender os trade-offs reais de cada escolha.

A pergunta que este módulo responde é: **quando usar mensagens, quando usar artefatos, e quando usar a organização?** A resposta depende de requisitos como acoplamento, auditabilidade, abertura do sistema e facilidade de manutenção.

---

## Conceitos fundamentais

### O problema de coordenação

Sempre que dois ou mais agentes precisam **sincronizar** — um esperar o outro, um depender do resultado de outro — você tem um problema de coordenação. JaCaMo oferece três mecanismos:

| Mecanismo | Onde vive | Analogia |
|-----------|-----------|----------|
| Troca de mensagens | Na mente dos agentes | Email entre pessoas |
| Artefatos compartilhados | No ambiente (CArtAgO) | Quadro branco na sala |
| Normas organizacionais | Na organização (Moise) | Regimento interno da empresa |

### Abordagem 1 — Coordenação por mensagens (agente-centrada)

O coordenador conhece os participantes e envia mensagens diretamente:

```prolog
// auctioneer.asl
+!iniciar_leilao
    <- .broadcast(tell, leilao(produto, 100));
       .wait(4000);                    % espera 4 segundos por lances
       !selecionar_vencedor.

+lance(Ag, Valor)[source(Ag)]          % recebe lance de Ag
    <- +oferta(Ag, Valor).

+!selecionar_vencedor
    <- .findall(V-A, oferta(A,V), L);
       .max(L, MaxV-Vencedor);
       .print("Vencedor: ", Vencedor, " com ", MaxV).
```

**Vantagem:** simples de implementar.
**Problema:** o leiloeiro precisa saber quantos participantes existem — se mudar o número, o `.wait(4000)` pode terminar cedo demais ou tarde demais. Acoplamento temporal.

### Abordagem 2 — Coordenação por artefato (ambiente-centrada)

O artefato encapsula o protocolo do leilão:

```java
// AuctionArtifact.java
public class AuctionArtifact extends Artifact {
    void init() {
        defineObsProperty("winner", "none");
        defineObsProperty("status", "waiting");
    }

    @OPERATION
    void start(String item, int minBid) {
        getObsProperty("status").updateValue("open");
        signal("auction_started", item, minBid);
    }

    @OPERATION
    void bid(String bidder, int value) {
        // lógica interna de seleção do maior lance
        ObsProperty w = getObsProperty("winner");
        // ... atualiza winner se valor for maior
    }

    @OPERATION
    void close() {
        getObsProperty("status").updateValue("closed");
        signal("auction_closed", getObsProperty("winner").getValue());
    }
}
```

```prolog
// participant.asl — percebe o leilão e faz lance
+auction_started(Item, Min)[artifact_id(AId)]
    <- .random(R); Lance is Min + (R * 50);
       bid(bidder_name, Lance)[artifact_id(AId)].
```

**Vantagem:** mudar o protocolo = mudar o artefato, os agentes não mudam.
**Vantagem:** o artefato serve como "memória" auditável — estado sempre visível no Workspace Inspector.

### Abordagem 3 — Coordenação por organização (norma-centrada)

A organização define *quem deve fazer o quê* e *quando*:

```xml
<!-- org.xml para o leilão -->
<scheme id="auction_sch">
  <goal id="run_auction">
    <plan operator="sequence">
      <goal id="start_auction"/>    <!-- feito pelo auctioneer -->
      <goal id="collect_bids"/>     <!-- feito pelos participants -->
      <goal id="announce_winner"/>  <!-- feito pelo auctioneer -->
    </plan>
  </goal>
  <mission id="m_auctioneer" min="1" max="1">
    <goal id="start_auction"/>
    <goal id="announce_winner"/>
  </mission>
  <mission id="m_participant" min="1" max="5">
    <goal id="collect_bids"/>
  </mission>
</scheme>
```

**Vantagem:** declarativo — você descreve *o que* deve acontecer, não *como*.
**Vantagem:** a organização pode verificar se obrigações foram cumpridas, criar sanções, etc.
**Custo:** mais complexo de especificar.

### Comparação dos trade-offs

| Critério | Mensagens | Artefato | Organização |
|----------|-----------|----------|-------------|
| Acoplamento entre agentes | Alto | Baixo | Muito baixo |
| Facilidade de implementar | Alta | Média | Baixa |
| Auditabilidade | Baixa | Média | Alta |
| Sistema aberto (agentes entram/saem) | Difícil | Médio | Fácil |
| Mudar o protocolo | Modifica agentes | Modifica artefato | Modifica org.xml |
| Garantia de cumprimento | Nenhuma | Parcial | Total (normas) |

---

## Código anotado — leilão por mensagem (versão simplificada)

```prolog
// src/agt/leiloeiro.asl

!iniciar.

+!iniciar
    <- .broadcast(tell, leilao(quadro, 50));  // avisa todos
       collect_bids(3, []).                    // coleta 3 lances

+!collect_bids(0, Lances)                     // base: recebeu todos
    <- .max(Lances, Vencedor-Valor);
       .broadcast(tell, vencedor(Vencedor, Valor)).

+!collect_bids(N, Acc)                        // recursão: espera próximo lance
    <- .wait(lance(Ag, V), 5000, _);          // timeout de 5s
       N1 is N - 1;
       !collect_bids(N1, [Ag-V|Acc]).

// participante.asl
+leilao(Item, Min)[source(Leiloeiro)]
    <- .random(R);
       Lance is Min + round(R * 100);
       .send(Leiloeiro, tell, lance(my_name, Lance)).
```

---

## Referências oficiais

- [Tutorial de Coordenação — 3 dimensões](http://jacamo-lang.github.io/jacamo/tutorials/coordination/readme.html)
- [Patterns em Jason (mensagens)](https://jason-lang.github.io/jason/tech/patterns.html)
- [Exemplos Auction no repositório JaCaMo](https://github.com/jacamo-lang/jacamo/tree/main/examples/auction)

---

## Antes de praticar — auto-verificação

Responda sem consultar antes:

1. Em um sistema onde participantes podem entrar e sair a qualquer momento (sistema aberto), qual abordagem de coordenação é mais robusta? Por quê?
2. Se o protocolo do leilão mudar (ex: agora precisa de dois rounds), em qual abordagem você toca menos código?
3. Qual abordagem permite verificar, após o leilão, se todos os participantes realmente enviaram um lance?

> Use `/aula 5` no chat para discutir as respostas com o tutor antes de ir para os exercícios.
