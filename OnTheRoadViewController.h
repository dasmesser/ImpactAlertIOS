//
//  OnTheRoadViewController.h
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 20/02/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnTheRoadViewController : UIViewController <UIAlertViewDelegate, NSURLConnectionDelegate>{
    NSMutableData *receivedData;
    NSDictionary *response;
    NSStringEncoding encoding;
    
    NSString *userID;
    NSString *gps;
}
@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *secondaryButton;
- (IBAction)mainButtonAction:(id)sender;
//- (IBAction)secondaryButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *secondaryButtonAction;


@end
