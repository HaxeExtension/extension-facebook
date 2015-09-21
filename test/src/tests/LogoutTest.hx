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

class LogoutTest extends TestCase {

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
		haxe.Timer.delay(function() {
			printFun("logout");
			face.logout();
		}, 5000);
		haxe.Timer.delay(function() {
			printFun("post-logout, token: " + face.accessToken);
		}, 6000);
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
