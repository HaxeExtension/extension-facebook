#import <FacebookAppDelegate.h>
#import <FacebookObserver.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <Facebook.h>

namespace exension_facebook {

	FBSDKLoginManager *login;

	void init() {
		[UIApplication sharedApplication].delegate = [[FacebookAppDelegate alloc] init];
		FacebookObserver *obs = [[FacebookObserver alloc] init];
		[[FBSDKApplicationDelegate sharedInstance] application:[UIApplication sharedApplication]
									didFinishLaunchingWithOptions:[[NSMutableDictionary alloc] init]];
		[obs observeTokenChange:nil];
		[[NSNotificationCenter defaultCenter]
			addObserver:obs
			selector:@selector(observeTokenChange:)
			name:FBSDKAccessTokenDidChangeNotification
			object:nil
		];
	}

	void logOut() {
		[login logOut];
	}

	void logInWithPublishPermissions(std::vector<std::string> &permissions) {
		if (login==NULL) {
			login = [[FBSDKLoginManager alloc] init];
		}
		NSMutableArray *nsPermissions = [[NSMutableArray alloc] init];
		for (auto p : permissions) {
			[nsPermissions addObject:[NSString stringWithUTF8String:p.c_str()]];
		}
		[login logInWithPublishPermissions:nsPermissions handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
			if (error) {
				onLoginErrorCallback([error.localizedDescription UTF8String]);
			} else if (result.isCancelled) {
				onLoginCancelCallback();
			} else {
				onLoginSuccessCallback();
			}
		}];
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
