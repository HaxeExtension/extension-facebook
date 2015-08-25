package extension.facebook.android;

import extension.util.task.*;

class FacebookCallbacks extends TaskExecutor {

	public function new() {
		super();
	}

	public var onTokenChange : String->Void;
	public var onLoginSucess : Void->Void;
	public var onLoginCancel : Void->Void;
	public var onLoginError : String->Void;
	public var onAppInviteComplete : String->Void;
	public var onAppInviteFail : String->Void;

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

	function _onAppInviteComplete(str : String) {
		if (onAppInviteComplete!=null) {
			addTask(new CallStrTask(onAppInviteComplete, str));
		}
	}

	function _onAppInviteFail(str : String) {
		if (onAppInviteFail!=null) {
			addTask(new CallStrTask(onAppInviteFail, str));
		}
	}

}
