//
//  LogginViewController.m
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 16/02/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import "LogginViewController.h"
#import "Constants.h"
#import "FileManager.h"

@interface LogginViewController ()

@end

@implementation LogginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signIn:(id)sender {
    username = self.usernameField.text;
    password = self.passwordField.text;
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
    [request addValue:loggin forHTTPHeaderField:callTypeKey];
    [request addValue:username forHTTPHeaderField:usernameKey];
    [request addValue:password forHTTPHeaderField:passwordKey];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    
    [self.signInButton setEnabled:NO];
    [self.signInButton setTitle:@"Processing..." forState:UIControlStateDisabled];
    
}

- (IBAction)usernameEndEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)passwordEndEditing:(id)sender{
    [sender resignFirstResponder];
}

#pragma mark - WebConnection

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
    //[NSDictionary alloc] initWith
    
    response = [NSJSONSerialization JSONObjectWithData:receivedData
                                                         options:kNilOptions
                                                           error:nil];
    
    [self.signInButton setEnabled:YES];
    [self.signInButton setTitle:@"Sign in" forState:UIControlStateDisabled];

    if([[response valueForKey:@"status"] isEqualToString:@"ok"]){
        [FileManager saveUsername:username password:password andId:[response valueForKey:@"id"]];
        [self performSegueWithIdentifier:@"toMainMenu" sender:self];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication error"
                                                        message:@"The username and/or password provided were incorrect. Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
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


@end
