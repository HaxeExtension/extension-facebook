package extension.facebookrest.android;

import extension.util.task.*;

class FacebookCallbacks extends TaskExecutor {

	public function new() {
		super();
	}

	public var onTokenChange : String->Void;
	public var onLoginSucess : Void->Void;
	public var onLoginCancel : Void->Void;
	public var onLoginError : String->Void;

	function _onTokenChange(token : String) {
		if (onTokenChange!=null) {
			onTokenChange(token);
		}
	}

	function _onLoginSucess() {
		if (onLoginSucess!=null) {
			addTask(new CallTask(onLoginSucess));
		}
	}

	function _onLoginCancel() {
		if (onLoginCancel!=null) {
			addTask(new CallTask(onLoginCancel));
		}
	}

	function _onLoginError(str : String) {
		if (onLoginError!=null) {
			addTask(new CallStrTask(onLoginError, str));
		}
	}

}
