#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <hx/CFFI.h>
#include <hxcpp.h>

#include <string>
#include <vector>

#include <Facebook.h>

#define safe_alloc_string(a) (alloc_string(a!=NULL ? a : ""))
#define safe_val_call0(func) if (func!=NULL) val_call0(func->get())
#define safe_val_call1(func, arg1) if (func!=NULL) val_call1(func->get(), arg1)
#define safe_val_string(str) str==NULL ? "" : std::string(val_string(str))

AutoGCRoot* _onTokenChange;
AutoGCRoot* _onLoginSuccessCallback;
AutoGCRoot* _onLoginCancelCallback;
AutoGCRoot* _onLoginErrorCallback;
AutoGCRoot* _onAppInviteComplete;
AutoGCRoot* _onAppInviteFail;
AutoGCRoot* _onAppRequestComplete;
AutoGCRoot* _onAppRequestFail;
AutoGCRoot* _onShareComplete;
AutoGCRoot* _onShareFail;

void extension_facebook::onTokenChange(const char *token) {
	safe_val_call1(_onTokenChange, safe_alloc_string(token));
}

void extension_facebook::onLoginSuccessCallback() {
	safe_val_call0(_onLoginSuccessCallback);
}

void extension_facebook::onLoginCancelCallback() {
	safe_val_call0(_onLoginCancelCallback);
}

void extension_facebook::onLoginErrorCallback(const char *error) {
	safe_val_call1(_onLoginErrorCallback, safe_alloc_string(error));
}

void extension_facebook::onAppInviteComplete(const char *json) {
	safe_val_call1(_onAppInviteComplete, safe_alloc_string(json));
}

void extension_facebook::onAppInviteFail(const char *error) {
	safe_val_call1(_onAppInviteFail, safe_alloc_string(error));
}

void extension_facebook::onAppRequestComplete(const char *json) {
	safe_val_call1(_onAppRequestComplete, safe_alloc_string(json));
}

void extension_facebook::onAppRequestFail(const char *error) {
	safe_val_call1(_onAppRequestFail, safe_alloc_string(error));
}

void extension_facebook::onShareComplete(const char *json) {
	safe_val_call1(_onShareComplete, safe_alloc_string(json));
}

void extension_facebook::onShareFail(const char *error) {
	safe_val_call1(_onShareFail, safe_alloc_string(error));
}

static value extension_facebook_init(value onTokenChange) {
	_onTokenChange = new AutoGCRoot(onTokenChange);
	extension_facebook::init();
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_init, 1);

static value extension_facebook_logout() {
	extension_facebook::logOut();
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_logout, 0);

static value extension_facebook_logInWithPublishPermissions(value permissions) {
	int n = 0;
	if (permissions!=NULL) {
		n = val_array_size(permissions);
	}
	std::vector<std::string> stlPermissions;
	for (int i=0;i<n;++i) {
		std::string str(val_string(val_array_i(permissions, i)));
		stlPermissions.push_back(str);
	}
	extension_facebook::logInWithPublishPermissions(stlPermissions);
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_logInWithPublishPermissions, 1);

static value extension_facebook_logInWithReadPermissions(value permissions) {
	int n = 0;
	if (permissions!=NULL) {
		n = val_array_size(permissions);
	}
	std::vector<std::string> stlPermissions;
	for (int i=0;i<n;++i) {
		std::string str(val_string(val_array_i(permissions, i)));
		stlPermissions.push_back(str);
	}
	extension_facebook::logInWithReadPermissions(stlPermissions);
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_logInWithReadPermissions, 1);

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

static value extension_facebook_setOnAppInviteComplete(value fun) {
	_onAppInviteComplete = new AutoGCRoot(fun);
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_setOnAppInviteComplete, 1);

static value extension_facebook_setOnAppInviteFail(value fun) {
	_onAppInviteFail = new AutoGCRoot(fun);
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_setOnAppInviteFail, 1);

static value extension_facebook_setOnAppRequestComplete(value fun) {
	_onAppRequestComplete = new AutoGCRoot(fun);
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_setOnAppRequestComplete, 1);

static value extension_facebook_setOnAppRequestFail(value fun) {
	_onAppRequestFail = new AutoGCRoot(fun);
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_setOnAppRequestFail, 1);

static value extension_facebook_setOnShareComplete(value fun) {
	_onShareComplete = new AutoGCRoot(fun);
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_setOnShareComplete, 1);

static value extension_facebook_setOnShareFail(value fun) {
	_onShareFail = new AutoGCRoot(fun);
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_setOnShareFail, 1);

static value extension_facebook_appInvite(value appLinkUrl, value previewImageUrl) {
	extension_facebook::appInvite(
		safe_val_string(appLinkUrl),
		safe_val_string(previewImageUrl)
	);
	return alloc_null();
}
DEFINE_PRIM(extension_facebook_appInvite, 2);

static value extension_facebook_shareLink(
	value contentURL,
	value contentTitle,
	value imageURL,
	value contentDescription) {

	extension_facebook::shareLink(
		safe_val_string(contentURL),
		safe_val_string(contentTitle),
		safe_val_string(imageURL),
		safe_val_string(contentDescription)
	);

	return alloc_null();

}
DEFINE_PRIM(extension_facebook_shareLink, 4);

static value extension_facebook_appRequest(value *arg, int count) {

	enum {
		message,
		title,
		recipients,
		objectId,
		actionType,
		data,
		aSIZE
	};

	if (count!=aSIZE) {
		printf("\"extension_facebook_appRequest\" wrong number of params\n");
	}

	int n = 0;
	if (arg[recipients]!=NULL) {
		n = val_array_size(arg[recipients]);
	}
	std::vector<std::string> stlRecipients;
	for (int i=0;i<n;++i) {
		std::string str(val_string(val_array_i(arg[recipients], i)));
		stlRecipients.push_back(str);
	}

	extension_facebook::appRequest(
		safe_val_string(arg[message]),
		safe_val_string(arg[title]),
		stlRecipients,
		safe_val_string(arg[objectId]),
		val_int(arg[actionType]),
		safe_val_string(arg[data])
	);

	return alloc_null();

}
DEFINE_PRIM_MULT(extension_facebook_appRequest);

extern "C" void extension_facebook_main () {
	val_int(0); // Fix Neko init
}
DEFINE_ENTRY_POINT (extension_facebook_main);

extern "C" int extension_facebook_register_prims () {
	extension_facebook::pre_init();
	return 0;
}
