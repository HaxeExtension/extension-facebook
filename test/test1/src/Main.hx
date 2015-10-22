package;

import haxe.unit.TestRunner;

class Main {

	public static function main() {
		var r = new TestRunner();
		//r.add(new tests.AppRequestTest());
		r.add(new tests.LogoutTest());
		r.run();
	}

}
