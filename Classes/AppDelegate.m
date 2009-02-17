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
                _sound1 = aSoundID;
            } else {
                NSLog(@"Error %d loading tock sound", error);
                [self release];
                self = nil;
            }
        }
        
        aFileURL = [NSURL fileURLWithPath:[mainBundle pathForResource:@"tick" ofType:@"caf"] isDirectory:NO];
        if (aFileURL != nil) {
            SystemSoundID aSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)aFileURL, &aSoundID);
            if (error == kAudioServicesNoError) {
                _sound2 = aSoundID;
            } else {
                NSLog(@"Error %d loading tick", error);
                [self release];
                self = nil;
            }
        }
    }
    return self;
}

- (void)loadSubdivisions
{
    instr1Values[0] = [instr1_1 state];
    instr1Values[1] = [instr1_2 state];
    instr1Values[2] = [instr1_3 state];
    instr1Values[3] = [instr1_4 state];    
    instr1Values[4] = [instr1_5 state];
    instr1Values[5] = [instr1_6 state];
    instr1Values[6] = [instr1_7 state];
    instr1Values[7] = [instr1_8 state];
    instr1Values[8] = [instr1_9 state];
    instr1Values[9] = [instr1_10 state];
    instr1Values[10] = [instr1_11 state];
    instr1Values[11] = [instr1_12 state];
    instr1Values[12] = [instr1_13 state];
    instr1Values[13] = [instr1_14 state];
    instr1Values[14] = [instr1_15 state];
    instr1Values[15] = [instr1_16 state];

    instr2Values[0] = [instr2_1 state];
    instr2Values[1] = [instr2_2 state];
    instr2Values[2] = [instr2_3 state];
    instr2Values[3] = [instr2_4 state];    
    instr2Values[4] = [instr2_5 state];
    instr2Values[5] = [instr2_6 state];
    instr2Values[6] = [instr2_7 state];
    instr2Values[7] = [instr2_8 state];
    instr2Values[8] = [instr2_9 state];
    instr2Values[9] = [instr2_10 state];
    instr2Values[10] = [instr2_11 state];
    instr2Values[11] = [instr2_12 state];
    instr2Values[12] = [instr2_13 state];
    instr2Values[13] = [instr2_14 state];
    instr2Values[14] = [instr2_15 state];
    instr2Values[15] = [instr2_16 state];
}

- (void)dealloc
{
    AudioServicesDisposeSystemSoundID(_sound1);
    [soundPlayerThread release];
    [super dealloc];
}

- (void)playSound
{
    if (instr1Values[patternSubdivision - 1] == 1) {
        AudioServicesPlaySystemSound(_sound1);
    }
    
    if (instr2Values[patternSubdivision - 1] == 1) {
        AudioServicesPlaySystemSound(_sound2);
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

- (IBAction)changeBeat:(id)sender
{
    [self loadSubdivisions];
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
    [self startSound];
}

@end
