//
//  AppDelegate.h
//  SuperMet
//
//  Created by Scott Barron on 2/16/09.
//  Copyright 2009 Scott Barron. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AudioToolbox/AudioServices.h>

@interface AppDelegate : NSObject {
    SystemSoundID _soundID;
    NSThread *soundPlayerThread;
    CGFloat duration;
    NSUInteger beatNumber;
    NSUInteger patternSubdivision;
    IBOutlet NSTextField *bpmField;
}

@property (nonatomic, retain) NSThread *soundPlayerThread;
@property CGFloat duration;

- (IBAction)startMetronome:(id)sender;
- (IBAction)stopMetronome:(id)sender;

@end
