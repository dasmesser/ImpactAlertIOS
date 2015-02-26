//
//  MainMenuViewController.m
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 09/01/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import "MainMenuViewController.h"
#import "FileManager.h"
#import "ConfigurationViewController.h"
#import "Constants.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

BOOL signedIn = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.startTrip setEnabled:NO];
    [self.legalNotice setEnabled:NO];
    [self.about setEnabled:NO];
    
    NSError *error = [FileManager isFirstRun];
    if(error) {
        if([[error domain] isEqual: decryptionError]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"The current username and password are incorrect. You will need to sign-in again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
        else if([[error domain] isEqual: readFromDiskError]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"This application is unable to access its files. Try re-entering your username and password, or contact your device manufacturer if the problem continues."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"The current username and password are incorrect. You will need to sign-in again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
        [self performSegueWithIdentifier:@"toLoggin" sender:self];
    }
    
    [self.centerLabel setAlpha:1.0];
    
    if(!signedIn){
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
        [request addValue:confirmation              forHTTPHeaderField:callTypeKey];
        [request addValue:[FileManager getUserID]   forHTTPHeaderField:idKey];
        
        // Create url connection and fire request
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [conn start];
        
    }
    else{
        [self.startTrip setEnabled:NO];
        [self.legalNotice setEnabled:NO];
        [self.about setEnabled:NO];
    }
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)data{
    receivedData = nil;
    
    CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)[data textEncodingName]);
    encoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (!receivedData){
        receivedData = [[NSMutableData alloc] initWithData:data];
    }
    else{
        [receivedData appendData:data];
    }
}

// all worked
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    response = [NSJSONSerialization JSONObjectWithData:receivedData
                                               options:kNilOptions
                                                 error:nil];
    NSString *status = [response valueForKey:@"status"];
    if([status isEqualToString:@"ok"]){
        [self.startTrip setEnabled:NO];
        [self.legalNotice setEnabled:NO];
        [self.about setEnabled:NO];
        
        [self.centerLabel setAlpha:0.0];
        
        signedIn = YES;
    }
    else if([status isEqualToString:@"notok"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Subscription ended"
                                                        message:@"Your subscription has ended, please contact ImpactAlert to renew it."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    else if([status isEqualToString:@"alert"]){
        
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Error retrieving data, %@", [error localizedDescription]);
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    return [protectionSpace.authenticationMethod
            isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if ([challenge.protectionSpace.authenticationMethod
         isEqualToString:NSURLAuthenticationMethodServerTrust]){
        // we only trust our own domain
        if ([challenge.protectionSpace.host isEqualToString:@"www.cocoanetics.com"]){
            NSURLCredential *credential =
            [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        }
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*if([segue.identifier isEqualToString:@"toConfigurationSegue"]){
        ConfigurationViewController *destinyViewController = segue.destinationViewController;
        destinyViewController.isFirstRun = [FileManager isFirstRun];
    }*/
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
