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
import com.facebook.share.model.GameRequestContent;
import com.facebook.share.model.GameRequestContent.ActionType;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.AppInviteDialog;
import com.facebook.share.widget.GameRequestDialog.Result;
import com.facebook.share.widget.GameRequestDialog;
import com.facebook.share.widget.ShareDialog;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Map;
import java.util.Set;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import org.haxe.extension.Extension;
import org.haxe.lime.HaxeObject;

public class FacebookExtension extends Extension {

	static AccessTokenTracker accessTokenTracker;
	static CallbackManager callbackManager;
	static GameRequestDialog requestDialog;
	static HaxeObject callbacks;
	static ShareDialog shareDialog;

	public FacebookExtension() {

		FacebookSdk.sdkInitialize(mainContext);
		requestDialog = new GameRequestDialog(mainActivity);
		shareDialog = new ShareDialog(mainActivity);

		if (callbackManager!=null) {
			return;
		}

		callbackManager = CallbackManager.Factory.create();

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

		requestDialog.registerCallback(callbackManager, new FacebookCallback<GameRequestDialog.Result>() {

			@Override
			public void onSuccess(Result result) {
				if (callbacks!=null) {
					JSONObject json = new JSONObject();
					try {
						json.put("id", result.getRequestId());
					} catch (JSONException e) {
						Log.d("JSONException", e.toString());
					}
					JSONArray recipients = new JSONArray(result.getRequestRecipients());
					try {
						json.put("recipients", recipients);
					} catch (JSONException e) {
						Log.d("JSONException", e.toString());
					}
					callbacks.call1("_onGameRequestComplete", json.toString());
				}
			}

			@Override
			public void onCancel() {
				if (callbacks!=null) {
					callbacks.call1("_onGameRequestFail", "Cancelled");
				}
			}

			@Override
			public void onError(FacebookException error) {
				if (callbacks!=null) {
					callbacks.call1("_onGameRequestFail", error.toString());
				}
			}

		});

	}

	public static Object wrap(Object o) {
		if (o == null) {
			return null;
		}
		if (o instanceof JSONArray || o instanceof JSONObject) {
			return o;
		}
		if (o.equals(null)) {
			return o;
		}
		try {
			if (o instanceof Collection) {
				return new JSONArray((Collection) o);
			} else if (o.getClass().isArray()) {
				JSONArray arr = new JSONArray();
				for (Object e : (Object[]) o) {
					arr.put(e);
				}
				return arr;
			}
			if (o instanceof Map) {
				return new JSONObject((Map) o);
			}
			if (o instanceof Boolean ||
				o instanceof Byte ||
				o instanceof Character ||
				o instanceof Double ||
				o instanceof Float ||
				o instanceof Integer ||
				o instanceof Long ||
				o instanceof Short ||
				o instanceof String) {
				return o;
			}
			if (o.getClass().getPackage().getName().startsWith("java.")) {
				return o.toString();
			}
		} catch (Exception ignored) {
		}
		return null;
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

	public static void logout() {
		LoginManager.getInstance().logOut();
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
			AppInviteDialog appInviteDialog = new AppInviteDialog(mainActivity);
			appInviteDialog.registerCallback(callbackManager, new FacebookCallback<AppInviteDialog.Result>() {
				@Override
				public void onSuccess(AppInviteDialog.Result result) {
					if (callbacks!=null) {
						Bundle bundle = result.getData();
						JSONObject json = new JSONObject();
						Set<String> keys = bundle.keySet();
						for (String key : keys) {
							try {
								json.put(key, wrap(bundle.get(key)));
							} catch (JSONException e) {
								Log.d("JSONException", e.toString());
							}
						}
						callbacks.call1("_onAppInviteComplete", json.toString());
					}
				}

				@Override
				public void onCancel() {
					if (callbacks!=null) {
						callbacks.call1("_onAppInviteFail", "User canceled");
					}
				}

				@Override
				public void onError(FacebookException e) {
					if (callbacks!=null) {
						callbacks.call1("_onAppInviteFail", e.toString());
					}
				}
			});
			appInviteDialog.show(content);
		}
	}

	public static void shareLink(String contentURL, String contentTitle, String imageURL, String contentDescription) {
		ShareLinkContent.Builder builder = new ShareLinkContent.Builder();
		builder.setContentUrl(Uri.parse(contentURL));
		if (contentTitle!="") {
			builder.setContentTitle(contentTitle);
		}
		if (imageURL!="") {
			builder.setImageUrl(Uri.parse(imageURL));
		}
		if (contentDescription!="") {
			builder.setContentDescription(contentDescription);
		}
		ShareLinkContent content = builder.build();
		if (shareDialog!=null) {
			shareDialog.show(content);
		}
	}

	public static void gameRequestSend(
		String message,
		String title,
		String recipients,
		String objectID,
		int actionType
	) {
		GameRequestContent.Builder builder = new GameRequestContent.Builder();
		builder.setMessage(message);
		builder.setTitle(title);
		if (recipients!="") {
			String[] arr = recipients.split(";");
			if (arr.length>0) {
				builder.setTo(arr[0]);
			}
		}
		if (objectID!="") {
			builder.setObjectId(objectID);
		}
		switch (actionType) {
			case 0:
				builder.setActionType(ActionType.ASKFOR);
				break;
			case 1:
				builder.setActionType(ActionType.SEND);
				break;
			case 2:
				builder.setActionType(ActionType.TURN);
				break;
			default:
				builder.setActionType(ActionType.SEND);
		}
		GameRequestContent content = builder.build();
		if (requestDialog!=null) {
			requestDialog.show(content);
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
