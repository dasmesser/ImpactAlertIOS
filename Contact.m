//
//  Contact.m
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 06/02/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import "Contact.h"

@implementation Contact

-(id) initWithName:(NSString *)name numbers:(NSArray *)phoneNumbers{
    if(self = [super init]){
        self.name =            name;
        self.phoneNumbers =    phoneNumbers;
    }
    
    return self;
}

-(id) init{
    self = [super init];
    return self;
}


@end

