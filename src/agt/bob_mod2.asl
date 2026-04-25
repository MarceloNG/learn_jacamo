// initial beliefs and rules
confio_em(alice).

// initial goals


// plans
+saudacao(M)[source(A)] : confio_em(A)
    <- .print("Recebi a saudação ", M, " de ", A,".");  // ação interna Jason
       +recebi_saudacao(M, A).  // adiciona crença de que recebeu a saudação (memória persistente)

+saudacao(M)[source(A)]
    <- .print("Recebi uma saudação de ", A, " mas não confio nele. Ignorando.").
