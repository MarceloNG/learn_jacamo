// initial beliefs and rules
turno(tarde).

// initial goals
!apresentar.

// plans
+!apresentar : turno(manha)
    <- .print("Bom dia!").

+!apresentar <- .print("Olá!").