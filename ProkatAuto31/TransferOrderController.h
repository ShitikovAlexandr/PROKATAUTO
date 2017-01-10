//
//  TransferOrderController.h
//  ProkatAuto31
//
//  Created by Ivan Bielko on 04.11.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTextField.h"
#import "Category.h"

@interface TransferOrderController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet Category *category;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactDataLabel;
@property (weak, nonatomic) IBOutlet RCTextField *nameField;
@property (weak, nonatomic) IBOutlet RCTextField *codeField;
@property (weak, nonatomic) IBOutlet UILabel *countryField;
@property (weak, nonatomic) IBOutlet RCTextField *phoneField;
@property (weak, nonatomic) IBOutlet RCTextField *emailField;
@property (weak, nonatomic) IBOutlet RCTextField *carField;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet RCTextField *placeField;
@property (weak, nonatomic) IBOutlet RCTextField *destinationField;
@property (weak, nonatomic) IBOutlet RCTextField *passagersField;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet RCTextField *commentField;
@property (weak, nonatomic) IBOutlet UIImageView *captchaImageView;
@property (weak, nonatomic) IBOutlet UILabel *captchaLabel;
@property (weak, nonatomic) IBOutlet RCTextField *captchaField;
@property (weak, nonatomic) IBOutlet UIButton *sendOrderButton;

@property (weak, nonatomic) IBOutlet RCTextField *dateField;
@property (weak, nonatomic) IBOutlet RCTextField *timeField;

@end
