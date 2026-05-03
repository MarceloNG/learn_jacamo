// Modulo 5 — Exercicio de consolidaçao - Coordenação: As Três Dimensões
// O agente executor deve:
// receber a obrigação organizacional;
// executar o goal da missão;
// /perceber status("pendente");
// chamar concluir.


+!concluir_tarefa
    <- .wait(status("pendente"));
       .print("Status pendente, vou concluir...");
       concluir;
       .print("Executor concluiu a tarefa no TarefaBoard.").

+confirmacao(Confirmacao) : Confirmacao == concluida
    <- .print("Executor recebeu a confirmação de que a tarefa foi concluída: ", Confirmacao).

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
{ include("$moise/asl/org-obedient.asl") }
