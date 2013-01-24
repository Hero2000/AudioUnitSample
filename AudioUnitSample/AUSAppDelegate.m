//
//  AUSAppDelegate.m
//  AudioUnitSample
//
//  Created by Warren Moore on 1/23/13.
//  Copyright (c) 2013 Auerhaus Development, LLC. All rights reserved.
//

#import "AUSAppDelegate.h"
#import "AUSAudioViewController.h"
#import "AUSAudioSession.h"

@implementation AUSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	UIViewController *vc = [[AUSAudioViewController alloc] initWithNibName:@"AUSAudioView" bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[[AUSAudioSession sharedInstance] setPreferredLatency:AUSAudioSessionLatency_Background];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[[AUSAudioSession sharedInstance] setPreferredLatency:AUSAudioSessionLatency_LowLatency];
}

@end
