package extension.facebook;

import haxe.Json;
#if android
import extension.facebook.android.FacebookCFFI;
#elseif ios
import extension.facebook.ios.FacebookCFFI;
#end

@:enum
abstract GameRequestActionType(Int) to Int {
	var AskFor = 0;
	var Send = 1;
	var Turn = 2;
}

typedef SendOptions = {
	@:optional var message : String;
	@:optional var title : String;
	@:optional var recipients : Array<String>;
	@:optional var objectId : String;
	@:optional var actionType : GameRequestActionType;
	@:optional var data : String;
}

typedef SendResponse = {
	var id : String;
	var recipients : Array<String>;
}

typedef ApplicationData = {
	var name : String;
	var namespace : String;
	var id : String;
}

typedef UserData = {
	var name : String;
	var id : String;
}

typedef FBObject = {
	var id : String;
	var application : ApplicationData;
	var to : UserData;
	var from : UserData;
	var message : String;
	var created_time : String;
}

class AppRequests {

	public static function gameRequestSend(options : SendOptions) {
		#if (android || ios)
		FacebookCFFI.gameRequestSend(
			options.message,
			options.title,
			options.recipients,
			options.objectId,
			options.actionType,
			options.data
		);
		#end
	}

	public static function setOnCompleteCallback(f : SendResponse->Void) {
		#if (android || ios)
		FacebookCFFI.setOnGameRequestComplete(function (str) {
			f(Json.parse(str));
		});
		#end
	}

	public static function setOnFailCallback(f : String->Void) {
		#if (android || ios)
		FacebookCFFI.setOnGameRequestFail(f);
		#end
	}

	public static function getObject(
		f : Facebook,
		id : String,
		onComplete : FBObject->Void,
		onFail : Dynamic->Void
	) {
		f.get("/" + id, onComplete, onFail);
	}

	public static function getObjectList(
		f : Facebook,
		onComplete : Array<Dynamic>->Void,
		onFail : Dynamic->Void
	) {
		f.getAll("/me/apprequests", onComplete, onFail);
	}

}
