#import <FacebookAppDelegate.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <facebook.h>

namespace exension_facebook {

	void login() {

		[UIApplication sharedApplication].delegate = [[FacebookAppDelegate alloc] init];

		FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
		[login logInWithReadPermissions:@[@"public_profile"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
			if (error) {
				// Process error
				NSLog(@"Error");
				onLoginErrorCallback([error.localizedDescription UTF8String]);
			} else if (result.isCancelled) {
				// Handle cancellations
				NSLog(@"Cancel");
				onLoginCancelCallback();
			} else {
				// If you ask for multiple permissions at once, you
				// should check if specific permissions missing
				NSLog(@"Ok");
				onLoginSuccessCallback([result.token.tokenString UTF8String]);
			}
		}];
	}

}
