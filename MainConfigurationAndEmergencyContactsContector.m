//
//  MainConfigurationAndEmergencyContactsContector.m
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 07/02/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import "MainConfigurationAndEmergencyContactsContector.h"

@implementation MainConfigurationAndEmergencyContactsContector

NSArray *emergencyContacts;
BOOL isReturningFromEmergencyContacts;

+(void)setEmergencyContacts:(NSArray *)contactList{
    emergencyContacts = contactList;
}

+(NSArray *)getEmergencyContacts{
    return emergencyContacts;
}

+(void)setReturningFromEmergencyContacts:(BOOL)isReturning{
    isReturningFromEmergencyContacts = isReturning;
}

+(BOOL)isReturningFromEmergencyContacts{
    return isReturningFromEmergencyContacts;
}

+(void)clear{
    emergencyContacts = nil;
    isReturningFromEmergencyContacts = NO;
}
@end
