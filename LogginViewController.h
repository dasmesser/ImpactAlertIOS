//
//  LogginViewController.h
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 16/02/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogginViewController : UIViewController<NSURLConnectionDelegate>{
    NSMutableData *receivedData;
    NSDictionary *response;
    NSStringEncoding encoding;
    
    NSString *username;
    NSString *password;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

- (IBAction)signIn:(id)sender;
- (IBAction)usernameEndEditing:(id)sender;
- (IBAction)passwordEndEditing:(id)sender;
@end
