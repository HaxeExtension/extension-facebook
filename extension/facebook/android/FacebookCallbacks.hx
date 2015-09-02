package extension.facebook.android;

import extension.util.task.*;

class FacebookCallbacks extends TaskExecutor {

	public var onTokenChange : String->Void;

	public var onLoginSucess : Void->Void;
	public var onLoginCancel : Void->Void;
	public var onLoginError : String->Void;

	public var onAppInviteComplete : String->Void;
	public var onAppInviteFail : String->Void;

	public var onAppRequestComplete : String->Void;
	public var onAppRequestFail : String->Void;

	public var graphCallbacks : Map<Int, { onComplete : String->Void, onFail : String->Void }>;

	public function new() {
		super();
		graphCallbacks = new Map<Int, { onComplete : String->Void, onFail : String->Void }>();
	}

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

	function _onAppRequestComplete(str : String) {
		if (onAppRequestComplete!=null) {
			addTask(new CallStrTask(onAppRequestComplete, str));
		}
	}

	function _onAppRequestFail(str : String) {
		if (onAppRequestFail!=null) {
			addTask(new CallStrTask(onAppRequestFail, str));
		}
	}

	function onGraphCallback(status : String, data : String, id : Int) {
		var gCallback = graphCallbacks.get(id);
		if (status!="error") {
			if (gCallback.onComplete!=null) {
				addTask(new CallStrTask(gCallback.onComplete, data));
			}
		} else {
			if (gCallback.onFail!=null) {
				addTask(new CallStrTask(gCallback.onFail, data));
			}
		}
		graphCallbacks.remove(id);
	}

}
