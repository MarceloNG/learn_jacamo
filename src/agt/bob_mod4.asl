// Modulo 4 — Exercicio de introducao
// Agente bob.
//
// Bob joga role2 no grupo g1, mas este arquivo nao precisa saber disso.
// Quem faz a ligacao bob -> role2 e o .jcm, na secao organisation.

// Gatilho Jason:
// Quando alice executa .send(Ag, tell, saudacao("bom dia")),
// bob recebe uma nova crenca saudacao(Texto).
//
// A anotacao [source(Remetente)] e adicionada pelo Jason e indica
// quem enviou a crenca.
+saudacao(Texto)[source(Remetente)]
    <- .print("recebi '", Texto, "' de ", Remetente).

// Includes padrao do projeto.
// common-moise.asl permite ao agente participar da organizacao Moise.
{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
