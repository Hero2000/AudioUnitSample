//
//  AUSFileReader.m
//  AudioUnitSample
//
//  Created by Warren Moore on 1/24/13.
//  Copyright (c) 2013 Auerhaus Development, LLC. All rights reserved.
//

#import "AUSFileReader.h"
#import <AudioToolbox/AudioToolbox.h>

UInt32 AUSRingBufferCapacityFrames = 24576;

@interface AUSFileReader ()
@property(nonatomic, assign) CARingBuffer *buffer;
@property(nonatomic, assign) AudioStreamBasicDescription format;
@property(nonatomic, strong) NSURL *url;
@property(nonatomic, assign) AudioBufferList *data;
@end

@implementation AUSFileReader

- (id)initWithURL:(NSURL *)url format:(AudioStreamBasicDescription)asbd
{
	if((self = [super init]))
	{
		_url = url;
		_format = asbd;
		_buffer = new CARingBuffer();
		_buffer->Allocate(asbd.mChannelsPerFrame, asbd.mBytesPerFrame, AUSRingBufferCapacityFrames);
	}

	return self;
}

- (void)readSamples:(AudioBufferList *)data framesToRead:(UInt32)frames frameNumber:(CARingBuffer::SampleTime)frameNumber
{
	self.buffer->Fetch(data, frames, frameNumber);
}

- (void)play
{
	ExtAudioFileRef file = 0;
	OSStatus status = ExtAudioFileOpenURL((__bridge CFURLRef)self.url, &file);

	while(status == noErr)
	{
//		self.buffer->Store(&data, framesToRead, frameNumber);
//		ExtAudioFileRead(file, framesToRead, &data)
	}
}

@end
