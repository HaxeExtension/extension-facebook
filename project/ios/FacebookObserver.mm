#import <Facebook.h>
#import <FacebookObserver.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation FacebookObserver

- (void)observeTokenChange:(NSNotification *)notfication {
	if ([FBSDKAccessToken currentAccessToken]!=nil) {
		exension_facebook::onTokenChange([[FBSDKAccessToken currentAccessToken].tokenString UTF8String]);
	} 
}

@end
