package extension.facebook;

#if android
import extension.facebook.android.FacebookCFFI;
#elseif ios
import extension.facebook.ios.FacebookCFFI;
#end

class GameRequests {

	public static function gameRequestSend(
		message : String,
		title : String,
		recipients : Array<String> = null,
		objectId : String = null
	) {
		FacebookCFFI.gameRequestSend(message, title, recipients, objectId);
	}

}
