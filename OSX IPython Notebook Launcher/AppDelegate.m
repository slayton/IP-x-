//
//  AppDelegate.m
//  OSX IPython Notebook Launcher
//
//  Created by Stuart Layton on 12/31/13.
//  Copyright (c) 2013 Stuart Layton. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    self.masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];

    [self.window.contentView addSubview:self.masterViewController.view];
    self.masterViewController.view.frame = ((NSView*)self.window.contentView).bounds;
    [self.window setReleasedWhenClosed:FALSE];

}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
    [self.window setIsVisible:TRUE];
    return TRUE;
}

-(void)applicationWillTerminate:(NSNotification *)notification{
    
    [self.masterViewController applicationIsClosing];
    
}





@end
