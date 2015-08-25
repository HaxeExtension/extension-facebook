package extension.facebook.android;

import openfl.utils.JNI;

@:build(ShortCuts.mirrors())
class FacebookExtension {

	public static var callbacksObject : FacebookCallbacks;

	public static function init(onTokenChange : String->Void) {
		callbacksObject = new FacebookCallbacks();
		callbacksObject.onTokenChange = onTokenChange;
		var fn = JNI.createStaticMethod(
			"org.haxe.extension.facebook.FacebookExtension",
			"init",
			"(Lorg/haxe/lime/HaxeObject;)V"
		);
		JNI.callStatic(fn, [callbacksObject]);
	}

	public static function setOnLoginSuccessCallback(f : Void->Void) {
		callbacksObject.onLoginSucess = f;
	}

	public static function setOnLoginCancelCallback(f : Void->Void) {
		callbacksObject.onLoginCancel = f;
	}

	public static function setOnLoginErrorCallback(f : String->Void) {
		callbacksObject.onLoginError = f;
	}

	public static function setOnAppInviteComplete(f : String->Void) {	// passes a JSON object to f
		callbacksObject.onAppInviteComplete = f;
	}

	public static function setOnAppInviteFail(f : String->Void) {
		callbacksObject.onAppInviteFail = f;
	}

	@JNI("org.haxe.extension.facebook", "logout")
	public static function logout() {}

	public static function logInWithPublishPermissions(arr : Array<String>) {
		var str = "";
		for (s in arr) {
			str += s + ";";
		}
		var fn = JNI.createStaticMethod(
			"org.haxe.extension.facebook.FacebookExtension",
			"logInWithPublishPermissions",
			"(Ljava/lang/String;)V"
		);
		JNI.callStatic(fn, [str]);
	}

	public static function logInWithReadPermissions(arr : Array<String>) {
		var str = "";
		for (s in arr) {
			str += s + ";";
		}
		var fn = JNI.createStaticMethod(
			"org.haxe.extension.facebook.FacebookExtension",
			"logInWithReadPermissions",
			"(Ljava/lang/String;)V"
		);
		JNI.callStatic(fn, [str]);
	}

	@JNI("org.haxe.extension.facebook", "appInvite")
	public static function appInvite(appLinkUrl : String, previewImageUrl : String = null) {}

	@JNI("org.haxe.extension.facebook", "shareLink")
	public static function shareLink(
		contentURL : String,
		contentTitle : String,
		imageURL : String,
		contentDescription : String
	) {}

}
