# Módulo 2 — Agentes: Beliefs, Goals e Plans (Jason/AgentSpeak)

> **Tecnologia:** Jason / AgentSpeak
> **Pré-requisito:** Módulos 0 e 1
> **Arquivo principal:** `src/agt/sample_agent.asl`
> **Tempo estimado:** 2–3 sessões práticas

---

## Por que este módulo importa

Este é o núcleo do JaCaMo. Sem entender como um agente Jason raciocina, você não consegue fazer nada útil com a plataforma.

Em Java ou Python, você escreve **como** o programa executa — passo a passo, imperativo. Em Jason, você descreve **o que o agente sabe** (crenças) e **o que quer alcançar** (objetivos), e a plataforma decide *quando* executar cada plano. O agente reage ao ambiente e a mensagens de outros agentes sem precisar de um loop de polling manual.

A sensação estranha no início é normal: você está trocando um paradigma imperativo por um paradigma **declarativo + reativo**. Depois de entender o ciclo de raciocínio, o código fica surpreendentemente limpo.

---

## Conceitos fundamentais

### 1. Beliefs (Crenças)

As crenças são o que o agente **sabe sobre o mundo**. São armazenadas no *belief base* — análogo a um banco de fatos Prolog.

```prolog
// Crenças iniciais (declaradas no topo do .asl)
feliz(bob).              ← fato: bob está feliz
idioma(pt).              ← fato: idioma é português
temperatura(22).         ← fato: temperatura é 22
amigo(alice).
amigo(carlos).
```

**Crenças com múltiplos argumentos:**
```prolog
localização(bob, sala_a).          ← bob está na sala_a
conectado(servidor1, servidor2).
```

**Crenças com fonte (anotação):**
```prolog
// Toda crença sabe de onde veio
temperatura(30)[source(sensor1)]   ← crença percebida do artefato sensor1
amigo(alice)[source(self)]         ← crença que o próprio agente estabeleceu
tarefa(limpar)[source(lider)]      ← crença enviada pelo agente "lider"
```

### 2. Goals (Objetivos)

Objetivos representam **estados que o agente quer alcançar**. Existem dois tipos:

| Tipo | Sintaxe | Significado |
|------|---------|-------------|
| Achievement goal | `!limpar_sala` | "faça acontecer" — executa um plano |
| Test goal | `?temperatura(T)` | "verifique" — busca nas crenças, falha se não achar |

**Objetivos iniciais** — declarados no topo do `.asl`, disparados ao criar o agente:
```prolog
!inicializar.       ← ao criar o agente, ele imediatamente tenta alcançar !inicializar
!saudar.
```

### 3. Plans (Planos)

Um plano define **como alcançar um objetivo** ou **como reagir a um evento**:

```prolog
+!evento : contexto
    <- ação1;
       ação2;
       ação3.
│       │         │
│       │         └─ corpo: sequência de ações separadas por ";"
│       └─ contexto (guarda): condição avaliada nas crenças; "true" = sempre
└─ cabeçalho: evento que dispara este plano
```

**Tipos de evento no cabeçalho:**

| Evento | Quando dispara |
|--------|----------------|
| `+!objetivo` | Nova tentativa de alcançar `objetivo` |
| `-!objetivo` | Falha ao tentar alcançar `objetivo` |
| `+crenca(X)` | Crença `crenca(X)` foi adicionada ao belief base |
| `-crenca(X)` | Crença `crenca(X)` foi removida do belief base |

### 4. O ciclo de raciocínio (simplificado)

```
1. Perceber eventos (mudança de crenças, mensagens, sinais de artefatos)
2. Selecionar o evento mais relevante
3. Buscar planos compatíveis com o evento E cujo contexto é verdadeiro nas crenças
4. Selecionar e executar o plano (vira uma Intention)
5. Voltar ao passo 1
```

**Chave:** o agente não executa um método quando chamado — ele *reage a eventos* e *persegue objetivos*.

---

## Ações internas úteis (prefixo `.`)

```prolog
.print("mensagem ", Variavel).         ← imprime no console
.send(Agente, tell, conteudo).         ← envia crença para outro agente
.send(Agente, achieve, !objetivo).     ← delega objetivo para outro agente
.broadcast(tell, conteudo).            ← envia para todos os agentes
.wait(1000).                           ← espera 1000ms
.my_name(Nome).                        ← variável Nome recebe o nome deste agente
.date(Ano, Mes, Dia).                  ← data atual
.time(H, Min, Seg, Ms).               ← hora atual
.findall(X, crenca(X), Lista).         ← coleta todos X que satisfazem crenca(X)
.length(Lista, N).                     ← N = tamanho da Lista
.nth(0, Lista, Primeiro).              ← Primeiro = elemento no índice 0
.concat("texto", Var, Resultado).      ← concatena strings
```

---

## Leitura do código real do projeto

```prolog
// Arquivo: src/agt/sample_agent.asl

// ── OBJETIVO INICIAL ────────────────────────────────────────────────
!start.                              ← ao criar o agente, dispara o objetivo !start

// ── PLANO ───────────────────────────────────────────────────────────
+!start : true                       ← plano para !start; contexto "true" = sempre executa
    <- .print("hello world.");       ← ação interna: imprime no console
       .date(Y,M,D); .time(H,Min,Sec,MilSec);  ← obtém data e hora
       +started(Y,M,D,H,Min,Sec).   ← ADICIONA crença "started" ao belief base
                                     ← (o "+" antes de started é uma ação de atualização)

// ── INCLUDES ─────────────────────────────────────────────────────────
{ include("$jacamo/templates/common-cartago.asl") }   ← ações padrão de CArtAgO
{ include("$jacamo/templates/common-moise.asl")  }    ← ações padrão de Moise
```

**Variáveis em Jason:** começam com maiúscula (`Y`, `M`, `D`, `Msg`). Átomos começam com minúscula (`bob`, `ok`, `start`).

---

## Exemplo: dois planos alternativos (seleção por contexto)

```prolog
// Arquivo: src/agt/sample_agent.asl (exemplo estendido)

confio_em(alice).           ← crença inicial

// Plano 1: específico — contexto mais restrito, tentado PRIMEIRO
+saudacao(M)[source(A)] : confio_em(A)[source(self)]
    <- .print("(confiável) Recebi '", M, "' de ", A).

// Plano 2: genérico — fallback quando Plano 1 falha
+saudacao(M)[source(A)]
    <- .print("(desconhecido) Ignorando mensagem de ", A).
```

Jason tenta os planos na **ordem em que aparecem no arquivo**. O primeiro cujo contexto for verdadeiro é executado. `[source(self)]` garante que só crenças que o próprio agente adicionou contam — não outra agente dizendo "confio_em(alice)".

---

## Tabela de referência rápida

| Conceito | Sintaxe | Significado |
|----------|---------|-------------|
| Nova crença | `+crenca(X)` | Evento: crença foi adicionada |
| Crença removida | `-crenca(X)` | Evento: crença foi removida |
| Novo objetivo | `+!objetivo` | Evento: objetivo adicionado |
| Falha de objetivo | `-!objetivo` | Evento: objetivo falhou |
| Consulta test goal | `?crenca(X)` | Busca X nas crenças; falha se não achar |
| Variável | `X`, `Msg` | Começa com maiúscula — unificada |
| Átomo | `alice`, `ok` | Começa com minúscula — constante |
| Adicionar crença | `+crenca(X).` | Ação no corpo do plano |
| Remover crença | `-crenca(X).` | Ação no corpo do plano |
| Atualizar crença | `-+crenca(X).` | Remove + adiciona em um passo |

---

## Referências oficiais

- [Tutorial BDI Hello World (Jason)](https://jason-lang.github.io/jason/tutorials/hello-bdi/readme.html)
- [API de ações internas (.print, .send, etc.)](http://jason-lang.github.io/api/jason/stdlib/package-summary.html)
- [Manual AgentSpeak(L) — sintaxe completa](https://jason-lang.github.io/jason/jasonDoc.html)
- [Tutorial Hello World JaCaMo — Parte II (agentes)](http://jacamo-lang.github.io/jacamo/tutorials/hello-world/readme.html#part-ii-agents)

---

## Antes de praticar — perguntas de auto-verificação

1. **O que é o "contexto" (guarda) de um plano?** O que acontece se o contexto for falso quando o evento ocorre?

2. **Leia este plano e descreva o que ele faz:**
   ```prolog
   +temperatura(T) : T > 30
       <- .print("Atenção: temperatura alta! ", T, " graus");
          +alerta_ativo.
   ```
   Quando este plano dispara? O que `T` representa? O que `+alerta_ativo` faz?

3. **Como você faria um agente imprimir "Bom dia!" apenas se a crença `dia_da_semana(segunda)` existir no belief base?** Esboce o plano.
