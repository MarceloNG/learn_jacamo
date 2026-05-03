// Modulo 5 — Exercicio de introdução - Coordenação: As Três Dimensões
// executor deve receber +tarefa(T)[source(Coordenador)], 
// imprimir que executou, e responder com .send(Coordenador, tell, concluida(T)).

+tarefa(T)[source(Coordenador)]
    <- .print("Executor recebeu a tarefa: ", T);
       .send(Coordenador, tell, concluida(T));
       .print("Tarefa concluída e resposta enviada para o coordenador").


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
