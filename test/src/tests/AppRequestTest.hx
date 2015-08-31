package tests;

import extension.facebook.AppRequests;
import extension.facebook.Facebook;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import haxe.unit.TestCase;

class AppRequestTest extends TestCase {

	var spr : Sprite;
	var objs : Array<{id : String, spr : Sprite}>;
	var face : Facebook;

	function addObj(fbObj : FBObject) {
		var newObj = new Sprite();
		newObj.addEventListener(MouseEvent.CLICK, function(m) {
			removeObj(newObj, true);
		});
		var txt = new TextField();
		txt.autoSize = TextFieldAutoSize.LEFT;
		txt.text = fbObj.message;
		txt.scaleX = txt.scaleY = 2.0;
		var gfx = newObj.graphics;
		var r = Std.random(100)+100;
		var g = Std.random(100)+100;
		var b = Std.random(100)+100;
		gfx.beginFill(r<<16 | g<<8 | b);
		gfx.drawRect(0, 0, txt.width, txt.height);
		gfx.endFill();
		newObj.addChild(txt);
		spr.addChild(newObj);
		objs.push({id : fbObj.id, spr : newObj});
		updateObjsPos();
	}

	function removeObj(obj : Sprite, fromServer : Bool = false) {
		var toRemove = null;
		for (o in objs) {
			if (o.spr == obj) {
				toRemove = o;
			}
		}
		objs.remove(toRemove);
		spr.removeChild(obj);
		if (fromServer) {
			AppRequests.deleteObject(
				face,
				toRemove.id,
				function(str) trace("complete: " + str),
				function(str) trace("fail: " + str)
			);
		}
		updateObjsPos();
	}

	function updateObjsPos() {
		var yPos = 0.0;
		for (o in objs) {
			o.spr.y = yPos;
			yPos += o.spr.height + 10;
		}
	}

	function onUpdate(m : MouseEvent) {
		var toRemove = objs.copy();
		for (r in toRemove) {
			removeObj(r.spr);
		}
		AppRequests.getObjectList(face, function(objs) {
			for (o in objs) {
				trace("Object: " + o);
				addObj(o);
			}
		}, function(o) trace(o));
	}

	function onSend(m : MouseEvent) {
		AppRequests.gameRequestSend({
			message : "Mensaje de test: " + Std.random(1000),
			title : "Titleloko",
			objectId : "1494850427480255",
			actionType : GameRequestActionType.Send
		});
	}

	// Entry point:
	public function test() {
		
		face = new Facebook();
		if (face.accessToken=="") {
			face.login(
				PermissionsType.Read,
				["email", "user_likes"],
				function() {	 	// Sucess
					trace("Sucess");
				},
				function() {		// Cancel
					trace("Cancel");
				},
				function(error) {	// Error
					trace("error " + error);
				}
			);
		}

		spr = new Sprite();
		Lib.current.stage.addChild(spr);
		objs = [];

		var update = new Sprite();
		var gfx = update.graphics;
		gfx.beginFill(0xff55ff);
		gfx.drawRect(0, 0, 200, 200);
		gfx.endFill();
		var txt = new TextField();
		txt.autoSize = TextFieldAutoSize.LEFT;
		txt.scaleX = txt.scaleY = 2.0;
		txt.text = "Update";
		update.addChild(txt);
		txt.x = update.width/2 - txt.width/2;
		txt.y = update.height/2 - txt.height/2;
		spr.addChild(update);
		update.y = Lib.current.stage.stageHeight - update.height;
		update.addEventListener(MouseEvent.CLICK, onUpdate);

		var send = new Sprite();
		gfx = send.graphics;
		gfx.beginFill(0xffff55);
		gfx.drawRect(0, 0, 200, 200);
		gfx.endFill();
		txt = new TextField();
		txt.autoSize = TextFieldAutoSize.LEFT;
		txt.scaleX = txt.scaleY = 2.0;
		txt.text = "Send";
		send.addChild(txt);
		txt.x = send.width/2 - txt.width/2;
		txt.y = send.height/2 - txt.height/2;
		spr.addChild(send);
		send.x = Lib.current.stage.stageWidth - send.width;
		send.y = Lib.current.stage.stageHeight - send.height;
		send.addEventListener(MouseEvent.CLICK, onSend);

		assertTrue(true);
	}

}
