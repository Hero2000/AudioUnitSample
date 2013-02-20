//
//  AUSAudioViewController.m
//  AudioUnitSample
//
//  Created by Warren Moore on 1/23/13.
//  Copyright (c) 2013 Auerhaus Development, LLC. All rights reserved.
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
