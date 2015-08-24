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

- (void)appInviteDialog: (FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults: (NSDictionary *)results {
	NSLog(@"Results: %@", results);
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
	NSLog(@"Error: %@", error);
	extension_facebook::onAppInviteFail([[error localizedDescription] UTF8String]);
}

@end
