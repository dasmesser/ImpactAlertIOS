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
#import "RNCryptor/RNCryptor/RNCryptor/RNDecryptor.h"
#import "RNCryptor/RNCryptor/RNCryptor/RNEncryptor.h"


#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation FileManager

NSString *username;
NSString *password;
NSString *userID;

+(NSError *) verifyConfigFile{
    
    //if the configuration file has been verified, don't do it again
    if(username && password){
        return nil;
    }
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:configFileName];
    
    NSData *databuffer = [filemgr contentsAtPath: path];
    
    if(databuffer == nil){
        NSLog(@"Couldn't read config file");
        return [[NSError alloc] initWithDomain:readFromDiskError code:0 userInfo:nil];
    }
    
    NSString *macAddress = [self getMacAddress];
    NSError *error = nil;
    NSData *decryptedData = [RNDecryptor decryptData:databuffer
                                        withPassword:macAddress
                                               error:&error];
    
    if(!decryptedData){
        if(error == nil){
            NSLog(@"Error dencrypting config file: NO ERROR DESCRIPTION");
        }
        else{
            NSLog(@"Error dencrypting config file: %@", error.description);
        }
        return [[NSError alloc] initWithDomain:decryptionError code:0 userInfo:nil];
    }
    
    NSDictionary *dictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:decryptedData];
    
    username = [dictionary valueForKey:usernameKey];
    password = [dictionary valueForKey:passwordKey];
    userID = [dictionary valueForKey:idKey];
    
    if(!username || !password || !userID){
        NSLog(@"Error obtaining information from config file");
        return [[NSError alloc] initWithDomain:configInformationAccessError code:0 userInfo:nil];
    }
    
    return nil;
}

+(NSError *)isFirstRun{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:configFileName];
    
    if(![filemgr fileExistsAtPath: path]){
        return nil;
    }
    
    return [self verifyConfigFile];
}

+(NSString *)getUsername{
    if(!username){
        return @"No username registered";
    }
    
    return username;
}

+(NSString *)getPassword{
    if(!password){
        return @"No password registered";
    }
    
    return password;
}

+(NSString *)getUserID{
    if(!userID){
        return @"No userID registered";
    }
    
    return userID;
}

+(NSError *) saveUsername:(NSString *)username password:(NSString *)password andId:(NSString *)userID{
    NSDictionary *dic = @{usernameKey : username,
                          passwordKey : password,
                          idKey       : userID};
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    NSString *macAddress = [self getMacAddress];
    
    NSError *error = nil;
    
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:macAddress
                                               error:&error];
    if(!encryptedData){
        if(error == nil){
            NSLog(@"Error encrypting config file: NO ERROR DESCRIPTION");
        }
        else{
            NSLog(@"Error encrypting config file: %@", error.description);
        }
        return [[NSError alloc] initWithDomain:encryptionError code:0 userInfo:nil];
    }
    
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:configFileName];
    
    if([fileMgr createFileAtPath: path contents: encryptedData attributes: nil]){
        BOOL created = [fileMgr fileExistsAtPath: path];
        return nil;
    }
    
    NSLog(@"Error saving document");
    return [[NSError alloc] initWithDomain:writeToDiskError code:0 userInfo:nil];
}

# pragma mark - Get MAC Address

+ (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    //NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

/*+(void)saveSettingsChanges:(Settings *)newSettings{
    settings = newSettings;
    
    NSDictionary *dic = [settings getNSDictionaryRepresentation];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    
    [fileMgr createFileAtPath: settingsFile contents: data attributes: nil];
}*/

@end
