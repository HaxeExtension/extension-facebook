package extension.facebookrest;

#if android
import extension.facebookrest.android.FacebookCallbacks;
import extension.facebookrest.android.FacebookCFFI;
#elseif ios
import extension.facebookrest.ios.FacebookCFFI;
#end

import extension.util.task.*;
import flash.Lib;
import flash.net.URLRequest;
import haxe.Json;
import sys.net.Host;
import sys.net.Socket;

#if cpp
import cpp.vm.Thread;
#else
import neko.vm.Thread;
#end

class Facebook extends TaskExecutor {

	public var accessToken : String;

	public function new() {
		super();
	}

	public function login(onSuccess : Void->Void, onFailure : Void -> Void, appID : String = "") {

		#if android

		var callbacks = new FacebookCallbacks();
		callbacks.onLoginSucess = function(token : String) {
			trace("sucess callback: " + token);
			this.accessToken = token;
			addTask(new CallTask(onSuccess));
		}
		callbacks.onLoginError = function() {
			addTask(new CallTask(onFailure));
		}
		FacebookCFFI.setCallBackObject(callbacks);
		FacebookCFFI.init();

		#elseif ios

		FacebookCFFI.init();

		#else

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
