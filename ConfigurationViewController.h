//
//  ConfigurationViewController.h
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 15/01/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigurationViewController : UIViewController<UITextViewDelegate>{
    UITextView *_emergencyMessageField;
}
//@property BOOL isFirstRun;

@property NSArray *emergencyContacts;
@property NSString *name;
@property NSString *emergencyMessage;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *emergencyContactsSelectedLabel;
@property (nonatomic, retain) IBOutlet UITextView *emergencyMessageField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

//Methods for nameField IBOutlet handling
- (IBAction)textFieldDidBeginEditing:(UITextField *)textField;
- (IBAction)textFieldDidEndEditing:(UITextField *)textField;
- (IBAction)textFieldReturn:(id)sender;

//Methods for emergencyMessageField IBOutlet handling
- (void)textViewDidBeginEditing:(UITextView *)textView;
- (void)textViewDidEndEditing:(UITextView *)textView;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

//Button listeners
- (IBAction)saveChanges:(id)sender;
- (IBAction)cancelConfiguration:(id)sender;



@end
