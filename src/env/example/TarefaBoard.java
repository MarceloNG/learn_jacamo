// Modulo 5 — Exercicio de introdução - Coordenação: As Três Dimensões
// TarefaBoard é um artefato que pode ser usado para armazenar e compartilhar tarefas
// o artefato deve ter uma propriedade observável status, iniciando como "pendente";
// o artefato deve ter uma operação concluir() que muda status para "concluida";

package example;

import cartago.*;

public class TarefaBoard extends Artifact {

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
