// Modulo 5 — Exercicio de consolidacao - Coordenação: As Três Dimensões
// Crie ou adapte um artefato CArtAgO, por exemplo src/env/example/TarefaBoardMod5.java, com:
// observável status("pendente");
// operação concluir() que muda para status("concluida")

package example;

import cartago.*;

public class TarefaBoardMod5 extends Artifact {

	void init() {
		defineObsProperty("status", "pendente");
	}

	@OPERATION
	void concluir() {
		ObsProperty prop = getObsProperty("status");
		prop.updateValue("concluida");
		signal("tick");
	}
}
