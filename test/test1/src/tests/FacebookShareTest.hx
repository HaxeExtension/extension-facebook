package tests;

import extension.facebook.AppInvite;
import extension.facebook.AppRequests;
import extension.facebook.Facebook;
import extension.facebook.FriendList;
import extension.facebook.Permissions;
import extension.facebook.Share;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import flash.text.TextField;
import haxe.unit.TestCase;

class FacebookShareTest extends TestCase {

	var spr : Sprite;
	var face : Facebook;

	function onLoggedIn() {
		Share.setOnCompleteCallback(function(str) Sys.println("Completed: " + str));
		Share.setOnFailCallback(function(str) Sys.println("Failed: " + str));
		Share.link(
			"http://www.sempaigames.com/daktylos",
			"El Daktylooos",
			"http://www.sempaigames.com/images/daktylos/daktylos-poster-2.jpg",
			"Juega al Daktylos, un divertido juego prehistorico =)"
		);
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
				}
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
