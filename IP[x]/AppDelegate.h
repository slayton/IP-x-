//
//  AppDelegate.h
//  OSX IPython Notebook Launcher
//
//  Created by Stuart Layton on 12/31/13.
//  Copyright (c) 2013 Stuart Layton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "MasterViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic,strong) IBOutlet MasterViewController *masterViewController;
    
@property (assign) IBOutlet NSWindow *window;

@end
