package;

import extension.facebookrest.Graph;

class Main {

	public static function main() {
		var g = new Graph();
		g.login(
			"1379899895580577",
			function(s) trace("token: " + s),
			function() trace("error")
		);
	}

}
