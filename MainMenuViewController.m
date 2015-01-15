//
//  MainMenuViewController.m
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 09/01/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import "MainMenuViewController.h"
#import "FileManager.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([FileManager isFirstRun]) {
        
    } else {
        
    }
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

@end
