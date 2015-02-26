//
//  FileManager.h
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 14/01/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"
#import "RNCryptor/RNCryptor/RNCryptor/RNDecryptor.h"
#import "RNCryptor/RNCryptor/RNCryptor/RNEncryptor.h"

@interface FileManager : NSObject
+(NSError *) isFirstRun;

+(NSString *) getUsername;
+(NSString *) getPassword;
+(NSString *) getUserID;

+(NSError *) saveUsername:(NSString *)username password:(NSString *)password andId:(NSString *)userID;

@end
