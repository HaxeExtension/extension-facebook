#include <string>
#include <vector>

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
		std::string contentDescription);

	void onTokenChange(const char *token);
	void onLoginSuccessCallback();
	void onLoginCancelCallback();
	void onLoginErrorCallback(const char *error);

}
