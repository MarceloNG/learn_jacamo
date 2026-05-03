// Modulo 5 — Exercicio de introdução - Coordenação: As Três Dimensões
// O coordenador deve enviar uma tarefa diretamente para o executor usando .send(executor, tell, tarefa(...)).
// coordenador deve reagir a +concluida(T)[source(executor)] e imprimir confirmação.

!enviar_tarefa.

+!enviar_tarefa
    <- .send(executor, tell, tarefa("Fazer algo importante"));
       .print("Tarefa enviada para o executor").

+concluida(T)[source(executor)]
    <- .print("Coordenador recebeu confirmação de conclusão da tarefa: ", T).


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
