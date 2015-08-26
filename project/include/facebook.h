#include <string>
#include <vector>

#ifndef _FACEBOOK_H_
#define _FACEBOOK_H_

namespace extension_facebook {

	void init();
	void logOut();

	void logInWithPublishPermissions(std::vector<std::string> &permissions);
	void logInWithReadPermissions(std::vector<std::string> &permissions);

	void appInvite(std::string appLinkUrl, std::string previewImageUrl);

	void shareLink(
		std::string contentURL,
		std::string contentTitle,
		std::string imageURL,
		std::string contentDescription
	);

	void gameRequestSend(
		std::string message,
		std::string title,
		std::vector<std::string> &recipients,
		std::string objectId
	);

	void onTokenChange(const char *token);
	void onLoginSuccessCallback();
	void onLoginCancelCallback();
	void onLoginErrorCallback(const char *error);
	void onAppInviteComplete(const char *json);
	void onAppInviteFail(const char *error);

}

#endif
