//
//  Configuration.h
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 29/01/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings: NSObject

@property NSString *userName;
@property NSArray *emergencyContacts;
@property NSString *emergencyMessage;

-(id) initWithNSDictionary:(NSDictionary *) dic;
-(NSDictionary *) getNSDictionaryRepresentation;

@end
