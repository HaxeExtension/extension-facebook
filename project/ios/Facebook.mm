#import <FacebookAppDelegate.h>
#import <FacebookObserver.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKAppInviteContent.h>
#import <FBSDKShareKit/FBSDKAppInviteDialog.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>

#import <Facebook.h>

namespace extension_facebook {

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

	void appInvite(std::string appLinkUrl, std::string previewImageUrl) {

		FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
		content.appLinkURL = [NSURL URLWithString:[NSString stringWithUTF8String:appLinkUrl.c_str()]];
		if (previewImageUrl!="") {
			content.appInvitePreviewImageURL = [NSURL URLWithString:[NSString stringWithUTF8String:previewImageUrl.c_str()]];
		}

		FBSDKAppInviteDialog *dialog = [[FBSDKAppInviteDialog alloc] init];
		dialog.content = content;
		[dialog show];

	}

	void shareLink(
		std::string contentURL,
		std::string contentTitle,
		std::string imageURL,
		std::string contentDescription) {

		FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
		content.contentURL = [NSURL URLWithString:[NSString stringWithUTF8String:contentURL.c_str()]];
		if (contentTitle!="") {
			content.contentTitle = [NSString stringWithUTF8String:contentTitle.c_str()];
		}
		if (imageURL!="") {
			content.imageURL = [NSURL URLWithString:[NSString stringWithUTF8String:imageURL.c_str()]];
		}
		if (contentDescription!="") {
			content.contentDescription = [NSString stringWithUTF8String:contentDescription.c_str()];
		}

		[FBSDKShareDialog
			showFromViewController:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]
			withContent:content
			delegate:nil
		];

	}

}
