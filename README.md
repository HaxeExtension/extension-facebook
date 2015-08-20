# extension-facebook
Haxe OpenFL extension for Facebook, supports Facebook SDK for Android and iOS. On other platforms uses Facebook REST API and logins using a Webview.

# Usage example

Login the user to Facebook if needed:
```Haxe
var facebook = new Facebook();
if (facebook.accessToken!="") { // Only login if the user is not already logged in
  onLoggedIn();
} else {
  facebook.login(               // Show login dialog
    PermissionsType.Read,
    ["email", "user_likes"],
    onLoggedIn,
    onCancel,
    onError
  );
}
```

Send app invite:
```Haxe
// See https://developers.facebook.com/docs/applinks
AppInvite.invite("https://fb.me/1654475341456363");
```

Share a link on the users timeline:
```Haxe
Share.link(
  "<a link to something>",
  "<title>",
  "<link to an image>",
  "<description>"
);
```

Grap API:
```Haxe
facebook.get(
  "/me/permissions",  // Graph API endpoint
  onSuccess,  // Dynamic->Void
  onError     // Dynamic->Void
);
```
