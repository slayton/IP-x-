//
//  MasterViewController.m
//  OSX IPython Notebook Launcher
//
//  Created by Stuart Layton on 12/31/13.
//  Copyright (c) 2013 Stuart Layton. All rights reserved.
//

#import "MasterViewController.h"
#import "Util.h"

#define kNoPID -1
#define kNoVEnv @" -- "
#define kIPythonBinary @"/opt/local/bin/ipython"

@interface MasterViewController ()

@end

@implementation MasterViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isRunning = FALSE;
        [self updateVirtualEnvList:Nil];
        [self updateAllViews];
        self.binaryPath = kIPythonBinary;

        [Util reportVirtualEnvironmentsTo:self using:@selector(getVirtualEnvList:)];
    }
    return self;
}

-(void) updateAllViews{
    NSLog(@"Updating view labels and state");
    [self updateLaunchButtonLabel];
    [self updateLogoImage];
    [self updateDockIcon];
}

-(void) updateLaunchButtonLabel{
    NSString *newLabel;
    if (self.isRunning){
        newLabel = NSLocalizedString(@"btn_label_terminate", nil);
    }else{
        newLabel = NSLocalizedString(@"btn_label_launch", nil);
    }
    
    NSLog(@"Setting Button Label to:%@", newLabel);
    [self->launchButton setTitle:newLabel];
}

-(void) updateLogoImage{
    
    NSString *imageName;
    if (self.isRunning){
        imageName = @"logo-green.png";
    }else{
        imageName = @"logo-red.png";
    }
    
    NSLog(@"Setting Logo Image to:%@", imageName);
    [self->logoImageView setImage:[NSImage imageNamed:imageName]];
}

-(void) updateDockIcon{
    
    NSString *iconName;
    
    if (self.isRunning){
        iconName = @"icon-green.icns";
    }else{
        iconName = @"icon-red.icns";
    }
    
    [NSApp setApplicationIconImage:[NSImage imageNamed:iconName]];
}

-(void) updateVirtualEnvList:(NSArray*)list{
    NSPopUpButton *pop = self->venvPicker;
    [pop removeAllItems];
    
    [pop insertItemWithTitle:kNoVEnv atIndex:0];

    if (list != Nil){
        [pop addItemsWithTitles:list];
    }
}

-(IBAction)virtualEnvSelected:(id)sender{
    NSPopUpButton *pop = (NSPopUpButton *) sender;
    self.virtualEnvName = [pop titleOfSelectedItem];
    
    NSLog(@"VirtEnv Selected: %@", self.virtualEnvName);
    
    if ([self.virtualEnvName isEqualToString:kNoVEnv])
        self.virtualEnvName = Nil;
}

-(IBAction)launchButtonClicked:(id)sender{
    
    NSLog(@"------ Launch Button Clicked ------");
    if (!self.isRunning){
        [self launchIPython];
    }else{
        [self terminateIPython];
    }
    
    [self updateAllViews];
}

-(void) launchIPython{

    NSLog(@"Launching IPython Notebook");
    NSString *launchDir = [Util launchFolderPicker];
    if (launchDir == Nil){
        NSLog(@"Failed to pick a directory");
        return;
    }
    self.task = [Util launchIPythonFromDir:launchDir usingBinary:self.binaryPath insideEnv:self.virtualEnvName];
    self.isRunning = TRUE;
    
}

-(void) terminateIPython{
    NSLog(@"Terminating IPython Notebook");
    [self.task terminate];
    self.task = Nil;
    
    self.isRunning = FALSE;
}

-(void) applicationIsClosing{
    NSLog(@"The application is closing, shutting down ipython notebook");
    [self terminateIPython];
}

-(void)getVirtualEnvList:(NSNotification *)notification {
    NSLog(@"ReadComplted!");
    
    NSData *data = [[notification userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *str = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray *virtEnvList = [str componentsSeparatedByString:@"\n"];
    
    for (id i in virtEnvList){
        NSString *entry = i;
        NSLog(@"\t%@\t%lu", entry, (unsigned long)[entry length]);
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleReadToEndOfFileCompletionNotification object:[notification object]];
    
    [self updateVirtualEnvList:virtEnvList];
}


@end
