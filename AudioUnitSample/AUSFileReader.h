//
//  AUSFileReader.h
//  AudioUnitSample
//
//  Created by Warren Moore on 1/24/13.
//  Copyright (c) 2013 Auerhaus Development, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#include "CARingBuffer.h"

@interface AUSFileReader : NSObject

- (void)readSamples:(AudioBufferList *)data framesToRead:(UInt32)frames frameNumber:(CARingBuffer::SampleTime)frameNumber;

@end
