// Modulo 3 — Exercicio de consolidacao
// Agente responsavel por observar a temperatura.

// plans

+temperatura(T) : T < 30
    <- .print("A temperatura ", T, " esta aceitavel.").

+temperatura(T) : T >= 30
    <- .print("A temperatura ", T, " esta alta!").

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
