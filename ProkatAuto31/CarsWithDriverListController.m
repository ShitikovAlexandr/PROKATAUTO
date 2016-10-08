//
//  CarsWithDriverListController.m
//  ProkatAuto31
//
//  Created by Ivan Bielko on 08.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "CarsWithDriverListController.h"

@interface CarsWithDriverListController ()
@end

@implementation CarsWithDriverListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
}

-(void) myCustomBack {
    // Some anything you need to do before leaving
    [self.navigationController popViewControllerAnimated:YES];
}


@end
