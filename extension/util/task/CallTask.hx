package extension.util.task;

class CallTask extends Task {

	var fn : Void->Void;

	public function new(fn : Void->Void) {
		this.fn = fn;
	}

	override public function _do() {
		fn();
	}

}
