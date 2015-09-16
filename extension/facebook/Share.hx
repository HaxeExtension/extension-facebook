package extension.facebook;

#if android
import extension.facebook.android.FacebookCFFI;
#elseif ios
import extension.facebook.ios.FacebookCFFI;
#end

class Share {

	public static function link(contentURL : String,
		contentTitle : String = "",
		imageURL : String = "",
		contentDescription : String = "") {

		#if (android || ios)
		FacebookCFFI.shareLink(contentURL, contentTitle, imageURL, contentDescription);
		#end

	}

	public static function setOnCompleteCallback(f : String->Void) {
		#if (android)
		FacebookCFFI.setOnShareComplete(f);
		#end
	}

	public static function setOnFailCallback(f : String->Void) {
		#if (android)
		FacebookCFFI.setOnShareFail(f);
		#end
	}

}
