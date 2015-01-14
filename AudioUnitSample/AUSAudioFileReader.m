//
//  AUSAudioFileReader.m
//  AudioUnitSample
//
//  Created by Warren Moore on 2/19/13.
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

- (AudioStreamBasicDescription)noninterleavedPCMFormatWithChannels:(UInt32)channels
{
	UInt32 bytesPerSample = sizeof(Float32);

	AudioStreamBasicDescription asbd;
	bzero(&asbd, sizeof(asbd));
	asbd.mSampleRate = 44100.0;
	asbd.mFormatID = kAudioFormatLinearPCM;
    asbd.mFormatFlags = kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
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
		NSLog(@"Error: could not open file for playback: %d", (int)result);
	}

	AudioStreamBasicDescription clientFormat = [self noninterleavedPCMFormatWithChannels:2];
	result = ExtAudioFileSetProperty(audioFile, kExtAudioFileProperty_ClientDataFormat, sizeof(clientFormat), &clientFormat);
	if(result != noErr)
		NSLog(@"Error: could not set client audio format for playback: %d", (int)result);
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
