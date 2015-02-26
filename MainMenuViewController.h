//
//  MainMenuViewController.h
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 09/01/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController<NSURLConnectionDelegate>{
    NSMutableData *receivedData;
    NSDictionary *response;
    NSStringEncoding encoding;
    
    NSString *userID;
}

@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (weak, nonatomic) IBOutlet UIButton *startTrip;
@property (weak, nonatomic) IBOutlet UIButton *about;
@property (weak, nonatomic) IBOutlet UIButton *legalNotice;
@end
