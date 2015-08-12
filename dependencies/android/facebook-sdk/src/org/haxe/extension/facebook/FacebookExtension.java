package org.haxe.extension.facebook;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import com.facebook.AccessToken;
import com.facebook.AccessTokenTracker;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.share.model.AppInviteContent;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.AppInviteDialog;
import com.facebook.share.widget.ShareDialog;
import java.util.ArrayList;
import org.haxe.extension.Extension;
import org.haxe.lime.HaxeObject;

public class FacebookExtension extends Extension {

	AccessTokenTracker accessTokenTracker;
	CallbackManager callbackManager;
	static ShareDialog shareDialog;

	public FacebookExtension() {
		FacebookSdk.sdkInitialize(mainContext);
		callbackManager = CallbackManager.Factory.create();
		shareDialog = new ShareDialog(mainActivity);
		LoginManager.getInstance().registerCallback(callbackManager,
			new FacebookCallback<LoginResult>() {
				@Override
				public void onSuccess(LoginResult loginResult) {
					Log.d("Facebook", "onSucess");
					if (callbacks!=null) {
						callbacks.call1("_onLoginSucess", loginResult.getAccessToken().getToken());
					}
				}

				@Override
				public void onCancel() {
					Log.d("Facebook", "onCancel");
					if (callbacks!=null) {
						callbacks.call0("_onLoginCancel");
					}
				}

				@Override
				public void onError(FacebookException exception) {
					Log.d("Facebook", "onError");
					if (callbacks!=null) {
						callbacks.call0("_onLoginError");
					}
				}
		});
		
		accessTokenTracker = new AccessTokenTracker() {
			@Override
			protected void onCurrentAccessTokenChanged(AccessToken oldAccessToken, AccessToken currentAccessToken) {
				Log.d("Facebook", "Got token: " + currentAccessToken.getToken());
				if (callbacks!=null) {
					callbacks.call1("_onLoginSucess", currentAccessToken.getToken());
				}
			}
		};
		
		AccessToken token = AccessToken.getCurrentAccessToken();
		if (token!=null) {
			Log.d("Facebook", "Token es: " + token.getToken());
		}
		
	}

	// Static methods interface

	static HaxeObject callbacks;

	public static void setCallBackObject(HaxeObject _callbacks) {
		callbacks = _callbacks;
	}

	public static void login(){
		LoginManager.getInstance().logInWithReadPermissions(mainActivity, new ArrayList<String>());
	}
	
	public static void appInvite(String applinkUrl, String previewImageUrl) {
		if (AppInviteDialog.canShow()) {
			AppInviteContent content = new AppInviteContent.Builder()
					.setApplinkUrl(applinkUrl)
					.setPreviewImageUrl(previewImageUrl)
					.build();
			AppInviteDialog.show(mainActivity, content);
		}
	}

	public static void shareLink(String url) {
		ShareLinkContent content = new ShareLinkContent.Builder()
			.setContentUrl(Uri.parse(url))
			.build();
		if (shareDialog!=null) {
			shareDialog.show(content);
		}
	}

	// !Static methods interface

	@Override public void onCreate (Bundle savedInstanceState) {

	}

	@Override public boolean onActivityResult (int requestCode, int resultCode, Intent data) {
		callbackManager.onActivityResult(requestCode, resultCode, data);
		return true;
	}
	
	@Override public void onDestroy() {
		accessTokenTracker.stopTracking();
	}

}
