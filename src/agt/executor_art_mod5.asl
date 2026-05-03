// Modulo 5 — Exercicio de introdução - Coordenação: As Três Dimensões
// agente executor_art_mod5.asl observar se há tarefa pendente em TarefaBoard e chamar concluir de TarefaBoard

!executar_tarefa.

+!executar_tarefa
    <- .wait(status("pendente"));
       .print("Status pendente, vou concluir...");
       concluir;
       .print("Executor concluiu a tarefa no TarefaBoard.").

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
