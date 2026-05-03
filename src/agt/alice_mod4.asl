// Modulo 4 — Exercicio de introducao
// Agente alice.
//
// Objetivo didatico:
// Alice deve enviar uma mensagem para quem joga role2, sem escrever
// o nome "bob" no plano. Esse desacoplamento vem do Moise.

// initial goals
// Este goal inicial dispara automaticamente quando alice e criada.
!saudar_por_papel.

// plans
+!saudar_por_papel
    // .wait(...) e uma acao interna Jason.
    // Ela espera ate alice perceber alguma crenca organizacional:
    // play(Ag, role2, _)
    //
    // Ag e uma variavel: sera ligada ao agente que joga role2.
    // O "_" ignora o nome do grupo, porque aqui basta saber o papel.
    <- .wait(play(Ag, role2, _));
       // .send usa o agente descoberto em Ag.
       // Repare: nao aparece .send(bob, ...).
       .send(Ag, tell, saudacao("bom dia")).

// Includes padrao do projeto.
// common-moise.asl fornece as acoes/crencas de integracao com Moise.
{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
