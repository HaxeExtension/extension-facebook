#import <FBSDKShareKit/FBSDKAppInviteDialog.h>
#import <FBSDKShareKit/FBSDKGameRequestDialog.h>
#import <FBSDKShareKit/FBSDKSharing.h>
#import <UIKit/UIKit.h>

@class FacebookAppDelegate;

@interface FacebookAppDelegate : NSObject <
	FBSDKAppInviteDialogDelegate,
	FBSDKGameRequestDialogDelegate,
	FBSDKSharingDelegate,
	UIApplicationDelegate
>

@end
