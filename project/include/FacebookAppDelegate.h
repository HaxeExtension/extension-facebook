#import <FBSDKShareKit/FBSDKAppInviteDialog.h>
#import <FBSDKShareKit/FBSDKGameRequestDialog.h>
#import <UIKit/UIKit.h>

@class FacebookAppDelegate;

@interface FacebookAppDelegate : NSObject <
	UIApplicationDelegate,
	FBSDKAppInviteDialogDelegate,
	FBSDKGameRequestDialogDelegate
>

@end
