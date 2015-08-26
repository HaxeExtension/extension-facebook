package extension.facebook.ios;

@:build(ShortCuts.mirrors())
@CPP_DEFAULT_LIBRARY("extension_facebook")
@CPP_PRIMITIVE_PREFIX("extension_facebook")
class FacebookCFFI {

	@CPP public static function init(onTokenChange : String->Void) {}
	@CPP public static function logout();
	@CPP public static function logInWithPublishPermissions(permissions : Array<String> = null) {}
	@CPP public static function logInWithReadPermissions(permissions : Array<String> = null) {}
	
	@CPP public static function appInvite(appLinkUrl : String, previewImageUrl : String = null) {}
	
	@CPP public static function shareLink(
		contentURL : String,
		contentTitle : String,
		imageURL : String,
		contentDescription : String
	) {};

	@CPP public static function gameRequestSend(
		message : String,
		title : String,
		recipients : Array<String> = null,
		objectId : String = null
	) {};

	@CPP public static function setOnLoginSuccessCallback(f : Void->Void);
	@CPP public static function setOnLoginCancelCallback(f : Void->Void);
	@CPP public static function setOnLoginErrorCallback(f : String->Void);
	@CPP public static function setOnAppInviteComplete(f : String->Void);	// passes a JSON object to f
	@CPP public static function setOnAppInviteFail(f : String->Void);

}
