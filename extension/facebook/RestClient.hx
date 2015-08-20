package extension.facebook;

#if openfl

typedef RestClient = extension.facebook.rest_client.openfl.RestClient;

#else

typedef RestClient = extension.facebook.rest_client.non_openfl.RestClient;

#end
