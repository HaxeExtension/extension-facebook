package extension.facebookrest;

#if android
import extension.facebookrest.android.FacebookCallbacks;
import extension.facebookrest.android.FacebookExtension;
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

class Graph extends TaskExecutor {

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
		FacebookExtension.setCallBackObject(callbacks);
		FacebookExtension.init();

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
					c.write(error?getErrorHTML():getSuccessHTML());
					c.close();
					stopSrvLoop = true;
				}
			} while (!stopSrvLoop);
			s.close();
		});

		Lib.getURL(new URLRequest(url));

		#end

	}

	private function getSuccessHTML():String {
		return '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
				<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
				<head>
					<title>Facebook Graph API - Login Successful</title>
					<meta name="viewport" content="width=device-width, height=device-height, initial-scale=0.8, maximum-scale=0.8,user-scalable=no" />
				</head>
				<body style="background-color:#ffffff;margin: 0;padding: 0;border: 0;">

				<table style="width:100%;position:absolute;height:100%;margin:auto 0"><tr>
					<td valign="center">
						<center>
						<h1>LOGIN SUCCESSFUL</h1>
						<p>You can now close this browser...</p>
						</center>
					</td>
				</tr></table>

				<script type="text/javascript">
				//window.open("","_self").close();
				</script>

				</body>
				</html>';
	}

	private function getErrorHTML():String {
		return '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
				<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
				<head>
					<title>Facebook Graph API - Login Error</title>
					<meta name="viewport" content="width=device-width, height=device-height, initial-scale=0.8, maximum-scale=0.8,user-scalable=no" />
				</head>
				<body style="background-color:#ffffff;margin: 0;padding: 0;border: 0;">

				<table style="width:100%;position:absolute;height:100%;margin:auto 0"><tr>
					<td valign="center">
						<center>
						<h1>LOGIN ERROR</h1>
						<p>
						There was an error dungin the login.
						<br/>
						<strong>Don\'t panic:</strong> This is not really needed to play this game :)
						<br/>
						<br/>
						<i>You can close this browser and begin to play without Google Play Games (or you can retry later if you wish).</i>
						</p>
						</center>
					</td>
				</tr></table>

				<script type="text/javascript">
				//window.open("","_self").close();
				</script>

				</body>
				</html>';
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
