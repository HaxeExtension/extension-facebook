
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
#if (cpp || neko)
import sys.net.Host;
import sys.net.Socket;
#end

#if cpp
import cpp.vm.Thread;
#elseif neko
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

	private var initCallback:Bool->Void;
	private static var instance:Facebook=null;

	public static function getInstance():Facebook{
		if(instance==null) instance = new Facebook();
		return instance;
	}

	private function new() {
		accessToken = "";
		super();
	}

	public function init(initCallback:Bool->Void) {
		if (!initted) {
			#if (android || ios)
			this.initCallback = initCallback;
			FacebookCFFI.init(this.setAuthToken);
			#end
		}
	}

	public function setAuthToken(token) {
		if (token != "") {
			initted = true;
		}
		this.accessToken = token;
		if (this.initCallback != null) {
			this.initCallback(true);
		}
	}

	public function login(
		type : PermissionsType,
		permissions : Array<String>,
		onComplete : Void->Void,
		onCancel : Void->Void,
		onError : String->Void
	) {

		var fonComplete = function() {
			addTask(new CallTask(onComplete));
		}

		var fOnCancel = function() {
			addTask(new CallTask(onCancel));
		}

		var fOnError = function(error) {
			addTask(new CallStrTask(onError, error));
		}

		#if (android || ios)

		FacebookCFFI.setOnLoginSuccessCallback(fonComplete);
		FacebookCFFI.setOnLoginCancelCallback(fOnCancel);
		FacebookCFFI.setOnLoginErrorCallback(fOnError);

		FacebookCFFI.logInWithReadPermissions(permissions);

		#elseif (cpp || neko)

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
									addTask(new CallTask(onComplete));
									error = false;
								}
							}
						}
					}
					if (error) {
						addTask(new CallStrTask(fOnError, "Error"));
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

	public function logout() {
		#if (android || iphone)
		FacebookCFFI.logout();
		#end
	}

	function prependSlash(str : String) : String {
		if (str.charAt(0)=="/") {
			return str;
		}
		return "/" + str;
	}

	public function delete(
		resource : String,
		onComplete : Dynamic->Void = null,
		parameters : Map<String, String> = null,
		onError : Dynamic->Void = null
	) : Void {

		if (onComplete==null) {
			onComplete = function(s) {};
		}
		if (parameters==null) {
			parameters = new Map<String, String>();
		}
		if (onError==null) {
			onError = function(s) {};
		}
		parameters.set("redirect", "false");
		#if android
		FacebookCFFI.graphRequest(
			prependSlash(resource),
			parameters,
			"DELETE",
			function(x) {
				try { 
					var parsed = Json.parse(x);
					onComplete(parsed);
				} catch(error:String) { trace(error, x); }
			},
			function(x) {
				try { 
					var parsed = Json.parse(x);
					onError(parsed);
				} catch(error:String) { trace(error, x); }	
			}
		);
		#else
		parameters.set("access_token", accessToken);
		RestClient.deleteAsync(
			"https://graph.facebook.com/v2.4"+prependSlash(resource),
			function(x) {
				try { 
					var parsed = Json.parse(x);
					onComplete(parsed);
				} catch(error:String) { trace(error, x); }
			},
			parameters,
			function(x) {
				try { 
					var parsed = Json.parse(x);
					onError(parsed);
				} catch(error:String) { trace(error, x); }	
			}
		);
		#end
	}

	public function get(
		resource : String,
		onComplete : Dynamic->Void = null,
		parameters : Map<String, String> = null,
		onError : Dynamic->Void = null
	) : Void {

		if (onComplete==null) {
			onComplete = function(s) {};
		}
		if (parameters==null) {
			parameters = new Map<String, String>();
		}
		if (onError==null) {
			onError = function(s) {};
		}
		parameters.set("redirect", "false");
		#if android
		FacebookCFFI.graphRequest(
			prependSlash(resource),
			parameters,
			"GET",
			function(x) {
				try { 
					var parsed = Json.parse(x);
					onComplete(parsed);
				} catch(error:String) { trace(error, x); }
			},
			function(x){
				try { 
					var parsed = Json.parse(x);
					onError(parsed);
				} catch(error:String) { trace(error, x); }
			}
		);
		#else
		parameters.set("access_token", accessToken);
		RestClient.getAsync(
			"https://graph.facebook.com/v2.4"+prependSlash(resource),
			function(x) {
				try { 
					var parsed = Json.parse(x);
					onComplete(parsed);
				} catch(error:String) { trace(error, x); }		
			},
			parameters,
			function(x) {
				try { 
					var parsed = Json.parse(x);
					onError(parsed);
				} catch(error:String) { trace(error, x); }	
			}
		);
		#end

	}

	// get the full list of some resource (manages paging)
	public function getAll<T>(
		resource : String,
		onComplete : Array<T>->Void,
		parameters : Map<String, String> = null,
		onError : Dynamic->Void = null,
		acum : Array<T> = null,
		after : String = null) {

		if (acum==null) {
			acum = [];
		}
		if (parameters==null) {
			parameters = new Map<String, String>();
		}
		if (after!=null) {
			parameters.set("after", after);
		}
		get(
			prependSlash(resource),
			function (data) {
				for (it in cast(data.data, Array<Dynamic>)) {
					acum.push(it);
				}
				if (data.paging!=null && data.paging.cursors!=null && data.paging.cursors.after!=null) {
					getAll(resource, onComplete, onError, acum, data.paging.cursors.after);
				} else {
					onComplete(acum);
				}
			},
			parameters,
			onError
		);

	}

	public function post(
		resource : String,
		onComplete : Dynamic->Void = null,
		parameters : Map<String, String> = null,
		onError : Dynamic->Void = null
	) : Void {

		if (onComplete==null) {
			onComplete = function(s) {};
		}
		if (parameters==null) {
			parameters = new Map<String, String>();
		}
		if (onError==null) {
			onError = function(s) {};
		}
		parameters.set("redirect", "false");
		#if android
		FacebookCFFI.graphRequest(
			prependSlash(resource),
			parameters,
			"POST",
			function(x) {
				try { 
					var parsed = Json.parse(x);
					onComplete(parsed);
				} catch(error:String) { trace(error, x); }		
			},
			function(x) {
				try { 
					var parsed = Json.parse(x);
					onError(parsed);
				} catch(error:String) { trace(error, x); }	
			}
		);
		#else
		parameters.set("access_token", accessToken);
		RestClient.postAsync(
			"https://graph.facebook.com/v2.4"+prependSlash(resource),
			function(x) {
				try { 
					var parsed = Json.parse(x);
					onComplete(parsed);
				} catch(error:String) { trace(error, x); }		
			},
			parameters,
			function(x) {
				try { 
					var parsed = Json.parse(x);
					onError(parsed);
				} catch(error:String) { trace(error, x); }	
			}
		);
		#end
	}

}
