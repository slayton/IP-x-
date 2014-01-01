//
//  MasterViewController.h
//  OSX IPython Notebook Launcher
//
//  Created by Stuart Layton on 12/31/13.
//  Copyright (c) 2013 Stuart Layton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MasterViewController : NSViewController
{
    IBOutlet NSImageView *logoImageView;
    IBOutlet NSButton    *launchButton;
    IBOutlet NSTextField *venvLabel;
    IBOutlet NSPopUpButton *venvPicker;
    
}

-(void) updateVirtualEnvList:(NSArray*)list;
-(IBAction) launchButtonClicked:(id)sender;
-(IBAction) virtualEnvSelected:(id)sender;

-(void) applicationIsClosing;

@property BOOL isRunning;
@property BOOL useVirtualEnv;

@property NSString *virtualEnvName;
@property NSString *binaryPath;

@property NSTask *task;

@end
