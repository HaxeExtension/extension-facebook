#import <UIKit/UIKit.h>

@class FacebookObserver;

@interface FacebookObserver : NSObject

- (void)observeTokenChange:(NSNotification *)notfication;

@end
