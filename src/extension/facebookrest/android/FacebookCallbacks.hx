package extension.facebookrest.android;

class FacebookCallbacks {

	public function new() {}

	public function onLoginSucess() {
		trace("sucess");
	}

	public function onLoginCancel() {
		trace("cancel");
	}

	public function onLoginError() {
		trace("error");
	}

}
