//
//  AUSAudioSession.m
//  AudioUnitSample
//
//  Created by Warren Moore on 1/23/13.
//  Copyright (C) 2013 Auerhaus Development, LLC
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
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

	if(![self.audioSession setPreferredSampleRate:self.preferredSampleRate error:&error])
		NSLog(@"Error when setting sample rate on audio session: %@", error.localizedDescription);

	if(![self.audioSession setActive:_active error:&error])
		NSLog(@"Error when setting active state of audio session: %@", error.localizedDescription);

	_currentSampleRate = [self.audioSession sampleRate];
}

- (void)setPreferredLatency:(NSTimeInterval)preferredLatency
{
	_preferredLatency = preferredLatency;
	
	NSError *error = nil;
	if(![self.audioSession setPreferredIOBufferDuration:_preferredLatency error:&error])
		NSLog(@"Error when setting preferred I/O buffer duration");
}

- (void)setOverrideRouteToUseLoudspeaker:(BOOL)overrideRouteToUseLoudspeaker
{
	_overrideRouteToUseLoudspeaker = overrideRouteToUseLoudspeaker;

	UInt32 route = _overrideRouteToUseLoudspeaker ? kAudioSessionOverrideAudioRoute_Speaker : kAudioSessionOverrideAudioRoute_None;
	OSStatus result = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(UInt32), &route);
	if(result != noErr)
		NSLog(@"Warning: Could not override for speaker route: %ld", result);
}

@end
