//
//  EmergencyContactSelectionTableViewController.h
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 20/01/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmergencyContactSelectionTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSArray *contactList;
@property(strong, nonatomic) NSArray *selectedContacts;

@end
