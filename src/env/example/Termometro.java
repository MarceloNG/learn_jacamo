package example;

import cartago.*;

/**
 * Modulo 3 — Exercicio de consolidacao
 *
 * Artefato CArtAgO compartilhado por dois agentes:
 * - aquecedor: altera a temperatura usando uma operacao
 * - fiscal: observa a propriedade temperatura como crenca Jason
 */
public class Termometro extends Artifact {

	void init(int temperaturaInicial) {
		defineObsProperty("temperatura", temperaturaInicial);
	}

	@OPERATION
	void ajustar(int delta) {
		ObsProperty prop = getObsProperty("temperatura");

		prop.updateValue(prop.intValue() + delta);
	}
}
