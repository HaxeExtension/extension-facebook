package org.haxe.extension.facebook;

import android.util.Log;

import com.facebook.FacebookSdk;
import com.facebook.login.LoginManager;
import java.util.ArrayList;
import org.haxe.extension.Extension;
import org.haxe.lime.HaxeObject;

public class FacebookExtension extends Extension {

	public FacebookExtension() {
		Log.d("Facebook", "Initialize SDK =)");
		FacebookSdk.sdkInitialize(mainContext);
		Log.d("Facebook", "POST Initialize SDK =)");
	}

	// Static methods interface

	public static void init(){
		Log.d("Facebook", "holis!");
		LoginManager.getInstance().logInWithReadPermissions(mainActivity, new ArrayList<String>());
	}

	// !Static methods interface
/*
	@Override public void onCreate (Bundle savedInstanceState) {
		
	}
*/
/*
	@Override public boolean onActivityResult (int requestCode, int resultCode, Intent data) {
		return true;
	}
*/
}
