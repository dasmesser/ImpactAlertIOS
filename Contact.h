//
//  Contact.h
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 06/02/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property NSString *name;
@property NSArray *phoneNumbers;

-(id) initWithName:(NSString *)name numbers:(NSArray *)phoneNumbers;
-(id) init;

@end
