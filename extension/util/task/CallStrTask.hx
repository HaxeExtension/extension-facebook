package extension.util.task;

class CallStrTask extends Task {

	var fn : String->Void;
	var str : String;

	public function new(fn : String->Void, str : String) {
		this.fn = fn;
		this.str = str;
	}

	override public function _do() {
		fn(str);
	}

}
