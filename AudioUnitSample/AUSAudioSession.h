//
//  AUSAudioSession.h
//  AudioUnitSample
//
//  Created by Warren Moore on 1/23/13.
//  Copyright (c) 2013 Auerhaus Development, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

extern const NSTimeInterval AUSAudioSessionLatency_Background;
extern const NSTimeInterval AUSAudioSessionLatency_Default;
extern const NSTimeInterval AUSAudioSessionLatency_LowLatency;

@interface AUSAudioSession : NSObject

+ (AUSAudioSession *)sharedInstance;

@property(nonatomic, strong) AVAudioSession *audioSession; // Underlying system audio session
@property(nonatomic, assign) Float64 preferredSampleRate;
@property(nonatomic, assign, readonly) Float64 currentSampleRate;
@property(nonatomic, assign) NSTimeInterval preferredLatency;
@property(nonatomic, assign) BOOL active;
@property(nonatomic, strong) NSString *category;

@end
