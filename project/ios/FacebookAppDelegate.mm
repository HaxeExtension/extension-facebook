#import <Facebook.h>
#import <FacebookAppDelegate.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Foundation/Foundation.h>

@implementation FacebookAppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	return [[FBSDKApplicationDelegate sharedInstance] application:application
									openURL:url
									sourceApplication:sourceApplication
									annotation:annotation];
}

// App Invite dialog callbacks:

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults: (NSDictionary *)results {
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:results
											options:0
											error:&error];
	if (!jsonData) {
		extension_facebook::onAppInviteFail([[error localizedDescription] UTF8String]);
	} else {
		extension_facebook::onAppInviteComplete(
			[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] UTF8String]
		);
	}
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error {
	extension_facebook::onAppInviteFail([[error localizedDescription] UTF8String]);
}

// Game Invite dialog callbacks:

- (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didCompleteWithResults:(NSDictionary *)results {
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:results
											options:0
											error:&error];
	if (!jsonData) {
		extension_facebook::onAppRequestComplete([[error localizedDescription] UTF8String]);
	} else {
		NSLog([[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
		extension_facebook::onAppRequestComplete(
			[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] UTF8String]
		);
	}
}

- (void)gameRequestDialogDidCancel:(FBSDKGameRequestDialog *)gameRequestDialog {
	extension_facebook::onAppRequestFail("Game request cancelled by user");
}

- (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didFailWithError:(NSError *)error {
	extension_facebook::onAppRequestFail([[error localizedDescription] UTF8String]);
}

@end
