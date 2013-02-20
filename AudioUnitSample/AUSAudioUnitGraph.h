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

- (void)start;
- (void)stop;
- (void)setVolume:(Float32)volume forElement:(UInt32)element;
- (void)setFileReader:(id)reader forElement:(UInt32)element;

@end
