#import <UIKit/UIKit.h>

@class FacebookObserver;

@interface FacebookObserver : NSObject

- (void)observeTokenChange:(NSNotification *)notification;

@end
