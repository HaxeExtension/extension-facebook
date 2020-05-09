package extension.facebook.rest_client.openfl;

import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

class RestClient {

	public static function deleteAsync(
		url : String,
		onData:String->Void = null,
		parameters:Map<String, String> = null,
		onError:String->Void = null
	) : Void {
		req(url, onData, parameters, onError, URLRequestMethod.DELETE);
	}

	public static function getAsync(
		url : String,
		onData : String->Void = null,
		parameters : Map<String, String> = null,
		onError : String->Void = null
	) : Void {
		req(url, onData, parameters, onError, URLRequestMethod.GET);
	}

	public static function postAsync(
		url : String,
		onData:String->Void = null,
		parameters:Map<String, String> = null,
		onError:String->Void = null
	) : Void {
		req(url, onData, parameters, onError, URLRequestMethod.POST);
	}

	static function req(
		url : String,
		onData : String->Void = null,
		parameters : Map<String, String> = null,
		onError:String->Void = null,
		method : String
	) : Void {

		trace("CREANDO URLLOADER!!!!!!! ");
		trace("CREANDO URLLOADER!!!!!!! ");
		trace("CREANDO URLLOADER!!!!!!! ");
		trace("CREANDO URLLOADER!!!!!!! ");
		trace("CREANDO URLLOADER!!!!!!! ");
		trace("CREANDO URLLOADER!!!!!!! ");
		trace("CREANDO URLLOADER!!!!!!! ");
		trace("CREANDO URLLOADER!!!!!!! ");
		
		var ldr = new URLLoader();
		var req = new URLRequest();
		req.method = method;
		if (parameters!=null) {
			if (method==URLRequestMethod.POST) {
				var vars = new URLVariables();
				for (x in parameters.keys()) {
					Reflect.setField(vars, x, parameters.get(x));
				}
				req.data = vars;
			} else {
				var s = "";
				for (x in parameters.keys()) {
					s += x + "=" + parameters.get(x) + "&";
				}
				if (StringTools.endsWith(s, "&")) {
					s = s.substr(0, s.length-1);
				}
				if (s!="") {
					url += "?" + s;
				}
			}
		}
		if (onData!=null) {
			ldr.addEventListener(Event.COMPLETE, function(e : Event) {
				onData(ldr.data);
			});
		}
		if (onError!=null) {
			ldr.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(c : HTTPStatusEvent) {
				if(c.status!=200) {
					onError(ldr.data);
				}
			});
		}
		req.url = url;
		ldr.load(req);

	}

}
