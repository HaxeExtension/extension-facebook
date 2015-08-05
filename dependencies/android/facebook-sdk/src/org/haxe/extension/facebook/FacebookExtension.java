package org.haxe.extension.facebook;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import java.util.ArrayList;
import org.haxe.extension.Extension;
import org.haxe.lime.HaxeObject;

public class FacebookExtension extends Extension {

	CallbackManager callbackManager;

	public FacebookExtension() {
		FacebookSdk.sdkInitialize(mainContext);
		callbackManager = CallbackManager.Factory.create();
		LoginManager.getInstance().registerCallback(callbackManager,
			new FacebookCallback<LoginResult>() {
				@Override
				public void onSuccess(LoginResult loginResult) {
					Log.d("Facebook", "onSucess");
					if (callbacks!=null) {
						callbacks.call0("onLoginSucess");
					}
				}

				@Override
				public void onCancel() {
					Log.d("Facebook", "onCancel");
					if (callbacks!=null) {
						callbacks.call0("onLoginCancel");
					}
				}

				@Override
				public void onError(FacebookException exception) {
					Log.d("Facebook", "onError");
					if (callbacks!=null) {
						callbacks.call0("onLoginError");
					}
				}
		});
	}

	// Static methods interface

	static HaxeObject callbacks;

	public static void setCallBackObject(HaxeObject _callbacks) {
		callbacks = _callbacks;
	}

	public static void init(){
		LoginManager.getInstance().logInWithReadPermissions(mainActivity, new ArrayList<String>());
	}

	// !Static methods interface

	@Override public void onCreate (Bundle savedInstanceState) {

	}

	@Override public boolean onActivityResult (int requestCode, int resultCode, Intent data) {
		callbackManager.onActivityResult(requestCode, resultCode, data);
		return true;
	}

}
