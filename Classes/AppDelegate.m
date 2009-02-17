//
//  AppDelegate.m
//  SuperMet
//
//  Created by Scott Barron on 2/16/09.
//  Copyright 2009 Scott Barron. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

@synthesize soundPlayerThread;
@synthesize duration;

- (id)init
{
    self = [super init];
    if (self != nil) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        
        NSURL *aFileURL = [NSURL fileURLWithPath:[mainBundle pathForResource:@"tock" ofType:@"caf"] isDirectory:NO];
        if (aFileURL != nil) {
            SystemSoundID aSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)aFileURL, &aSoundID);
            if (error == kAudioServicesNoError) {
                _soundID = aSoundID;
            } else {
                NSLog(@"Error %d loading sound", error);
                [self release], self = nil;
            }
        }
    }
    return self;
}

- (void)loadSubdivisions
{
    subdivisionValues[0] = [subDiv1 state];
    subdivisionValues[1] = [subDiv2 state];
    subdivisionValues[2] = [subDiv3 state];
    subdivisionValues[3] = [subDiv4 state];
    
    subdivisionValues[4] = [subDiv5 state];
    subdivisionValues[5] = [subDiv6 state];
    subdivisionValues[6] = [subDiv7 state];
    subdivisionValues[7] = [subDiv8 state];
    subdivisionValues[8] = [subDiv9 state];
    subdivisionValues[9] = [subDiv10 state];
    subdivisionValues[10] = [subDiv11 state];
    subdivisionValues[11] = [subDiv12 state];
    subdivisionValues[12] = [subDiv13 state];
    subdivisionValues[13] = [subDiv14 state];
    subdivisionValues[14] = [subDiv15 state];
    subdivisionValues[15] = [subDiv16 state];
}

- (void)dealloc
{
    AudioServicesDisposeSystemSoundID(_soundID);
    [soundPlayerThread release];
    [super dealloc];
}

- (void)playSound
{
    if (subdivisionValues[patternSubdivision - 1] == 1) {
        AudioServicesPlaySystemSound(_soundID);
    }
    
    if (patternSubdivision % 4 == 1) {
        beatNumber++;
    }
    
    if (patternSubdivision == 16) {
        beatNumber = 1;
        patternSubdivision = 0;
    }
    
    patternSubdivision++;
}

- (void)startDriverTimer:(id)info
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [NSThread setThreadPriority:1.0];
    BOOL continuePlaying = YES;
    
    while (continuePlaying) {
        NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init];
        [self playSound];
        NSDate *curtainTime = [NSDate dateWithTimeIntervalSinceNow:self.duration];
        NSDate *currentTime = [NSDate date];
        
        while (continuePlaying && ([currentTime compare:curtainTime] != NSOrderedDescending)) {
            if ([soundPlayerThread isCancelled] == YES) {
                continuePlaying = NO;
            }
            [NSThread sleepForTimeInterval:0.001];
            currentTime = [NSDate date];
        }
        [loopPool release];
    }
    [pool release];
}

- (void)waitForSoundDriverThreadToFinish
{
    while (soundPlayerThread && ![soundPlayerThread isFinished]) {
        [NSThread sleepForTimeInterval:0.1];
    }
}

- (void)startDriverThread
{
    if (soundPlayerThread != nil) {
        [soundPlayerThread cancel];
        [self waitForSoundDriverThreadToFinish];
    }
    
    NSThread *driverThread = [[NSThread alloc] initWithTarget:self selector:@selector(startDriverTimer:) object:nil];
    self.soundPlayerThread = driverThread;
    [driverThread release];
    
    [self.soundPlayerThread start];
}

- (void)stopDriverThread
{
    [self.soundPlayerThread cancel];
    [self waitForSoundDriverThreadToFinish];
    self.soundPlayerThread = nil;
}

- (void)startSound
{
    self.duration = (60.0 / [bpmField intValue]) / 4; // Really click in 16th notes
    beatNumber = 1;
    patternSubdivision = 1;
    [self loadSubdivisions];
    [self startDriverThread];
}

- (void)stopSound
{
    [self stopDriverThread];
}

- (IBAction)startMetronome:(id)sender
{
    [self startSound];
}

- (IBAction)stopMetronome:(id)sender
{
    [self stopSound];
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
    [self startSound];
}

@end
