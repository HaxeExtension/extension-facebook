#import <CallbacksDelegate.h>
#import <Facebook.h>
#import <FBSDKShareKit/FBSDKAppInviteDialog.h>
#import <FBSDKShareKit/FBSDKGameRequestDialog.h>
#import <FBSDKShareKit/FBSDKSharing.h>
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>
#import <UIKit/UIKit.h>

@implementation NMEAppDelegate (CallbacksDelegate)

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	NSLog(@"openURL");
	return [[FBSDKApplicationDelegate sharedInstance] application:application
									openURL:url
									sourceApplication:sourceApplication
									annotation:annotation];
}

@end

@implementation CallbacksDelegate

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
		extension_facebook::onAppRequestFail([[error localizedDescription] UTF8String]);
	} else {
		//NSLog([[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
		extension_facebook::onAppRequestComplete(
			[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] UTF8String]
		);
	}
}

- (void)gameRequestDialogDidCancel:(FBSDKGameRequestDialog *)gameRequestDialog {
	extension_facebook::onAppRequestFail("{\"error\" : \"Cancelled by user\"}");
}

- (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didFailWithError:(NSError *)error {
	extension_facebook::onAppRequestFail([[error localizedDescription] UTF8String]);
}

// Share dialog callbacks:

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
	NSError *error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:results
											options:0
											error:&error];
	if (results==nil || [results count]==0) {
		if (error) {
			extension_facebook::onShareFail([[error localizedDescription] UTF8String]);
		} else {
			extension_facebook::onShareFail("{\"error\" : \"Cancelled by user\"}");
		}
	} else {
		//NSLog([[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
		extension_facebook::onShareComplete(
			[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] UTF8String]
		);
	}
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
	extension_facebook::onShareFail([[error localizedDescription] UTF8String]);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
	extension_facebook::onShareFail("{\"error\" : \"Cancelled by user\"}");
}

@end
