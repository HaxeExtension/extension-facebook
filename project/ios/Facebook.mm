#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

namespace exension_facebook {

	void login() {
		FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
		[login logInWithReadPermissions:@[@"public_profile"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
			if (error) {
				// Process error
				NSLog(@"Error");
			} else if (result.isCancelled) {
				// Handle cancellations
				NSLog(@"Cancel");
			} else {
				// If you ask for multiple permissions at once, you
				// should check if specific permissions missing
				NSLog(@"Ok");
			}
		}];
	}

}
