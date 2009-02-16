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

- (void)dealloc
{
    AudioServicesDisposeSystemSoundID(_soundID);
    [soundPlayerThread release];
    [super dealloc];
}

- (void)playSound
{
    AudioServicesPlaySystemSound(_soundID);
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
    self.duration = (60.0 / [bpmField intValue]);
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
