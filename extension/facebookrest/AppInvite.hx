package extension.facebookrest;

#if android
import extension.facebookrest.android.FacebookCFFI;
#end

class AppInvite {
	
	// See https://developers.facebook.com/docs/applinks
	public static function invite(appLinkUrl : String, previewImageUrl : String = "")  {
		#if android
		FacebookCFFI.appInvite(appLinkUrl, previewImageUrl);
		#end
	}

}
