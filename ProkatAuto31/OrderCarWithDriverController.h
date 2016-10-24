//
//  OrderCarWithDriverController.h
//  ProkatAuto31
//
//  Created by Ivan Bielko on 22.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarWithDriver.h"
#import "RCTextField.h"

@interface OrderCarWithDriverController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet RCTextField *nameField;
@property (weak, nonatomic) IBOutlet RCTextField *phoneField;
@property (weak, nonatomic) IBOutlet RCTextField *emailField;
@property (weak, nonatomic) IBOutlet RCTextField *descriptionField;
@property (weak, nonatomic) IBOutlet UIButton *sendOrderField;

@property (strong, nonatomic) CarWithDriver *car;

@end
