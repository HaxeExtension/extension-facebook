namespace exension_facebook {

	void login();

	void onLoginSuccessCallback(const char *token);
	void onLoginCancelCallback();
	void onLoginErrorCallback(const char *error);

}
