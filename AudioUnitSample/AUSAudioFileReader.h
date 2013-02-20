//
//  AUSAudioFileReader.h
//  AudioUnitSample
//
//  Created by Warren Moore on 2/19/13.
//  Copyright (c) 2013 Auerhaus Development, LLC. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

@interface AUSAudioFileReader : NSObject

- (id)initWithURL:(NSURL *)fileURL;

- (BOOL)readSamples:(AudioBufferList *)data
		atTimeStamp:(const AudioTimeStamp *)timeStamp
	   numberFrames:(UInt32)frames;

- (void)seekToSample:(SInt64)sampleIndex;

@end
