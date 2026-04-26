// Modulo 3 — Exercicio Intro
// Objetivo: perceber uma propriedade observavel do Counter e chamar uma operacao.

// initial beliefs and rules

// initial goals
!observar_contador.

// plans

// TODO 1: crie um plano para +!observar_contador
//         A guarda deve depender da crenca count(N).
//

// TODO 2: no corpo do plano:
//         - imprima o valor inicial N
//         - chame inc_get(1, NovoValor)
//         - imprima NovoValor
//
// Estrutura esperada:
//
+!observar_contador : count(N)
    <- .print("Valor inicial do contador: ", N);
       inc_get(1, NovoValor);
       .print("Valor do contador apos incremento: ", NovoValor).
       

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
