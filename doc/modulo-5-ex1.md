# Exercício — Módulo 5: Coordenação: As Três Dimensões | Nível: intro

## Contexto

Você acabou de consolidar as três dimensões separadas: mensagens Jason, artefatos CArtAgO e organização Moise. Agora o objetivo é comparar essas escolhas em um caso mínimo, sem ainda implementar um leilão completo.

Neste exercício, você vai criar duas versões pequenas do mesmo fluxo: um agente `coordenador` pede uma confirmação de tarefa para um agente `executor`. Primeiro por mensagem direta; depois por artefato compartilhado. A comparação é o ponto central: onde ficou a coordenação em cada versão?

## O que fazer

1. Crie um MAS `mod5_ex1_msg` em `src/ex/mod5-ex1-msg.jcm`.
2. Crie dois agentes Jason:
   - `src/agt/coordenador_msg_mod5.asl`
   - `src/agt/executor_msg_mod5.asl`
3. Na versão por mensagem:
   - `coordenador` deve enviar uma tarefa diretamente para `executor` usando `.send(executor, tell, tarefa(...))`.
   - `executor` deve receber `+tarefa(T)[source(Coordenador)]`, imprimir que executou, e responder com `.send(Coordenador, tell, concluida(T))`.
   - `coordenador` deve reagir a `+concluida(T)[source(executor)]` e imprimir confirmação.
4. Crie um MAS `mod5_ex1_art` em `src/ex/mod5-ex1-art.jcm`.
5. Crie um artefato CArtAgO `src/env/example/TarefaBoard.java`.
6. Na versão por artefato:
   - o artefato deve ter uma propriedade observável `status`, iniciando como `"pendente"`;
   - o artefato deve ter uma operação `concluir()` que muda `status` para `"concluida"`;
   - um agente `executor_art_mod5.asl` deve chamar `concluir`;
   - um agente `coordenador_art_mod5.asl` deve perceber `status("concluida")` e imprimir confirmação.

## Arquivos a modificar

- `src/ex/mod5-ex1-msg.jcm`
- `src/agt/coordenador_msg_mod5.asl`
- `src/agt/executor_msg_mod5.asl`
- `src/ex/mod5-ex1-art.jcm`
- `src/env/example/TarefaBoard.java`
- `src/agt/coordenador_art_mod5.asl`
- `src/agt/executor_art_mod5.asl`

## Critérios de aceite

- [ ] Na versão por mensagem, o fluxo aparece no terminal: coordenador envia, executor executa, coordenador recebe `concluida(...)`.
- [ ] Na versão por artefato, o Workspace Inspector mostra o artefato `TarefaBoard` com `status("concluida")`.
- [ ] Você consegue explicar em uma frase onde ficou a coordenação em cada versão: no agente ou no ambiente.

## Como testar

Versão por mensagem:

```bash
./gradlew -q --console=plain run -Pjcm=src/ex/mod5-ex1-msg.jcm
```

Versão por artefato:

```bash
./gradlew -q --console=plain run -Pjcm=src/ex/mod5-ex1-art.jcm
```

O que observar:

- `http://localhost:3272` → Mind Inspector: crenças `tarefa(...)`, `concluida(...)`, `status(...)`.
- `http://localhost:3273` → Workspace Inspector: artefato `TarefaBoard` e propriedade `status`.
- Terminal: prints dos agentes confirmando o fluxo.

<details>
<summary>Dica</summary>

Na versão por mensagem, pense no padrão do Módulo 2:

```prolog
.send(executor, tell, tarefa("relatorio")).
+tarefa(T)[source(A)] <- ...
```

Na versão por artefato, pense no padrão do Módulo 3:

```java
defineObsProperty("status", "pendente");
prop.updateValue("concluida");
```

A comparação que importa: na primeira versão, o coordenador precisa conversar diretamente com o executor; na segunda, ambos se coordenam por um estado compartilhado.

</details>
