//
//  ProfileController.h
//  ProkatAuto31
//
//  Created by alex on 31.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileController : UITableViewController
@property (weak, nonatomic) IBOutlet UIView *orderView;
@property (weak, nonatomic) IBOutlet UIView *personalDataView;
@property (weak, nonatomic) IBOutlet UIView *passportView;
@property (weak, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UIView *driverLicenceView;


- (void) setRCStyleOfView: (UIView*) view;

@end
