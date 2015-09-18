package extension.facebook.ios;

import haxe.Json;

@:build(ShortCuts.mirrors())
@CPP_DEFAULT_LIBRARY("extension_facebook")
@CPP_PRIMITIVE_PREFIX("extension_facebook")
class FacebookCFFI {

	/*
	IOS Facebook SDK returns JSONs in the style:
		{
		  "to[0]" : "10207238882472683",
		  "request" : "1647123868893945"
		}
	this method converts to:
		{
			"to" : ["10207238882472683"],
			"request" : "1647123868893945"
		}
	*/
	static function postProcessJSON(inStr : String) : String {
		var result = inStr;
		try {
			var obj = Json.parse(inStr);
			var newObj = {};
			var arrs : Map<String, Array<Dynamic>> = new Map<String, Array<Dynamic>>();
			var r = ~/\[.+\]/;
			var fields = Reflect.fields(obj);
			fields.sort(function (a, b) {
				if (a<b) {
					return -1;
				} else if (a>b) {
					return 1;
				} else {
					return 0;
				}
			});
			for (k in fields) {
				if (r.match(k)) {
					var replaced = r.replace(k, "");
					var arr = arrs.get(replaced);
					if (arr==null) {
						arr = [];
					}
					arr.push(Reflect.field(obj, k));
					arrs.set(replaced, arr);
				} else {
					Reflect.setField(newObj, k, Reflect.field(obj, k));
				}
			}
			for (k in arrs.keys()) {
				Reflect.setField(newObj, k, arrs[k]);
			}
			result = Json.stringify(newObj);
		} catch (e : Dynamic) {}
		return result;
	}

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

	@CPP public static function appRequest(
		message : String,
		title : String,
		recipients : Array<String> = null,
		objectId : String = null,
		actionType : Int = 0,
		data : String = null
	) {};

	@CPP public static function setOnLoginSuccessCallback(f : Void->Void);
	@CPP public static function setOnLoginCancelCallback(f : Void->Void);
	@CPP public static function setOnLoginErrorCallback(f : String->Void);

	@CPP public static function setOnAppInviteComplete(f : String->Void);	// passes a JSON object to f
	@CPP public static function setOnAppInviteFail(f : String->Void);

	@CPP("extension_facebook","setOnAppRequestComplete")
	static function _setOnAppRequestComplete(f : String->Void);

	public static function setOnAppRequestComplete(f : String->Void) {
		_setOnAppRequestComplete(function(str) {
			str = postProcessJSON(str);
			f(str);
		});
	}
	@CPP public static function setOnAppRequestFail(f : String->Void);

	@CPP public static function setOnShareComplete(f : String->Void);
	@CPP public static function setOnShareFail(f : String->Void);

}
