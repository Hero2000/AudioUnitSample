//
//  AUSAudioFileReader.m
//  AudioUnitSample
//
//  Created by Warren Moore on 2/19/13.
//  Copyright (c) 2013 Auerhaus Development, LLC. All rights reserved.
//

#import "AUSAudioFileReader.h"

@interface AUSAudioFileReader ()
{
	ExtAudioFileRef audioFile;
}
@end

@implementation AUSAudioFileReader

- (id)initWithURL:(NSURL *)fileURL
{
	if((self = [super init]))
	{
		[self loadFileAtURL:fileURL];
	}
	return self;
}

- (AudioStreamBasicDescription)noninterleavedPCMFormatWithChannels:(NSInteger)channels
{
	size_t bytesPerSample = sizeof(AudioUnitSampleType);

	AudioStreamBasicDescription asbd;
	bzero(&asbd, sizeof(asbd));
	asbd.mSampleRate = 44100.0;
	asbd.mFormatID = kAudioFormatLinearPCM;
	asbd.mFormatFlags = kAudioFormatFlagsAudioUnitCanonical;
	asbd.mBitsPerChannel = 8 * bytesPerSample;
	asbd.mBytesPerFrame = bytesPerSample;
	asbd.mBytesPerPacket = bytesPerSample;
	asbd.mFramesPerPacket = 1;
	asbd.mChannelsPerFrame = channels;

	return asbd;
}

- (void)loadFileAtURL:(NSURL *)fileURL
{
	OSStatus result = noErr;
	result = ExtAudioFileOpenURL((__bridge CFURLRef)fileURL, &audioFile);
	if(result != noErr)
	{
		NSLog(@"Error: could not open file for playback: %ld", result);
	}

	AudioStreamBasicDescription clientFormat = [self noninterleavedPCMFormatWithChannels:2];
	result = ExtAudioFileSetProperty(audioFile, kExtAudioFileProperty_ClientDataFormat, sizeof(clientFormat), &clientFormat);
	if(result != noErr)
		NSLog(@"Error: could not set client audio format for playback: %ld", result);
}

- (BOOL)readSamples:(AudioBufferList *)data
		atTimeStamp:(const AudioTimeStamp *)timeStamp
	   numberFrames:(UInt32)frames
{
	OSStatus result = ExtAudioFileRead(audioFile, &frames, data);

	return (result == noErr);
}

- (void)seekToSample:(SInt64)sampleIndex
{
	ExtAudioFileSeek(audioFile, sampleIndex);
}

@end
