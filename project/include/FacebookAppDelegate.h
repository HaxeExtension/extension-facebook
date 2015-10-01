#import <FBSDKShareKit/FBSDKAppInviteDialog.h>
#import <FBSDKShareKit/FBSDKGameRequestDialog.h>
#import <FBSDKShareKit/FBSDKSharing.h>
#import <UIKit/UIKit.h>

@class ProxiedDelegate;

@interface ProxiedDelegate : NSObject <UIApplicationDelegate>

@end


@class FacebookAppDelegate;

@interface FacebookAppDelegate : NSProxy <UIApplicationDelegate>

@property (nonatomic, strong, readonly) ProxiedDelegate *proxied;
@property (nonatomic, strong, readonly) NSObject *object;
- (instancetype)initWithObject:(NSObject *)object;

@end
