package extension.facebook;

import haxe.Json;
#if android
import extension.facebook.android.FacebookCFFI;
#elseif ios
import extension.facebook.ios.FacebookCFFI;
#end

@:enum
abstract AppRequestActionType(Int) to Int {
	var AskFor = 0;
	var Send = 1;
	var Turn = 2;
}

typedef SendOptions = {
	@:optional var message : String;
	@:optional var title : String;
	@:optional var recipients : Array<String>;
	@:optional var objectId : String;
	@:optional var actionType : AppRequestActionType;
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
	@:optional var category : String;
	@:optional var link : String;
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

	public static function sendObject(options : SendOptions) {
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

	public static function setOnSendObjectCompleted(fun : SendResponse->Void) {
		#if (android || ios)
		FacebookCFFI.setOnAppRequestComplete(function (str) {
			fun(Json.parse(str));
		});
		#end
	}

	public static function setOnSendObjectFailed(fun : String->Void) {
		#if (android || ios)
		FacebookCFFI.setOnAppRequestFail(fun);
		#end
	}

	public static function deleteObject(
		f : Facebook,
		id : String,
		onComplete : FBObject->Void = null,
		onFail : Dynamic->Void = null
	) {
		f.delete(id, onComplete, onFail);
	}

	public static function getObject(
		f : Facebook,
		id : String,
		onComplete : FBObject->Void = null,
		onFail : Dynamic->Void = null
	) {
		f.get(id, onComplete, onFail);
	}


	public static function getObjectList(
		f : Facebook,
		onComplete : Array<FBObject>->Void = null,
		onFail : Dynamic->Void = null
	) {
		f.getAll("/me/apprequests", onComplete, onFail);
	}

}
