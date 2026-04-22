# Módulo 6 — Exemplo Avançado: Gold Miners

> **Tecnologia:** Jason + CArtAgO (integração com BDI avançado)
> **Pré-requisito:** Módulos 2, 3 e 5
> **Tempo estimado:** 2–4 sessões

---

## Por que este módulo importa

Gold Miners é o exemplo clássico para consolidar BDI avançado em situação real. Em vez de "hello world", você trabalha com agentes que:

- **Exploram** um grid de forma autônoma
- **Reagem** a percepções do ambiente (ouro encontrado)
- **Gerenciam intenções concorrentes** (ir buscar ouro vs. continuar explorando)
- **Comunicam** resultados ao líder

É o primeiro exemplo onde a **gestão de intenções** (`!goal`, `.drop_desire`, `.desire`) faz diferença real — sem ela, o agente fica preso tentando fazer duas coisas ao mesmo tempo.

---

## Conceitos fundamentais

### 1. Agentes reativos vs. pró-ativos

Em Gold Miners, o minerador é **os dois ao mesmo tempo**:

```
Pró-ativo:  tem o goal !explorar — vai explorando o grid indefinidamente
Reativo:    quando percebe ouro, REAGE e vai buscar — mesmo que estivesse explorando
```

```prolog
// Pró-ativo: goal disparado no início
!explorar.

+!explorar
    <- move_towards(random_position);
       !explorar.     // recursão = loop de exploração

// Reativo: percepção de ouro interrompe a exploração
+gold(X, Y)           // evento: percebeu ouro em (X,Y)
    <- !pegar_ouro(X, Y).

+!pegar_ouro(X, Y)
    <- move_towards(X, Y);
       pick_up;
       move_towards(deposit);
       drop.
```

**Problema:** se o agente já está executando `!explorar` e percebe ouro, o que acontece? Ele vai criar **duas intenções em paralelo** — e pode tentar ir em duas direções ao mesmo tempo.

### 2. Gestão de intenções — `.drop_desire` e `.desire`

A solução é explicitamente gerenciar o que o agente está tentando fazer:

```prolog
// Ao perceber ouro, abandona a exploração e vai pegar
+gold(X, Y)
    <- .drop_desire(explorar);        // cancela a intenção de explorar
       !pegar_ouro(X, Y).

+!pegar_ouro(X, Y)
    <- move_towards(X, Y);
       pick_up;
       move_towards(deposit);
       drop;
       !explorar.                     // retoma a exploração depois
```

**Verificar se já tem uma intenção:**
```prolog
+gold(X, Y) : .desire(pegar_ouro(_, _))    // se JÁ está pegando ouro
    <- true.                                // ignora — já está indo buscar

+gold(X, Y) : not .desire(pegar_ouro(_, _))  // se NÃO está pegando ouro
    <- .drop_desire(explorar);
       !pegar_ouro(X, Y).
```

### 3. Crença com atualização (`-+`)

Acumular a pontuação exige atualizar uma crença existente:

```prolog
// ERRADO: cria múltiplas crenças score(1), score(2), score(3)...
+!registrar_ponto
    <- +score(1).

// CERTO: remove a antiga e adiciona a nova (operador -+)
+!registrar_ponto
    <- ?score(S);               // consulta valor atual
       NS is S + 1;
       -+score(NS).             // remove score(S) e adiciona score(NS)

// Inicializar com valor padrão se não existir
+!registrar_ponto
    <- ( score(S) -> true ; S = 0 );   // se existe usa S, senão usa 0
       NS is S + 1;
       -+score(NS).
```

### 4. Comunicação com o líder

```prolog
// minerador.asl — envia pontuação ao terminar
+!relatar_resultado
    <- ?score(S);
       .send(lider, tell, pontuacao(meu_nome, S)).

// lider.asl — recebe e compara pontuações
+pontuacao(Ag, Valor)[source(Ag)]
    <- +resultado(Ag, Valor);
       !verificar_fim.

+!verificar_fim
    <- .findall(V, resultado(_, V), Lista);
       .length(Lista, N);
       ( N >= 3 ->                         // se recebeu de todos os 3 mineradores
           !anunciar_vencedor
       ;
           true                            // ainda aguardando
       ).

+!anunciar_vencedor
    <- .findall(V-A, resultado(A, V), Lista);
       .max(Lista, _-Vencedor);
       .broadcast(tell, vencedor(Vencedor)).
```

---

## Código anotado — estrutura do projeto Gold Miners

```
gold-miners/
├── gold-miners.jcm          ← define 3 mineradores + 1 líder + ambiente
├── src/
│   ├── agt/
│   │   ├── miner.asl        ← comportamento do minerador (BDI)
│   │   └── leader.asl       ← coleta pontuações e anuncia vencedor
│   └── env/
│       └── GoldModel.java   ← artefato: grid, posições do ouro, operações
```

O artefato `GoldModel` expõe:
- **Propriedades observáveis:** `gold(X,Y)` quando há ouro em (X,Y)
- **Operações:** `move(dir)`, `pick_up()`, `drop()`
- **Sinais:** `step` — indica que o agente se moveu

---

## Progressão dos exercícios

O tutorial oficial progride assim — cada exercício adiciona um conceito:

| Exercício | O que adicionar | Conceito praticado |
|-----------|-----------------|-------------------|
| a | `.print` da posição alvo | Leitura de argumentos do evento |
| b | Planos alternativos com motivos diferentes | Contexto de guarda |
| c | Contar ouro depositado | `-+score(NS)` — atualização de crença |
| d | Localização dinâmica do depósito | Consulta ao belief base no contexto |
| e | Enviar pontuação ao líder | `.send` — comunicação inter-agente |
| f | Líder anuncia o vencedor | `.findall`, `.max`, comparação |
| g | Broadcast do vencedor | `.broadcast` |
| h | Minerador se vangloria ao ganhar | Reação a mensagem recebida |
| i | Pegar ouro no caminho para o depósito | `.desire`, `.drop_desire` — gestão de intenções |

---

## Como obter o projeto

```bash
# Baixar o exemplo inicial
wget https://jacamo.sourceforge.net/tutorial/gold-miners/initial-gold-miners.zip
unzip initial-gold-miners.zip
cd initial-gold-miners
./gradlew -q --console=plain
```

---

## Referências oficiais

- [Tutorial Gold Miners completo](https://jacamo-lang.github.io/jacamo/tutorials/gold-miners/readme.html)
- [Jason stdlib — `.desire`, `.drop_desire`](http://jason-lang.github.io/api/jason/stdlib/package-summary.html)
- [Padrões BDI avançados](https://jason-lang.github.io/jason/tech/patterns.html)

---

## Antes de praticar — auto-verificação

Responda sem consultar antes:

1. O que acontece se um minerador percebe ouro mas já está executando `!pegar_ouro`? Como evitar duas intenções concorrentes conflitantes?
2. Por que usar `-+score(NS)` em vez de apenas `+score(NS)` para atualizar a pontuação?
3. No exercício (f), como o líder sabe que já recebeu a pontuação de **todos** os mineradores?

> Use `/aula 6` no chat para discutir as respostas com o tutor antes de ir para os exercícios.
