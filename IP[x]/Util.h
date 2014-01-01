//
//  IPyLauncher.h
//  OSX IPython Notebook Launcher
//
//  Created by Stuart Layton on 12/31/13.
//  Copyright (c) 2013 Stuart Layton. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Util : NSObject

+(NSTask*) launchIPythonFromDir:(NSString*)directory usingBinary:(NSString*)binary insideEnv:(NSString*)envName;

+(void) reportVirtualEnvironmentsTo:(id)observer using:(SEL)selector;

+(NSString*) launchFolderPicker;

@end
