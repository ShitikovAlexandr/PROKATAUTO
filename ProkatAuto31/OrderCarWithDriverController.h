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

@interface OrderCarWithDriverController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet RCTextField *nameField;
@property (weak, nonatomic) IBOutlet RCTextField *phoneField;
@property (weak, nonatomic) IBOutlet RCTextField *emailField;
@property (weak, nonatomic) IBOutlet UIImageView *captchaImageView;
@property (weak, nonatomic) IBOutlet RCTextField *descriptionField;
@property (weak, nonatomic) IBOutlet UIButton *sendOrderField;
@property (weak, nonatomic) IBOutlet RCTextField *captchaField;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet RCTextField *codeField;

@property (strong, nonatomic) CarWithDriver *car;

@end
