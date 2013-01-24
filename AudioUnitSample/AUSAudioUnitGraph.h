//
//  AUSAudioUnitGraph.h
//  AudioUnitSample
//
//  Created by Warren Moore on 1/23/13.
//  Copyright (c) 2013 Auerhaus Development, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AUSAudioUnitGraph : NSObject

@property(nonatomic, assign) Float64 sampleRate;

@property(nonatomic, assign) Float32 mixerPan;
@property(nonatomic, assign) Float32 pitchAdjustment;

- (void)start;
- (void)stop;

@end
