//
//  AUSAudioSession.m
//  AudioUnitSample
//
//  Created by Warren Moore on 1/23/13.
//  Copyright (c) 2013 Auerhaus Development, LLC. All rights reserved.
//

#import "AUSAudioSession.h"

const NSTimeInterval AUSAudioSessionLatency_Background = 0.0929;
const NSTimeInterval AUSAudioSessionLatency_Default = 0.0232;
const NSTimeInterval AUSAudioSessionLatency_LowLatency = 0.0058;

@implementation AUSAudioSession

+ (AUSAudioSession *)sharedInstance
{
	static AUSAudioSession *instance = NULL;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[AUSAudioSession alloc] init];
	});
	return instance;
}

- (id)init
{
	if((self = [super init]))
	{
		_preferredSampleRate = _currentSampleRate = 44100.0;
		_audioSession = [AVAudioSession sharedInstance];
	}
	return self;
}

- (void)setCategory:(NSString *)category
{
	_category = category;
	
	NSError *error = nil;
	if(![self.audioSession setCategory:_category error:&error])
		NSLog(@"Could note set category on audio session: %@", error.localizedDescription);
}

- (void)setActive:(BOOL)active
{
	_active = active;

	NSError *error = nil;

	if(![self.audioSession setPreferredHardwareSampleRate:self.preferredSampleRate error:&error])
		NSLog(@"Error when setting sample rate on audio session: %@", error.localizedDescription);

	if(![self.audioSession setActive:_active error:&error])
		NSLog(@"Error when setting active state of audio session: %@", error.localizedDescription);

	_currentSampleRate = [self.audioSession currentHardwareSampleRate];
}

- (void)setPreferredLatency:(NSTimeInterval)preferredLatency
{
	_preferredLatency = preferredLatency;
	
	NSError *error = nil;
	if(![self.audioSession setPreferredIOBufferDuration:_preferredLatency error:&error])
		NSLog(@"Error when setting preferred I/O buffer duration");
}

@end
