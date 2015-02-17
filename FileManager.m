//
//  FileManager.m
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 14/01/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import "FileManager.h"
#import "Constants.h"
#import "Settings.h"

@implementation FileManager

BOOL haveSettingsBeenLoaded = NO;
Settings *settings = nil;

+(void)loadSettings{
    
    if(![self isFirstRun]){
        NSFileManager *filemgr = [NSFileManager defaultManager];
        NSData *databuffer = [filemgr contentsAtPath: settingsFile];
        
        id object = [NSJSONSerialization JSONObjectWithData:databuffer
                                                    options:0
                                                      error:nil];
        
        if([object isKindOfClass:[NSDictionary class]]) {
            settings = [Settings new];
            
            NSDictionary *dictionary = [[NSDictionary alloc]initWithDictionary:object];
            
            id idUserName = [dictionary valueForKey:userNameKey];
            if([idUserName isKindOfClass:[NSString class]]){
                settings.userName = (NSString *)idUserName;
            }
            else{
                NSLog(@"The settings file was corrupted, the user name cannot be cast to NSString");
                settings.userName = @"";
            }
            
            id idEmergencyContacts = [dictionary valueForKey:emergencyMessageKey];
            if([idEmergencyContacts isKindOfClass:[NSArray class]]){
                settings.emergencyContacts = [[NSArray alloc] initWithArray:idEmergencyContacts];
            }
            else{
                NSLog(@"The settings file was corrupted, the contacts' list cannot be cast to NSArray");
                settings.emergencyContacts = [[NSArray alloc] init];
            }
            
            id idEmergencyMessage = [dictionary valueForKey:emergencyMessageKey];
            if([idEmergencyMessage isKindOfClass:[NSString class]]){
                settings.emergencyMessage = (NSString *)idEmergencyMessage;
            }
            else{
                NSLog(@"The settings file was corrupted, the emergency message cannot be cast to NSString");
                settings.emergencyMessage = @"";
            }
            
            haveSettingsBeenLoaded = YES;
        }
        else {
            NSLog(@"The settings file was corrupted, it cannot be parsed to an NSDictionary");
            return;
        }
    }

}

+(BOOL)isFirstRun{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    return ![filemgr fileExistsAtPath: settingsFile];
}

+(NSString *)getUserName{
    if([self isFirstRun]){
        return @"";
    }
    
    if(!haveSettingsBeenLoaded){
        [self loadSettings];
    }
    return settings.userName;
}

+(NSArray*)getEmergencyContacts {
    if([self isFirstRun]){
        return [[NSArray alloc] init];
    }
    
    if(!haveSettingsBeenLoaded){
        [self loadSettings];
    }
    return settings.emergencyContacts;
}

+(NSString *)getEmergencyMessage{
    if([self isFirstRun]){
        return defaultEmergencyMessage;
    }
    
    if(!haveSettingsBeenLoaded){
        [self loadSettings];
    }
    return settings.emergencyMessage;
}

+(void)saveSettingsChanges:(Settings *)newSettings{
    settings = newSettings;
    
    NSDictionary *dic = [settings getNSDictionaryRepresentation];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    
    [fileMgr createFileAtPath: settingsFile contents: data attributes: nil];
}

@end
