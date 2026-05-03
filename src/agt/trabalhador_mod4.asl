// Modulo 4 — Exercicio de consolidacao
// Agente trabalhador.
//
// Este agente joga role2 no .jcm. Pela norma em org_mod4_ex2.xml,
// role2 tem obrigacao de cumprir mission1. O include org-obedient.asl
// transforma essa obrigacao em objetivos Jason, como +!goal2 e +!goal4.

+!goal2
    <- .print("Trabalhador cumpriu goal2 da mission1.").

+!goal4
    <- .print("Trabalhador cumpriu goal4 da mission1.").

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
{ include("$moise/asl/org-obedient.asl") }
