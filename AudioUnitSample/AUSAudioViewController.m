//
//  AUSAudioViewController.m
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

#import "AUSAudioViewController.h"
#import "AUSAudioSession.h"
#import "AUSAudioUnitGraph.h"
#import "AUSAudioFileReader.h"

@interface AUSAudioViewController ()
@property(nonatomic, strong) AUSAudioUnitGraph *graph;
@property(nonatomic, strong) NSArray *fileReaders;
@end

@implementation AUSAudioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[[AUSAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord];
	[[AUSAudioSession sharedInstance] setPreferredSampleRate:44100.0];
	[[AUSAudioSession sharedInstance] setActive:YES];
	[[AUSAudioSession sharedInstance] setOverrideRouteToUseLoudspeaker:YES];
	
	self.graph = [[AUSAudioUnitGraph alloc] init];

	[self loadFiles];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[self resetForDemo1:nil];

	[self.graph start];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	[self.graph stop];
}

- (void)loadFiles
{
	NSURL *file1 = [[NSBundle mainBundle] URLForResource:@"float-on" withExtension:@"wav"];
	NSURL *file2 = [[NSBundle mainBundle] URLForResource:@"what-you-know" withExtension:@"wav"];

	AUSAudioFileReader *reader1 = [[AUSAudioFileReader alloc] initWithURL:file1];
	AUSAudioFileReader *reader2 = [[AUSAudioFileReader alloc] initWithURL:file2];

	self.fileReaders = @[reader1, reader2];

	[self.graph setFileReader:reader1 forElement:1];
	[self.graph setFileReader:reader2 forElement:2];
}

- (IBAction)volumeSliderValueChanged:(id)sender
{
	NSInteger index = 0;
	for(UISlider *volumeSlider in self.volumeSliders)
	{
		[self.graph setVolume:volumeSlider.value forElement:index];
		++index;
	}
}

- (IBAction)resetForDemo1:(id)sender
{
	[(UISlider *)self.volumeSliders[0] setValue:0.25];
	[(UISlider *)self.volumeSliders[1] setValue:0.0];
	[(UISlider *)self.volumeSliders[2] setValue:0.0];
	[self volumeSliderValueChanged:nil];
}

- (IBAction)resetForDemo2:(id)sender
{
	for(AUSAudioFileReader *reader in self.fileReaders)
		[reader seekToSample:0];
	
	[(UISlider *)self.volumeSliders[0] setValue:0.0];
	[(UISlider *)self.volumeSliders[1] setValue:0.5];
	[(UISlider *)self.volumeSliders[2] setValue:0.5];
	[self volumeSliderValueChanged:nil];
}

@end
