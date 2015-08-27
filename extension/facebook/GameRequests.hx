package extension.facebook;

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

class GameRequests {

	public static function gameRequestSend(
		message : String,
		title : String,
		recipients : Array<String> = null,
		objectId : String = null,
		actionType : GameRequestActionType = GameRequestActionType.AskFor
	) {
		FacebookCFFI.gameRequestSend(message, title, recipients, objectId, actionType);
	}

}
