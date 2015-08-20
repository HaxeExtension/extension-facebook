
package extension.facebook;

#if android
import extension.facebook.android.FacebookCallbacks;
import extension.facebook.android.FacebookCFFI;
#elseif ios
import extension.facebook.ios.FacebookCFFI;
#end

import extension.util.task.*;
import flash.Lib;
import flash.net.URLRequest;
import haxe.Json;
import haxe.Sys;
import sys.net.Host;
import sys.net.Socket;

#if cpp
import cpp.vm.Thread;
#else
import neko.vm.Thread;
#end

@:enum
abstract PermissionsType(Int) {
	var Publish = 0;
	var Read = 1;
}

class Facebook extends TaskExecutor {

	static var initted = false;
	public var accessToken : String;

	public function new() {
		accessToken = "";
		if (!initted) {
			#if (android || ios)
			FacebookCFFI.init(function(token) {
				this.accessToken = token;
			});
			#end
			initted = true;
		}
		super();
	}

	public function login(
		type : PermissionsType,
		permissions : Array<String>,
		onSuccess : Void->Void,
		onCancel : Void->Void,
		onError : String->Void
	) {

		var fOnSuccess = function() {
			addTask(new CallTask(onSuccess));
		}

		var fOnCancel = function() {
			addTask(new CallTask(onCancel));
		}

		var fOnError = function(error) {
			addTask(new CallStrTask(onError, error));
		}

		#if (android || ios)

		FacebookCFFI.setOnLoginSuccessCallback(fOnSuccess);
		FacebookCFFI.setOnLoginCancelCallback(fOnCancel);
		FacebookCFFI.setOnLoginErrorCallback(fOnError);

		FacebookCFFI.logInWithReadPermissions(permissions);

		#else

		var appID = Sys.getEnv("FACEBOOK_APP_ID");
		var redirectUri = "http://vmoura.dojo/ws_face_prueba";
		var url = 'https://www.facebook.com/dialog/oauth?client_id=$appID&redirect_uri=$redirectUri';

		Thread.create(function() {
			var s = new Socket();
			s.bind(new Host("localhost"), 8100);
			s.listen(1);
			var stopSrvLoop = false;
			do {
				var result = Socket.select([s], [], [], 0.5);
				if (result.read.length>0) {
					var c = s.accept();
					var str = null;
					var error = true;
					while (str!="") {
						str = c.input.readLine();
						if (~/GET \/+/.match(str)) {
							str = str.split(" ")[1];
							str = str.substr(2);
							for (v in str.split("&")) {
								var arr = v.split("=");
								if (arr[0]=="access_token") {
									this.accessToken = arr[1];
									addTask(new CallTask(onSuccess));
									error = false;
								}
							}
						}
					}
					if (error) {
						addTask(new CallTask(onFailure));
					}
					c.write(error?HTMLAssets.getErrorHTML():HTMLAssets.getSuccessHTML());
					c.close();
					stopSrvLoop = true;
				}
			} while (!stopSrvLoop);
			s.close();
		});

		Lib.getURL(new URLRequest(url));

		#end

	}

	public function get(
		resource : String,
		onSuccess : Dynamic->Void = null,
		parameters : Map<String, String> = null,
		onError : Dynamic->Void = null
	) : Void {

		RestClient.getAsync(
			"https://graph.facebook.com/v2.4"+resource+"?"+"access_token="+accessToken,
			function(x) onSuccess(Json.parse(x)),
			parameters,
			function(x) onError(Json.parse(x))
		);

	}

	public function post(
		resource : String,
		onSuccess : Dynamic->Void = null,
		parameters : Map<String, String> = null,
		onError : Dynamic->Void = null
	) : Void {

		RestClient.postAsync(
			"https://graph.facebook.com/v2.4"+resource+"?"+"access_token="+accessToken,
			function(x) onSuccess(Json.parse(x)),
			parameters,
			function(x) onError(Json.parse(x))
		);

	}

}
