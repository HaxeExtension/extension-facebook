package extension.facebook;

#if android
import extension.facebook.android.FacebookCFFI;
#elseif ios
import extension.facebook.ios.FacebookCFFI;
#end

class AppInvite {

	// See https://developers.facebook.com/docs/applinks
	public static function invite(appLinkUrl : String, previewImageUrl : String = "")  {
		#if (android || ios)
		FacebookCFFI.appInvite(appLinkUrl, previewImageUrl);
		#end
	}

	public static function setOnCompleteCallback(f : String->Void) {
		#if (android || ios)
		FacebookCFFI.setOnAppInviteComplete(f);
		#end
	}

	public static function setOnFailCallback(f : String->Void) {
		#if (android || ios)
		FacebookCFFI.setOnAppInviteFail(f);
		#end
	}

}
