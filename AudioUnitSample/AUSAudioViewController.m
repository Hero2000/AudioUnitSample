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

@interface AUSAudioViewController ()
@property(nonatomic, strong) AUSAudioUnitGraph *graph;
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
	
	self.graph = [[AUSAudioUnitGraph alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[self.graph start];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	[self.graph stop];
}

- (IBAction)panSliderValueChanged:(UISlider *)sender
{
	self.graph.mixerPan = [sender value];
}

- (IBAction)pitchSliderValueChanged:(UISlider *)sender
{
	self.graph.pitchAdjustment = [sender value];
}

@end
