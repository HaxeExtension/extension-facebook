package tests;

import extension.facebookrest.android.FacebookExtension;
import extension.facebookrest.FriendsInvite;
import extension.facebookrest.Graph;
import haxe.unit.TestCase;

class FacebookTest extends TestCase {
	
	function printFun(prefix : String, str : String) {
		Sys.println(prefix + " => " + str);
	}

	public function test() {

		FacebookExtension.init();

		/*
		var g = new Graph();
		g.getToken(
			"1649878375249393",
			function(s) {
				FriendsInvite.invitableFriends(
					g,
					function(friends : Array<UserInvitableFriend>) {
						for (f in friends) {
							Sys.println(f.name);
						}
					},
					Sys.println
				);
			},
			function() Sys.println("Failure")
		);
*/
		/*
		g.get("/me", printFun.bind("sucess"), printFun.bind("failure"));
		*/

		/*
		g.post(
			"/me/feed",
			printFun.bind("sucess"),
			["message"=>"Hola Juan, te saludo"],
			printFun.bind("failure")
		);
		*/

		assertTrue(true);

	}

}
