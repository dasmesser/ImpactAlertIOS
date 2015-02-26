//
//  Constants.h
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 15/01/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject
FOUNDATION_EXPORT NSString *const configFileName;

FOUNDATION_EXPORT NSString *const usernameKey;
FOUNDATION_EXPORT NSString *const passwordKey;
FOUNDATION_EXPORT NSString *const idKey;

FOUNDATION_EXPORT NSString *const callTypeKey;
FOUNDATION_EXPORT NSString *const loggin;
FOUNDATION_EXPORT NSString *const confirmation;
FOUNDATION_EXPORT NSString *const alert;
FOUNDATION_EXPORT NSString *const cancel;

FOUNDATION_EXPORT NSString *const alertKey;
FOUNDATION_EXPORT NSString *const red;
FOUNDATION_EXPORT NSString *const green;

FOUNDATION_EXPORT NSString *const gpsKey;

FOUNDATION_EXPORT NSString *const encryptionError;
FOUNDATION_EXPORT NSString *const writeToDiskError;
FOUNDATION_EXPORT NSString *const decryptionError;
FOUNDATION_EXPORT NSString *const readFromDiskError;
FOUNDATION_EXPORT NSString *const configInformationAccessError;

@end
