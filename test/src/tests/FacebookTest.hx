package tests;

import extension.facebook.AppInvite;
import extension.facebook.Facebook;
import extension.facebook.FriendList;
import extension.facebook.Permissions;
import extension.facebook.Share;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import flash.text.TextField;
import haxe.unit.TestCase;

class FacebookTest extends TestCase {

	var spr : Sprite;
	var face : Facebook;
	var tokenTxt : TextField;

	function printFun(str : String) {
		#if mobile
		trace(str);
		#else
		Sys.println(str);
		#end
	}

	function onLoggedIn() {
		tokenTxt.text = face.accessToken;
		FriendList.invitableFriends(
			face,
			function(friends : Array<UserInvitableFriend>) {
				for (f in friends) {
					printFun(f.name);
				}
			},
			printFun
		);
		AppInvite.invite("https://fb.me/1654475341456363");
		Permissions.currentPermissions(face, function(a) trace(a), function(e) trace(e));
		/*
		Share.link(
			"http://www.sempaigames.com/daktylos",
			"El Daktylooos",
			"http://www.sempaigames.com/images/daktylos/daktylos-poster-2.jpg",
			"Juega al Daktylos, un divertido juego prehistorico =)"
		);
*/
	}

	public function test() {

		spr = new Sprite();
		var gfx = spr.graphics;
		gfx.beginFill(0xff0000);
		gfx.drawRect(0, 0, 200, 200);
		gfx.endFill();
		Lib.current.stage.addChild(spr);

		tokenTxt = new TextField();
		tokenTxt.autoSize = flash.text.TextFieldAutoSize.LEFT;
		tokenTxt.scaleX = tokenTxt.scaleY = 2.0;
		Lib.current.stage.addChild(tokenTxt);

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
