// Modulo 5 — Exercicio de consolidaçao - Coordenação: As Três Dimensões
// perceber quando executor joga role2;
// perceber quando o artefato chegar em status("concluida");
// enviar uma mensagem final para o executor, algo como confirmacao(concluida).

!observar_organizacao.

+!observar_organizacao
    <- .wait(play(Ag, role2, _));
       .print("Coordenadora percebeu que ", Ag, " joga role2.").


+status(Status) : Status == "concluida"
    <- .print("Coordenador percebeu que a tarefa foi concluída no TarefaBoard.");
       .send(executor, tell, confirmacao(concluida)).


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
