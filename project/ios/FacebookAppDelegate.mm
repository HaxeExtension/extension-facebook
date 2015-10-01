#import <AVFoundation/AVFoundation.h>
#import <FacebookAppDelegate.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Foundation/Foundation.h>

@implementation ProxiedDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	NSLog(@"openURL");
	return [[FBSDKApplicationDelegate sharedInstance] application:application
									openURL:url
									sourceApplication:sourceApplication
									annotation:annotation];
}

@end // ProxiedDelegate

@implementation FacebookAppDelegate

// Begin NSProxy stuff

- (instancetype)initWithObject:(NSObject *)object
{
	NSParameterAssert(object);

	_proxied = [[ProxiedDelegate alloc] init];

	// Don't call [super init], as NSProxy does not recognize -init.
	_object = object;

	return self;

}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
	return [self.object methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{

	if ([self.object respondsToSelector:invocation.selector]) {
		[invocation invokeWithTarget:self.object];
	}

	if ([self.proxied respondsToSelector:invocation.selector]) {
		[invocation invokeWithTarget:self.proxied];
	}

}

// End NSProxy stuff

@end // FacebookAppDelegate
