#import <FacebookAppDelegate.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation FacebookAppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	return [[FBSDKApplicationDelegate sharedInstance] application:application
														openURL:url
														sourceApplication:sourceApplication
														annotation:annotation];
}



@end
