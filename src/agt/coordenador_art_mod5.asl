// Modulo 5 — Exercicio de introdução - Coordenação: As Três Dimensões
// agente coordenador_art_mod5.asl deve perceber status("concluida") de TarefaBoard e imprimir confirmação.

+status(Status) : Status == "concluida"
    <- .print("Coordenador percebeu que a tarefa foi concluída no TarefaBoard.").

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
