package extension.facebookrest;

#if openfl

typedef RestClient = extension.facebookrest.rest_client.openfl.RestClient;

#else

typedef RestClient = extension.facebookrest.rest_client.non_openfl.RestClient;

#end
