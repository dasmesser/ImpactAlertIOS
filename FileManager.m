//
//  FileManager.m
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 14/01/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import "FileManager.h"
#import "Constants.h"

@implementation FileManager
+(BOOL)isFirstRun{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    return [filemgr fileExistsAtPath: settingsFile];
}
@end
