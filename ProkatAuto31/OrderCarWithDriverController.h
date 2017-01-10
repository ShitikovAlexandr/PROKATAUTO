//
//  OrderCarWithDriverController.h
//  ProkatAuto31
//
//  Created by Ivan Bielko on 22.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarWithDriver.h"
#import "RCTextField.h"

@interface OrderCarWithDriverController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet RCTextField *nameField;
@property (weak, nonatomic) IBOutlet RCTextField *phoneField;
@property (weak, nonatomic) IBOutlet RCTextField *emailField;
@property (weak, nonatomic) IBOutlet UIImageView *captchaImageView;
@property (weak, nonatomic) IBOutlet RCTextField *descriptionField;
@property (weak, nonatomic) IBOutlet RCTextField *captchaField;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet RCTextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *sendOrderButton;
@property (weak, nonatomic) IBOutlet UILabel *contactDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *captchaLabel;

@property (strong, nonatomic) CarWithDriver *car;

@end
