//
//  OnTheRoadViewController.m
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 20/02/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import "OnTheRoadViewController.h"
#import "Constants.h"
#import "FileManager.h"
#import <CoreLocation/CoreLocation.h>

@interface OnTheRoadViewController ()

@end

@implementation OnTheRoadViewController

BOOL inMonitoringState = NO;
NSThread *thread;

NSString *mainButtonNoMonitoringText = @"START MONITORING";
NSString *mainButtonMonitoringText = @"STOP MONITORING";
NSString *secondaryButtonNoMonitoringText = @"Go back to Main Menu";
NSString *secondaryButtonMonitoringText = @"Send emergency signal";

int numberOfDistressTries = 0;
int maxNumberOfDistressTries = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mainButtonAction:(id)sender {
    if(inMonitoringState){
        inMonitoringState = NO;

        //set text to both buttons
        [self.mainButton setTitle:mainButtonNoMonitoringText forState:UIControlStateNormal];
        [self.mainButton setTitle:mainButtonNoMonitoringText forState:UIControlStateHighlighted];
        [self.mainButton setTitle:mainButtonNoMonitoringText forState:UIControlStateDisabled];
        [self.mainButton setTitle:mainButtonNoMonitoringText forState:UIControlStateSelected];
        
        [self.secondaryButton setTitle:secondaryButtonNoMonitoringText forState:UIControlStateNormal];
        [self.secondaryButton setTitle:secondaryButtonNoMonitoringText forState:UIControlStateHighlighted];
        [self.secondaryButton setTitle:secondaryButtonNoMonitoringText forState:UIControlStateDisabled];
        [self.secondaryButton setTitle:secondaryButtonNoMonitoringText forState:UIControlStateSelected];
        
        //finish thread
        [thread cancel];
    }
    else{
        inMonitoringState = YES;
        
        //set text to both buttons
        [self.mainButton setTitle:mainButtonMonitoringText forState:UIControlStateNormal];
        [self.mainButton setTitle:mainButtonMonitoringText forState:UIControlStateHighlighted];
        [self.mainButton setTitle:mainButtonMonitoringText forState:UIControlStateDisabled];
        [self.mainButton setTitle:mainButtonMonitoringText forState:UIControlStateSelected];
        
        [self.secondaryButton setTitle:secondaryButtonMonitoringText forState:UIControlStateNormal];
        [self.secondaryButton setTitle:secondaryButtonMonitoringText forState:UIControlStateHighlighted];
        [self.secondaryButton setTitle:secondaryButtonMonitoringText forState:UIControlStateDisabled];
        [self.secondaryButton setTitle:secondaryButtonMonitoringText forState:UIControlStateSelected];
        
        //start thread
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(backgroundMonitoring) object:nil];
        
        [thread start];
        
    }
}

- (IBAction)secondaryButtonAction:(id)sender {
    if(inMonitoringState){
        inMonitoringState = NO;
        
        //set text to both buttons
        [self.mainButton setTitle:mainButtonNoMonitoringText forState:UIControlStateNormal];
        [self.mainButton setTitle:mainButtonNoMonitoringText forState:UIControlStateHighlighted];
        [self.mainButton setTitle:mainButtonNoMonitoringText forState:UIControlStateDisabled];
        [self.mainButton setTitle:mainButtonNoMonitoringText forState:UIControlStateSelected];
        
        [self.secondaryButton setTitle:secondaryButtonNoMonitoringText forState:UIControlStateNormal];
        [self.secondaryButton setTitle:secondaryButtonNoMonitoringText forState:UIControlStateHighlighted];
        [self.secondaryButton setTitle:secondaryButtonNoMonitoringText forState:UIControlStateDisabled];
        [self.secondaryButton setTitle:secondaryButtonNoMonitoringText forState:UIControlStateSelected];
        
        //finish thread
        [thread cancel];
        
        [self sendDistressSignal];
        
        [self performSegueWithIdentifier:@"toDistressSignal" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"toMainMenu" sender:self];
    }
}

-(void)backgroundMonitoring{
    BOOL warningTriggered = YES;
    
    while(![thread isCancelled]){
        
        
        
        
        
        
        
        
        
        
        
        if(warningTriggered){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey!"
                                                            message:@"Are you OK?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No, please call for help"
                                                  otherButtonTitles:@"Yes, I am alright", nil];
            
            [alert show];
            break;
        }
    }
}

-(void)sendDistressSignal{
    userID = [FileManager getUserID];
    gps = [self getGPSLocation];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
    [request addValue:userID    forHTTPHeaderField:idKey];
    [request addValue:gps       forHTTPHeaderField:gpsKey];
    [request addValue:alert     forHTTPHeaderField:callTypeKey];
    [request addValue:red       forHTTPHeaderField:alertKey];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}

-(NSString *)getGPSLocation{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    [locationManager startUpdatingLocation];
    
    float latitude = locationManager.location.coordinate.latitude;
    float longitude = locationManager.location.coordinate.longitude;
    
    [locationManager stopUpdatingLocation];
    
    return [[NSString alloc] initWithFormat:@"%f, %f", latitude, longitude];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        NSLog(@"An alert fired and was confirmed by the user");
        
        userID = [FileManager getUserID];
        gps = [self getGPSLocation];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
        [request addValue:userID    forHTTPHeaderField:idKey];
        [request addValue:gps       forHTTPHeaderField:gpsKey];
        [request addValue:alert     forHTTPHeaderField:callTypeKey];
        [request addValue:red       forHTTPHeaderField:alertKey];
        
        // Create url connection and fire request
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [conn start];
    }
    else
    {
        NSLog(@"An alert fired but was shot down by the user");
        
        //restart monitoring thread
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(backgroundMonitoring) object:nil];
        [thread start];
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
    
    if([[response valueForKey:@"status"] isEqualToString:@"ok"]){
        //Notify user the alert has been sent
        
        
    }
    else{
        if(numberOfDistressTries++ < maxNumberOfDistressTries){
            userID = [FileManager getUserID];
            gps = [self getGPSLocation];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
            [request addValue:userID    forHTTPHeaderField:idKey];
            [request addValue:gps       forHTTPHeaderField:gpsKey];
            [request addValue:alert     forHTTPHeaderField:callTypeKey];
            [request addValue:red       forHTTPHeaderField:alertKey];
            
            // Create url connection and fire request
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
        }
        else{
            //Notigy user something is wrong with the alert system
        }
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
