//
//  Configuration.m
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 29/01/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import "Settings.h"
#import "Constants.h"

@implementation Settings

-(id) initWithNSDictionary:(NSDictionary *)dic{
    if(self = [super init]){
        self.userName =             [dic objectForKey:userNameKey];
        self.emergencyContacts =    [dic objectForKey:emergencyMessageKey];
        self.emergencyMessage =     [dic objectForKey:emergencyMessageKey];
    }
    
    return self;
}

-(NSDictionary *) getNSDictionaryRepresentation{
    return @{userNameKey            : self.userName,
             emergencyContactsKey   : self.emergencyContacts,
             emergencyMessageKey    : self.emergencyMessage};
}

@end
