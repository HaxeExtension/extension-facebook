package extension.facebook.rest_client.non_openfl;

import haxe.Http;
import haxe.io.BytesOutput;

/**
 * ...
 * @author TABIV
 */
class RestClient
{
    public static function postAsync(url:String, onData:String->Void = null, parameters:Map < String, String > = null, onError:String->Void = null):Void
    {
        var r = RestClient.buildHttpRequest(
            url,
            parameters,
            true,
            onData,
            onError);
        r.request(true);
    }
    
    // No synchronous requests/sockets on Flash
    #if !flash
    public static function post(url:String, parameters:Map<String, String> = null, onError:String->Void = null):String
    {
        var result:String;
        var http = RestClient.buildHttpRequest(
            url,
            parameters,
            false,
            function(data:String)
            {
                result = data;
            },
            onError);

        // Use the existing http.request only if sys isn't present
        #if sys
            return makeSyncRequest(http, "POST");
        #else
            http.request(true);
            return result;
        #end
    }
    #end
    
    public static function getAsync(url:String, onData:String->Void = null, parameters:Map < String, String > = null, onError:String->Void = null):Void
    {
        var r = RestClient.buildHttpRequest(
            url,
            parameters,
            true,
            onData,
            onError);
        r.request(false);
    }
    
    // No synchronous requests/sockets on Flash
    #if !flash
    public static function get(url:String, parameters:Map<String, String> = null, onError:String->Void = null):String
    {
        var result:String;

        var http = RestClient.buildHttpRequest(
            url,
            parameters,
            false,
            function(data:String)
            {
                result = data;
            },
            onError);
        
        // Use the existing http.request only if sys isn't present
        #if sys
            return makeSyncRequest(http, "GET");
        #else
            http.request(false);
            return result;
        #end
    }
    #end
    
    #if sys
    private static function makeSyncRequest(http:Http, method:String = "GET"):String
    {
        // TODO: SSL for HTTPS URLs
        var output = new BytesOutput();
        http.customRequest(false, output, null, method);
        return output.getBytes()
            .toString();
    }
    #end
    
    private static function buildHttpRequest(url:String, parameters:Map<String, String> = null, async:Bool = false, onData:String->Void = null, onError:String->Void = null):Http
    {
        var http = new Http(url);
            
        #if js
        http.async = async;
        #end
        
        if (onError != null)
        {
            http.onError = onError;
        }
        
        if (onData != null)
        {
            http.onData = onData;
        }
        
        if (parameters != null)
        {
            for (x in parameters.keys())
            {
                http.setParameter(x, parameters.get(x));
            }
        }
        
        #if flash
        // Disable caching
        http.setParameter("_nocache", Std.string(Date.now().getTime()));
        #end
        
        return http;
    }
}
