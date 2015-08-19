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
import java.util.Arrays;

import org.haxe.extension.Extension;
import org.haxe.lime.HaxeObject;

public class FacebookExtension extends Extension {

	CallbackManager callbackManager;

	static HaxeObject callbacks;
	static AccessTokenTracker accessTokenTracker;
	static ShareDialog shareDialog;

	public FacebookExtension() {
		
		FacebookSdk.sdkInitialize(mainContext);
		callbackManager = CallbackManager.Factory.create();
		shareDialog = new ShareDialog(mainActivity);
		LoginManager.getInstance().registerCallback(callbackManager,
			new FacebookCallback<LoginResult>() {
				@Override
				public void onSuccess(LoginResult loginResult) {
					if (callbacks!=null) {
						callbacks.call0("_onLoginSucess");
					}
				}

				@Override
				public void onCancel() {
					if (callbacks!=null) {
						callbacks.call0("_onLoginCancel");
					}
				}

				@Override
				public void onError(FacebookException exception) {
					if (callbacks!=null) {
						callbacks.call1("_onLoginError", exception.toString());
					}
				}
		});

	}

	// Static methods interface

	public static void init(HaxeObject _callbacks) {

		callbacks = _callbacks;
		
		accessTokenTracker = new AccessTokenTracker() {
			@Override
			protected void onCurrentAccessTokenChanged(AccessToken oldAccessToken, AccessToken currentAccessToken) {
				if (callbacks!=null) {
					callbacks.call1("_onTokenChange", currentAccessToken.getToken());
				}
			}
		};

		AccessToken token = AccessToken.getCurrentAccessToken();
		if (token!=null) {
			callbacks.call1("_onTokenChange", token.getToken());
		}

	}

	public static void logInWithPublishPermissions(String permissions) {
		String[] arr = permissions.split(";");
		LoginManager.getInstance().logInWithPublishPermissions(mainActivity, Arrays.asList(arr));
	}

	public static void logInWithReadPermissions(String permissions) {
		String[] arr = permissions.split(";");
		LoginManager.getInstance().logInWithReadPermissions(mainActivity, Arrays.asList(arr));
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

	public static void shareLink(String contentURL, String contentTitle, String imageURL, String contentDescription) {
		/*
		ShareLinkContent content = new ShareLinkContent.Builder()
			.setContentUrl(Uri.parse(url))
			.build();
		if (shareDialog!=null) {
			shareDialog.show(content);
		}
		*/
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
