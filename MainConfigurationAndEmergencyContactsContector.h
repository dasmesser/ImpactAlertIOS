//
//  MainConfigurationAndEmergencyContactsContector.h
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 07/02/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainConfigurationAndEmergencyContactsContector : NSObject

+(void)setEmergencyContacts:(NSArray *)contactList;
+(NSArray *)getEmergencyContacts;
+(void)setReturningFromEmergencyContacts:(BOOL)isReturning;
+(BOOL)isReturningFromEmergencyContacts;

+(void)clear;

@end
