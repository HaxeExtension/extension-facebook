package extension.facebookrest.rest_client.openfl;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

class RestClient {

	public static function postAsync(
		url : String,
		onData:String->Void = null,
		parameters:Map<String, String> = null,
		onError:String->Void = null
	) : Void {
		req(url, onData, parameters, onError, URLRequestMethod.POST);
	}
	
	public static function getAsync(
		url : String,
		onData : String->Void = null,
		parameters : Map<String, String> = null,
		onError : String->Void = null
	) : Void {
		req(url, onData, parameters, onError, URLRequestMethod.GET);		
	}

	static function req(
		url : String,
		onData : String->Void = null,
		parameters : Map<String, String> = null,
		onError:String->Void = null,
		method : String
	) : Void {

		var ldr = new URLLoader();
		var req = new URLRequest();
		req.method = method;
		if (parameters!=null) {
			var vars = new URLVariables();
			for (x in parameters.keys()) {
				vars.x = parameters.get(x);
			}
			req.data = vars;
		}
		if (onData!=null) {
			ldr.addEventListener(Event.COMPLETE, function(e : Event) {
				onData(e.target.data);
			});
		}
		if (onError!=null) {
			ldr.addEventListener(IOErrorEvent.IO_ERROR, function(e) onError(e.data));
		}
		req.url = url;
		ldr.load(req);

	}

}
