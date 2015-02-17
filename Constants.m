//
//  Constants.m
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 15/01/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString *const settingsFile = @"settings/general_settings.json";
NSString *const settingsFileName = @"general_settings";
NSString *const settingsFileExtention = @"json";

NSString *const userNameKey = @"user_name";
NSString *const emergencyContactsKey = @"contacts";
NSString *const emergencyMessageKey = @"message";

NSString *const gpsReplacementString = @"[GPS]";
NSString *const nameReplacementString = @"[NAME]";
NSString *const defaultEmergencyMessage = @"[NAME] may have been involved in a vehicle accident at the location [GPS]. Do try to contact him/her and, if necessary, the pertinent authorities.";

@end
