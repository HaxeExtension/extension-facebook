package tests;

import extension.facebookrest.AppInvite;
import extension.facebookrest.Facebook;
import extension.facebookrest.FriendList;
import extension.facebookrest.Share;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import haxe.unit.TestCase;

class FacebookTest extends TestCase {

	var spr : Sprite;
	var face : Facebook;

	function printFun(str : String) {
		#if mobile
		trace(str);
		#else
		Sys.println(str);
		#end
	}

	function onLoggedIn() {
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
	}

	public function test() {

		spr = new Sprite();
		var gfx = spr.graphics;
		gfx.beginFill(0xff0000);
		gfx.drawRect(0, 0, 200, 200);
		gfx.endFill();
		Lib.current.stage.addChild(spr);
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);

		face = new Facebook();
		if (face.accessToken!="") {
			onLoggedIn();
		} else {
			face.login(
				PermissionsType.Read,
				["email", "user_likes"],
				onLoggedIn, 		// Sucess
				function() {		// Cancel
					trace("Cancel");
				},
				function(error) {	// Error
					trace("error " + error);
				},
				"1649878375249393"	// App ID
			);
		}

		assertTrue(true);

	}

	function onEnterFrame(_) {
		spr.x += 5;
		if (spr.x+spr.width>Lib.current.stage.stageWidth) {
			spr.x = 0;
		}
	}

}
