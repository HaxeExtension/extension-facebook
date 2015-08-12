#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <hx/CFFI.h>
#include <hxcpp.h>

#include <facebook.h>

static value extension_facebook_login() {
	exension_facebook::login();
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_login, 0);

static value extension_facebook_appInvite(value appLinkUrl, value previewImageUrl) {
	printf("app Invite\n");
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_appInvite, 2);

static value extension_facebook_shareLink(value url) {
	printf("share link\n");
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_shareLink, 1);

extern "C" void extension_facebook_main () {
	val_int(0); // Fix Neko init
}
DEFINE_ENTRY_POINT (extension_facebook_main);

extern "C" int extension_facebook_register_prims () { return 0; }
