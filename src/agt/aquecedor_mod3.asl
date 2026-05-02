// Modulo 3 — Exercicio de consolidacao
// Agente responsavel por aquecer o Termometro.

// initial goals
!aquecer.

// plans
+!aquecer
    <- .print("Aquecedor: aumentando a temperatura em 3 graus.");
       ajustar(3);
       .wait(1000);
       !aquecer.

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
