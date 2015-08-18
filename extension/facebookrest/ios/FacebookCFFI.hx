package extension.facebookrest.ios;

@:build(ShortCuts.mirrors())
@CPP_DEFAULT_LIBRARY("extension_facebook")
@CPP_PRIMITIVE_PREFIX("extension_facebook")
class FacebookCFFI {

	@CPP public static function init(onTokenChange : String->Void) {}
	@CPP public static function logout();
	@CPP public static function logInWithReadPermissions(permissions : Array<String> = null) {}
	@CPP public static function appInvite(appLinkUrl : String, previewImageUrl : String) {}
	@CPP public static function shareLink(url : String) {}

	@CPP public static function setOnLoginSuccessCallback(f : Void->Void);
	@CPP public static function setOnLoginCancelCallback(f : Void->Void);
	@CPP public static function setOnLoginErrorCallback(f : String->Void);

}
