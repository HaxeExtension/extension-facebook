#import <UIKit/UIKit.h>

@class FacebookObserver;

@interface FacebookObserver : NSObject

- (void)observeTokenChange:(NSNotification *)notification;
- (void)applicationDidFinishLaunchingNotification:(NSNotification *)notification;

@end
