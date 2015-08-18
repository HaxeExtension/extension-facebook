#include <string>
#include <vector>

namespace exension_facebook {

	void init();
	void logOut();

	void logInWithPublishPermissions(std::vector<std::string> &permissions);
	void logInWithReadPermissions(std::vector<std::string> &permissions);

	void onTokenChange(const char *token);

	void onLoginSuccessCallback();
	void onLoginCancelCallback();
	void onLoginErrorCallback(const char *error);

}
