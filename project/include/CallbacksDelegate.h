#import <FBSDKShareKit/FBSDKAppInviteDialog.h>
#import <FBSDKShareKit/FBSDKGameRequestDialog.h>
#import <FBSDKShareKit/FBSDKSharing.h>

@class CallbacksDelegate;

@interface CallbacksDelegate : NSObject <
	FBSDKAppInviteDialogDelegate,
	FBSDKGameRequestDialogDelegate,
	FBSDKSharingDelegate
>

@end

@interface NMEAppDelegate : NSObject <UIApplicationDelegate>
@end
