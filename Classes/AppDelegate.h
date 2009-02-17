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
    SystemSoundID _sound1;
    SystemSoundID _sound2;
    NSThread *soundPlayerThread;
    CGFloat duration;
    NSUInteger beatNumber;
    NSUInteger patternSubdivision;
    IBOutlet NSTextField *bpmField;
    
    IBOutlet NSButton *instr1_1;
    IBOutlet NSButton *instr1_2;
    IBOutlet NSButton *instr1_3;
    IBOutlet NSButton *instr1_4;
    IBOutlet NSButton *instr1_5;
    IBOutlet NSButton *instr1_6;
    IBOutlet NSButton *instr1_7;
    IBOutlet NSButton *instr1_8;
    IBOutlet NSButton *instr1_9;
    IBOutlet NSButton *instr1_10;
    IBOutlet NSButton *instr1_11;
    IBOutlet NSButton *instr1_12;
    IBOutlet NSButton *instr1_13;
    IBOutlet NSButton *instr1_14;
    IBOutlet NSButton *instr1_15;
    IBOutlet NSButton *instr1_16;
    
    IBOutlet NSButton *instr2_1;
    IBOutlet NSButton *instr2_2;
    IBOutlet NSButton *instr2_3;
    IBOutlet NSButton *instr2_4;
    IBOutlet NSButton *instr2_5;
    IBOutlet NSButton *instr2_6;
    IBOutlet NSButton *instr2_7;
    IBOutlet NSButton *instr2_8;
    IBOutlet NSButton *instr2_9;
    IBOutlet NSButton *instr2_10;
    IBOutlet NSButton *instr2_11;
    IBOutlet NSButton *instr2_12;
    IBOutlet NSButton *instr2_13;
    IBOutlet NSButton *instr2_14;
    IBOutlet NSButton *instr2_15;
    IBOutlet NSButton *instr2_16;
    
    NSInteger instr1Values[16];
    NSInteger instr2Values[16];
}

@property (nonatomic, retain) NSThread *soundPlayerThread;
@property CGFloat duration;

- (IBAction)startMetronome:(id)sender;
- (IBAction)stopMetronome:(id)sender;
- (IBAction)changeBeat:(id)sender;

@end
