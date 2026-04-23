// Agent bob in project learn_jacamo

/* Initial beliefs and rules */
// Crença inicial: fato concreto declarado antes de qualquer plano.
// Sintaxe: nome(valor).  ← minúscula no nome, termina com ponto
// Variáveis começam com MAIÚSCULA; constantes/nomes com minúscula.
modulo_atual(0).
humor(mau).

/* Initial goals */
// Objetivo inicial: disparado automaticamente quando o agente é criado.
// O "!" antes do nome indica que é um GOAL (objetivo), não uma crença.
!start.
!melhorar_humor.

/* Plans */

// Anatomia de um plano AgentSpeak:
//
//   +  !  start       :   modulo_atual(Mod)      <-  ação1 ;  ação2 .
//   │  │  │           │   │                      │        │        │
//   │  │  nome do     │   contexto de guarda:    │   sep. │     fim do
//   │  │  goal        │   consulta o belief base │  ações │      plano
//   │  │              │   e liga Mod = 0          │        │
//   │  marcador goal  separador                  corpo do plano
//   │
//   gatilho: "quando este goal for ADICIONADO (+), execute este plano"
//
// O contexto de guarda "true" = sem condição (executa sempre).
// Aqui usamos "modulo_atual(Mod)" para LER a crença e ligar a variável Mod.
+!start : modulo_atual(Mod)
    <- .print("hello world.");          // ação interna Jason: imprime no console
       .print("Iniciando modulo ", Mod); // Mod está ligado ao valor 0 da crença
       .date(Year,Mon,Day); .time(Hour,Min,Sec,MilSec); // get current date & time
       // "+" dentro do corpo = ADICIONA crença ao belief base (memória persistente)
       // diferente do "+" no cabeçalho, que é gatilho de evento
       +started(Year,Mon,Day,Hour,Min,Sec).  // ← ponto FINAL encerra o plano (como "}")

+!melhorar_humor : humor(mau)
    <- .print("Estou de mau humor, vou tentar melhorar...");  // ação interna Jason
       -+humor(bom).   // remove humor(mau) (mesmo functor/aridade) e adiciona humor(bom)

+!melhorar_humor : not humor(mau) & not humor(bom)
    <- .print("Não sei como estou me sentindo.").

+humor(bom) // ← gatilho de CRENÇA, não de meta
    <- .print("Agora estou de bom humor!").  // ação interna Jason
       // sem mudanças no belief base, apenas imprime a mensagem


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
