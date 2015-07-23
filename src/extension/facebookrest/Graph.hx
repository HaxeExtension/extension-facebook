package extension.facebookrest;

import extension.facebookrest.task.CallStrTask;
import extension.facebookrest.task.CallTask;
import extension.facebookrest.task.Task;
import flash.Lib;
import flash.net.URLRequest;
import sys.net.Host;
import sys.net.Socket;

#if cpp
import cpp.vm.Mutex;
import cpp.vm.Thread;
#else
import neko.vm.Mutex;
import neko.vm.Thread;
#end

class Graph {

	var taskList : List<Task>;
	var taskListMutex : Mutex;

	public function new() {
		taskList = new List<Task>();
		taskListMutex = new Mutex();
		var timer = new haxe.Timer(100);
		timer.run = update;
	}

	public function login(appID : String, onSuccess : String->Void, onFailure : Void -> Void) {

		var redirectUri = "http://localhost:8100";
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
							if (!~/error=+/.match(str)) error = false;
							var get = str.split(" ")[1];
							var code = ~/.*code=/.replace(str, "");
							code = code.split("&")[0];
							code = code.split(" ")[0];
							taskListMutex.acquire();
							if (!error) {
								taskList.add(new CallStrTask(onSuccess, code));
							} else {
								taskList.add(new CallTask(onFailure));
							}
							taskListMutex.release();

						}
					}
					c.write(error?getErrorHTML():getSuccessHTML());
					c.close();
					stopSrvLoop = true;
				}
			} while (!stopSrvLoop);
			s.close();
		});

		Lib.getURL(new URLRequest(url));

	}

	function update() {
		taskListMutex.acquire();
		var next = taskList.pop();
		taskListMutex.release();
		if (next!=null) {
			next._do();
		}
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

}
