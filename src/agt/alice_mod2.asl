// initial beliefs and rules

// initial goals
!enviar_saudacao_para_bob.

// plans
+!enviar_saudacao_para_bob
    <- .send(bob, tell, saudacao("bom dia")).
