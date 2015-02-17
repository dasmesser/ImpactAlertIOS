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

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if([FileManager isFirstRun]) {
        [self performSegueWithIdentifier:@"toConfigurationSegue" sender:self];
    }
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
