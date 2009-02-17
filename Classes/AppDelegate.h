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
    
    IBOutlet NSButton *subDiv1;
    IBOutlet NSButton *subDiv2;
    IBOutlet NSButton *subDiv3;
    IBOutlet NSButton *subDiv4;
    IBOutlet NSButton *subDiv5;
    IBOutlet NSButton *subDiv6;
    IBOutlet NSButton *subDiv7;
    IBOutlet NSButton *subDiv8;
    IBOutlet NSButton *subDiv9;
    IBOutlet NSButton *subDiv10;
    IBOutlet NSButton *subDiv11;
    IBOutlet NSButton *subDiv12;
    IBOutlet NSButton *subDiv13;
    IBOutlet NSButton *subDiv14;
    IBOutlet NSButton *subDiv15;
    IBOutlet NSButton *subDiv16;
    
    NSInteger subdivisionValues[16];
}

@property (nonatomic, retain) NSThread *soundPlayerThread;
@property CGFloat duration;

- (IBAction)startMetronome:(id)sender;
- (IBAction)stopMetronome:(id)sender;

@end
