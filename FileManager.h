//
//  FileManager.h
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 14/01/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"

@interface FileManager : NSObject
+(BOOL) isFirstRun;
+(NSString *) getUserName;
+(NSArray *) getEmergencyContacts;
+(NSString *) getEmergencyMessage;
+(void) saveSettingsChanges:(Settings *)newSettings;
@end
