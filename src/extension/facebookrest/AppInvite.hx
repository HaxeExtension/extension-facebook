package extension.facebookrest;

#if android
import extension.facebookrest.android.FacebookExtension;
#end

class AppInvite {
	
	public static function invite(appLinkUrl : String, previewImageUrl : String = "")  {
		#if android
		FacebookExtension.appInvite(appLinkUrl, previewImageUrl);
		#end
	}

}
