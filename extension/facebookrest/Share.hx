package extension.facebookrest;

#if android
import extension.facebookrest.android.FacebookCFFI;
#elseif ios
import extension.facebookrest.ios.FacebookCFFI;
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

}
