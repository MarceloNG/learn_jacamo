// Modulo 4 — Exercicio de consolidacao
// Agente coordenadora.
//
// A coordenadora observa a organizacao: ela nao manda goals diretamente
// para o trabalhador. A obrigacao vem de Moise.
!observar_organizacao.

+!observar_organizacao
    <- .wait(play(Ag, role2, _));
       .print("Coordenadora percebeu que ", Ag, " joga role2.").

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
