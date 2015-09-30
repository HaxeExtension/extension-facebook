#import <AVFoundation/AVFoundation.h>
#import <Facebook.h>
#import <FacebookAppDelegate.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Foundation/Foundation.h>

@implementation FacebookAppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	return [[FBSDKApplicationDelegate sharedInstance] application:application
									openURL:url
									sourceApplication:sourceApplication
									annotation:annotation];
}

// Fix audio issue:

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	NSLog(@"%s", __FUNCTION__);
	[self startAudio];
	return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	NSLog(@"%s", __FUNCTION__);

	// SpriteKit uses AVAudioSession for [SKAction playSoundFileNamed:]
	// AVAudioSession cannot be active while the application is in the background,
	// so we have to stop it when going in to background
	// and reactivate it when entering foreground.
	// This prevents audio crash.
	[self stopAudio];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	NSLog(@"%s", __FUNCTION__);

	[self startAudio];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	NSLog(@"%s", __FUNCTION__);

	[self stopAudio];
}

static BOOL isAudioSessionActive = NO;

- (void)startAudio {
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *error = nil;

	if (audioSession.otherAudioPlaying) {
		[audioSession setCategory: AVAudioSessionCategoryAmbient error:&error];
	} else {
		[audioSession setCategory: AVAudioSessionCategorySoloAmbient error:&error];
	}

	if (!error) {
		[audioSession setActive:YES error:&error];
		isAudioSessionActive = YES;
	}

	NSLog(@"%s AVAudioSession Category: %@ Error: %@", __FUNCTION__, [audioSession category], error);
}

- (void)stopAudio {
	// Prevent background apps from duplicate entering if terminating an app.
	if (!isAudioSessionActive) return;

	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *error = nil;

	[audioSession setActive:NO error:&error];

	NSLog(@"%s AVAudioSession Error: %@", __FUNCTION__, error);

	if (error) {
		// It's not enough to setActive:NO
		// We have to deactivate it effectively (without that error),
		// so try again (and again... until success).
		[self stopAudio];
	} else {
		isAudioSessionActive = NO;
	}
}

// App Invite dialog callbacks:

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults: (NSDictionary *)results {
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:results
											options:0
											error:&error];
	if (!jsonData) {
		extension_facebook::onAppInviteFail([[error localizedDescription] UTF8String]);
	} else {
		extension_facebook::onAppInviteComplete(
			[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] UTF8String]
		);
	}
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error {
	extension_facebook::onAppInviteFail([[error localizedDescription] UTF8String]);
}

// Game Invite dialog callbacks:

- (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didCompleteWithResults:(NSDictionary *)results {
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:results
											options:0
											error:&error];
	if (!jsonData) {
		extension_facebook::onAppRequestFail([[error localizedDescription] UTF8String]);
	} else {
		//NSLog([[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
		extension_facebook::onAppRequestComplete(
			[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] UTF8String]
		);
	}
}

- (void)gameRequestDialogDidCancel:(FBSDKGameRequestDialog *)gameRequestDialog {
	extension_facebook::onAppRequestFail("{\"error\" : \"Cancelled by user\"}");
}

- (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didFailWithError:(NSError *)error {
	extension_facebook::onAppRequestFail([[error localizedDescription] UTF8String]);
}

// Share dialog callbacks:

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:results
											options:0
											error:&error];
	if (!jsonData) {
		extension_facebook::onShareFail([[error localizedDescription] UTF8String]);
	} else {
		//NSLog([[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
		extension_facebook::onShareComplete(
			[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] UTF8String]
		);
	}
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
	extension_facebook::onShareFail([[error localizedDescription] UTF8String]);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
	extension_facebook::onShareFail("{\"error\" : \"Cancelled by user\"}");
}

@end
