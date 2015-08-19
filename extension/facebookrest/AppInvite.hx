package extension.facebookrest;

#if android
import extension.facebookrest.android.FacebookCFFI;
#elseif ios
import extension.facebookrest.ios.FacebookCFFI;
#end

class AppInvite {
	
	// See https://developers.facebook.com/docs/applinks
	public static function invite(appLinkUrl : String, previewImageUrl : String = "")  {
		#if (android || ios)
		FacebookCFFI.appInvite(appLinkUrl, previewImageUrl);
		#end
	}

}
