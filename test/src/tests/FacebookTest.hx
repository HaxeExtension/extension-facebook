package tests;

#if android
import extension.facebookrest.android.FacebookCallbacks;
import extension.facebookrest.android.FacebookExtension;
#end
import extension.facebookrest.FriendsInvite;
import extension.facebookrest.Graph;
import haxe.unit.TestCase;

class FacebookTest extends TestCase {
	
	function printFun(str : String) {
		#if mobile
		trace(str);
		#else
		Sys.println(str);
		#end
	}

	public function test() {

		var graph = new Graph();
		graph.login(
			function() {	// Sucess
				trace("login ok");
				FriendsInvite.invitableFriends(
					graph,
					function(friends : Array<UserInvitableFriend>) {
						for (f in friends) {
							printFun(f.name);
						}
					},
					printFun
				);
			},
			function() {	// Error
				trace("error");
			},
			"1649878375249393"	// App ID
		);

		assertTrue(true);

	}

}
