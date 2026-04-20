package example;

import cartago.*;

/**
 * A simple artifact.
 *
 * Documentation about how to implement an artifact:
 * - https://github.com/CArtAgO-lang/cartago/blob/master/docs/cartago_by_examples/cartago_by_examples.pdf
 */
public class Counter extends Artifact {
	void init(int initialValue) {
		defineObsProperty("count", initialValue);
	}

	@OPERATION
	void inc() {
		ObsProperty prop = getObsProperty("count");
		prop.updateValue(prop.intValue() + 1);
		signal("tick");
	}

	@OPERATION
	void inc_get(int inc, OpFeedbackParam<Integer> newValueArg) {
		ObsProperty prop = getObsProperty("count");
		int newValue = prop.intValue() + inc;
		prop.updateValue(newValue);
		newValueArg.set(newValue);
	}
}
