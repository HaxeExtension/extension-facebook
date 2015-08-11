package extension.facebookrest.ios;

@:build(ShortCuts.mirrors())
@CPP_DEFAULT_LIBRARY("extension_facebook")
@CPP_PRIMITIVE_PREFIX("extension_facebook")
class FacebookCFFI {

	@CPP public static function init() {}
	@CPP public static function appInvite(appLinkUrl : String, previewImageUrl : String) {}
	@CPP public static function shareLink(url : String) {}

}
