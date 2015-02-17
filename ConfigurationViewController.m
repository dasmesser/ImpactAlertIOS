//
//  ConfigurationViewController.m
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 15/01/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "Settings.h"
#import "QuartzCore/QuartzCore.h"
#import "FileManager.h"
#import "MainConfigurationAndEmergencyContactsContector.h"

@interface ConfigurationViewController ()

@end

@implementation ConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.emergencyMessageField.delegate = self;
    self.emergencyMessageField.layer.cornerRadius = 5.0;
    
    BOOL isFirstRun;
    
    if([MainConfigurationAndEmergencyContactsContector isReturningFromEmergencyContacts]){
        self.name = [FileManager getUserName];
        self.emergencyContacts = [MainConfigurationAndEmergencyContactsContector getEmergencyContacts];
        self.emergencyMessage = [FileManager getEmergencyMessage];
        
        isFirstRun = NO;
        [MainConfigurationAndEmergencyContactsContector clear];
    }
    else{
        self.name = [FileManager getUserName];
        self.emergencyContacts = [FileManager getEmergencyContacts];
        self.emergencyMessage = [FileManager getEmergencyMessage];
        
        isFirstRun = [FileManager isFirstRun];
    }
    
    if(isFirstRun){
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Welcome to ImpactAlert"
            message:@"This is an application aimed at helping you contact emergency services or loved ones in the event of a bike accident."
            delegate:nil
            cancelButtonTitle:@"Next"
            otherButtonTitles:nil];
        
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Let's get started"
            message:@"Please take a moment to make the initial configurations (you will be able to change them anytime in the future)."
            delegate:nil
            cancelButtonTitle:@"Start"
            otherButtonTitles:nil];
        
        [alert2 show];
        [alert1 show];
        
        self.emergencyContactsSelectedLabel.text = @"You have not selected any emergency contacts";
        
        self.nameField.text = self.name;
        self.emergencyMessageField.text = self.emergencyMessage;
    }else if([self.emergencyContacts count] == 0) {
        self.emergencyContactsSelectedLabel.text = @"You have not selected any emergency contacts";
        
        self.nameField.text = self.name;
        self.emergencyMessageField.text = self.emergencyMessage;
    }else {
        self.nameField.text = self.name;
        self.emergencyMessageField.text = self.emergencyMessage;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
}

#pragma mark - Screen Scrolling

- (IBAction)textFieldDidBeginEditing:(UITextField *)textField{
    [self animateTextField:textField up:YES];
}

- (IBAction)textFieldDidEndEditing:(UITextField *)textField{
    [self animateTextField:textField up:NO];
    self.name = textField.text;
    
    if([self.name length] != 0 && [self.emergencyContacts count] != 0 && [self.emergencyMessage length] != 0){
        self.saveButton.enabled = YES;
    }
    else{
        self.saveButton.enabled = NO;
    }
}

- (IBAction)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
}

int emergencyMsgFieldHeigth;

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self animateTextField:textView up:YES];
    emergencyMsgFieldHeigth = textView.frame.size.height;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self animateTextField:textView up:NO];
    self.emergencyMessage = textView.text;
    
    if([self.name length] != 0 && [self.emergencyContacts count] != 0 && [self.emergencyMessage length] != 0){
        self.saveButton.enabled = YES;
    }
    else{
        self.saveButton.enabled = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return FALSE;
    }
    else if(emergencyMsgFieldHeigth != textView.frame.size.height){
        //Sometimes the heigth of the textView will increase and we will need to scroll a little more
        [self emergencyMsgField:textView scroll: emergencyMsgFieldHeigth - textView.frame.size.height];
        emergencyMsgFieldHeigth = textView.frame.size.height;
    }
    return TRUE;
}

- (void)animateTextField:(UIView *)textHolder up:(BOOL)up{
    int animatedDistance;
    int moveUpValue = textHolder.frame.origin.y+ textHolder.frame.size.height;
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        //216 = size of keyboard
        //480 = size of iPhone 4S, which this calculation uses as reference
        //if the screen is much more
        animatedDistance = moveUpValue - 216 -
            ((screenHeight - 480) > 0 ? (screenHeight - 480) : 0); //216 = size of keyboard
    }
    else{
        animatedDistance = moveUpValue - 162; 
    }
    
    if(animatedDistance>0){
        const int movementDistance = animatedDistance;
        const float movementDuration = 0.3f;
        int movement = (up ? -movementDistance : movementDistance);
        
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}

- (void)emergencyMsgField:(UITextView *) textField scroll:(int)distance{
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3f];
    self.view.frame = CGRectOffset(self.view.frame, 0, distance);
    [UIView commitAnimations];
}

#pragma mark - Button Listeners

- (IBAction)saveChanges:(id)sender {
    Settings *settings = [Settings new];
    
    settings.userName =             self.name;
    settings.emergencyContacts =    self.emergencyContacts;
    settings.emergencyMessage =     self.emergencyMessage;
    
    if([settings.userName  isEqualToString: @""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User name not provided"
                                                         message:@"Please provide us with your name."
                                                        delegate:nil
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
        
        [alert show];
    }
    else if([settings.emergencyContacts count] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contacts not selected"
                                                        message:@"Please select your emergency contacts."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];

    }
    else if([settings.emergencyMessage isEqualToString: @""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No emergency message"
                                                        message:@"Please write the message your contacts will receive in case of an incident."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }else{
        [FileManager saveSettingsChanges:settings];
        [self performSegueWithIdentifier:@"saveSegue" sender:self];
    }
}

- (IBAction)cancelConfiguration:(id)sender {
    
    if([FileManager isFirstRun]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save your settings"
                                                        message:@"This is the first time you have used the application, please go through the initial configurations"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    else{
        [self performSegueWithIdentifier:@"cancelSegue" sender:self];
    }
}



@end
