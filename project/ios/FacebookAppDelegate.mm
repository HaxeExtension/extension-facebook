#import <FacebookAppDelegate.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation FacebookAppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	return [[FBSDKApplicationDelegate sharedInstance] application:application
														openURL:url
														sourceApplication:sourceApplication
														annotation:annotation];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSLog(@"dfkjhsdkf");
	return YES;
}

@end
