//
//  IPyLauncher.m
//  OSX IPython Notebook Launcher
//
//  Created by Stuart Layton on 12/31/13.
//  Copyright (c) 2013 Stuart Layton. All rights reserved.
//

#import "Util.h"

#define kVirtualEnvWrapper @"/usr/local/bin/virtualenvwrapper.sh"

@implementation Util

+(NSTask*) launchIPythonFromDir:(NSString*)directory usingBinary:(NSString*)binary insideEnv:(NSString*)envName{
    
    NSTask *task = [[NSTask alloc] init];
    
    NSMutableString *cmd = [[NSMutableString alloc] initWithString:@""];
    if (envName != Nil){
        [cmd appendFormat:@"%@ ;", [Util getWorkonEnvCommand:envName]];
    }else{
        NSLog(@"VirtualEnv name is NIL");
    }
    
    [cmd appendFormat:@"%@;", [Util getChangeDirCommand:directory]];
    [cmd appendFormat:@"%@ ", [Util getStartIPythonCommand:binary]];
    NSLog(@"-->EXEC:%@", cmd);
    
    NSArray *args = [[NSArray alloc] initWithObjects:@"-c", cmd, nil];
    
    [task setLaunchPath:@"/bin/bash"];
    [task setArguments:args];
    
    NSLog(@"Launching Task!");
    [task launch];
    NSLog(@"Task Launched!");
    
    return task;
}


+(void) reportVirtualEnvironmentsTo:(id)observer using:(SEL)selector{
    
    NSLog(@"Listing Virtual Environtments");
    
    NSTask *task = [[NSTask alloc] init];
    NSMutableString *cmd = [[NSMutableString alloc] initWithString:@""];
    [cmd appendFormat:@"%@ ;", [Util getWorkonEnvCommand:@""]];
    NSLog(@"-->EXEC:%@", cmd);
    
    NSArray *args = [[NSArray alloc] initWithObjects:@"-c", cmd, nil];
    
    [task setLaunchPath:@"/bin/bash"];
    [task setArguments:args];
    
    NSPipe *out = [NSPipe pipe];
    [task setStandardOutput:out];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector
                                                 name:NSFileHandleReadToEndOfFileCompletionNotification
                                               object:[out fileHandleForReading]];
    
    [[out fileHandleForReading] readToEndOfFileInBackgroundAndNotify];
    [task launch];
}

+(NSString*) getWorkonEnvCommand:(NSString *)env{
    
    NSString *cmd = [NSString stringWithFormat:@"source %@; workon %@", kVirtualEnvWrapper, env];
    return cmd;
}

+(NSString*) getChangeDirCommand:(NSString *)directory{
    NSString *cmd = [NSString stringWithFormat:@"cd %@", directory];
    return cmd;
}

+(NSString*) getStartIPythonCommand:(NSString *)binary{
    NSString *cmd = [NSString stringWithFormat:@"%@ notebook", binary];
    return cmd;
}

+(NSString*) launchFolderPicker{
   
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];

    [openDlg setCanChooseFiles:FALSE];
    [openDlg setAllowsMultipleSelection:FALSE];
    [openDlg setCanChooseDirectories:TRUE];
    [openDlg setMessage:NSLocalizedString(@"dlg_msg_select_dir", nil)];

    if ( [openDlg runModal] == NSOKButton ) {
        NSURL *url = [openDlg URLs][0];
        return url.path;
    }
    return Nil;
}

@end


//source /usr/local/bin/virtualenvwrapper.sh
//
//if [ $2 != 'no-virtualenv' ]; then
//V_ENV=$2
//echo 'Setting virtualenv to:' $V_ENV
//workon $V_ENV
//fi
//
//WORK_DIR=$1
//
//echo 'Moving to:' $WORK_DIR
//cd $WORK_DIR
//
///opt/local/bin/ipython notebook
