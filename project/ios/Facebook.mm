#import <FacebookAppDelegate.h>
#import <FacebookObserver.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <Facebook.h>

namespace exension_facebook {

	FBSDKLoginManager *login;

	void init() {
		NSLog(@"Call init");
		[UIApplication sharedApplication].delegate = [[FacebookAppDelegate alloc] init];
		
		[[NSNotificationCenter defaultCenter]
			addObserver:[[FacebookObserver alloc] init]
			selector:@selector(observeTokenChange:)
			name:FBSDKAccessTokenDidChangeNotification
			object:nil
		];
	}

	void logInWithReadPermissions(std::vector<std::string> &permissions) {
		
		if (login==NULL) {
			login = [[FBSDKLoginManager alloc] init];
		}

		NSMutableArray *nsPermissions = [[NSMutableArray alloc] init];
		for (auto p : permissions) {
			[nsPermissions addObject:[NSString stringWithUTF8String:p.c_str()]];
		}

		[login logInWithReadPermissions:nsPermissions handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
			if (error) {
				onLoginErrorCallback([error.localizedDescription UTF8String]);
			} else if (result.isCancelled) {
				onLoginCancelCallback();
			} else {
				onLoginSuccessCallback();
			}
		}];

	}

}
