package extension.facebookrest.android;

import extension.util.task.*;

class FacebookCallbacks extends TaskExecutor {

	public function new() {
		super();
	}

	public var onLoginSucess : String->Void;
	public var onLoginCancel : Void->Void;
	public var onLoginError : Void->Void;

	function _onLoginSucess(token : String) {
		trace("sucess: " + token + ", function: " + onLoginSucess);
		if (onLoginSucess!=null) {
			addTask(new CallStrTask(onLoginSucess, token));
		}
	}

	function _onLoginCancel() {
		trace("cancel");
		if (onLoginCancel!=null) {
			onLoginCancel();
		}
	}

	function _onLoginError() {
		trace("error");
		if (onLoginError!=null) {
			onLoginError();
		}
	}

}
