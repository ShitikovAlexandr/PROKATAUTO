//
//  MainTabBaController.m
//  ProkatAuto31
//
//  Created by MacUser on 12.09.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "MainTabBaController.h"
#import "SWRevealViewController.h"

@interface MainTabBaController ()



@end

@implementation MainTabBaController

- (void)viewDidLoad {
    [super viewDidLoad];
        

    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }
                                             forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateSelected];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:9.f]} forState:(UIControlStateNormal)];
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
