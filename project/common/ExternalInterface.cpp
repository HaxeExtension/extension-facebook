#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <hx/CFFI.h>
#include <hxcpp.h>

#include <facebook.h>

#define safe_alloc_string(a) (alloc_string(a!=NULL ? a : ""))

AutoGCRoot* _onLoginSuccessCallback;
AutoGCRoot* _onLoginCancelCallback;
AutoGCRoot* _onLoginErrorCallback;

void exension_facebook::onLoginSuccessCallback(const char *token) {
	if (_onLoginSuccessCallback==NULL) {
		return;
	}
	val_call1(_onLoginSuccessCallback->get(), safe_alloc_string(token));
}

void exension_facebook::onLoginCancelCallback() {
	if (_onLoginCancelCallback==NULL) {
		return;
	}
	val_call0(_onLoginCancelCallback->get());
}

void exension_facebook::onLoginErrorCallback(const char *error) {
	if (_onLoginErrorCallback==NULL) {
		return;
	}
	val_call1(_onLoginErrorCallback->get(), safe_alloc_string(error));
}

static value extension_facebook_login() {
	exension_facebook::login();
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_login, 0);

static value extension_facebook_setOnLoginSuccessCallback(value fun) {
	_onLoginSuccessCallback = new AutoGCRoot(fun);
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_setOnLoginSuccessCallback, 1);

static value extension_facebook_setOnLoginCancelCallback(value fun) {
	_onLoginCancelCallback = new AutoGCRoot(fun);
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_setOnLoginCancelCallback, 1);

static value extension_facebook_setOnLoginErrorCallback(value fun) {
	_onLoginErrorCallback = new AutoGCRoot(fun);
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_setOnLoginErrorCallback, 1);

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
