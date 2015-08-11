package extension.facebookrest;

#if android
import extension.facebookrest.android.FacebookExtension;
#end

class Share {

	public static function link(url : String) {
		#if android
		FacebookExtension.shareLink(url);
		#end
	}
	
}
