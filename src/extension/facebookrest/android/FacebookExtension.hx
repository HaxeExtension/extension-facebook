package extension.facebookrest.android;

@:build(ShortCuts.mirrors())
class FacebookExtension {

	@JNI("org.haxe.extension.facebook", "init")
	public static function init() {}

}
