package example;

import cartago.*;

/**
 * Artefato CArtAgO: Counter
 *
 * Um artefato é o equivalente JaCaMo de um "objeto do ambiente" —
 * como um objeto Python, mas que vive no ambiente compartilhado do MAS
 * e pode ser observado e operado por qualquer agente que tenha "focus" nele.
 *
 * Analogia Python:
 *   class Counter:
 *       def __init__(self, initial_value): self.count = initial_value
 *       def inc(self): self.count += 1
 *
 * Diferença chave: quando "count" muda aqui, o CArtAgO notifica automaticamente
 * todos os agentes que observam este artefato → vira crença count(N) no .asl.
 *
 * Documentação oficial:
 * https://github.com/CArtAgO-lang/cartago/blob/master/docs/cartago_by_examples/cartago_by_examples.pdf
 */
public class Counter extends Artifact {

	/**
	 * init() é chamado automaticamente pelo CArtAgO quando o artefato é criado.
	 * Equivale ao __init__ do Python.
	 *
	 * No .jcm:  artifact c1: example.Counter(3)
	 *                                           └── este "3" é o initialValue
	 *
	 * defineObsProperty("count", initialValue) faz duas coisas:
	 *   1. Cria o atributo interno "count" com o valor inicial
	 *   2. Marca "count" como OBSERVÁVEL — agentes com focus recebem
	 *      automaticamente a crença count(3) no belief base
	 */
	void init(int initialValue) {
		defineObsProperty("count", initialValue);
	}

	/**
	 * @OPERATION marca este método como uma OPERAÇÃO do artefato —
	 * ou seja, uma ação que agentes podem chamar de dentro do .asl:
	 *
	 *   No .asl:   inc;
	 *              └── sem parâmetros, sem retorno
	 *
	 * O que acontece internamente:
	 *   1. Lê a propriedade "count" atual
	 *   2. Atualiza para count + 1
	 *   3. Emite o sinal "tick" (agentes podem reagir a sinais também)
	 *   4. CArtAgO detecta a mudança e notifica bob → count(N) atualiza no .asl
	 */
	@OPERATION
	void inc() {
		ObsProperty prop = getObsProperty("count");
		prop.updateValue(prop.intValue() + 1);
		signal("tick"); // sinal opcional — agentes podem capturar com +tick no .asl
	}

	/**
	 * Versão combinada: incrementa E retorna o novo valor em uma única operação atômica.
	 * Útil em sistemas multi-agente para evitar condições de corrida.
	 *
	 * No .asl:   inc_get(1, NovoValor);
	 *                     │   └── variável livre que recebe o resultado (OpFeedbackParam)
	 *                     └── quanto incrementar
	 *
	 * OpFeedbackParam<Integer> é o mecanismo do CArtAgO para "retornar" valores
	 * para o agente. Do lado .asl, você passa uma variável não ligada e ela
	 * fica ligada ao valor após a execução — sem isso, .asl não tem "return".
	 *
	 * Exemplo de uso no .asl:
	 *   inc_get(2, N);          // incrementa 2, N fica = count antigo + 2
	 *   .print("Novo valor: ", N);
	 */
	@OPERATION
	void inc_get(int inc, OpFeedbackParam<Integer> newValueArg) {
		ObsProperty prop = getObsProperty("count");
		int newValue = prop.intValue() + inc;
		prop.updateValue(newValue);
		newValueArg.set(newValue); // "devolve" o valor para o agente
	}
}
