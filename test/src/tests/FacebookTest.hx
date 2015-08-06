package tests;

import extension.facebookrest.AppInvite;
import extension.facebookrest.Facebook;
import extension.facebookrest.FriendList;
import extension.facebookrest.Share;
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

		var face = new Facebook();
		face.login(
			function() {	// Sucess
				FriendList.invitableFriends(
					face,
					function(friends : Array<UserInvitableFriend>) {
						for (f in friends) {
							printFun(f.name);
						}
					},
					printFun
				);
				//AppInvite.invite("https://fb.me/1654475341456363");
				Share.link("http://www.sempaigames.com/daktylos");
			},
			function() {	// Error
				trace("error");
			},
			"1649878375249393"	// App ID
		);

		assertTrue(true);

	}

}
