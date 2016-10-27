//
//  RememberPasswordController.h
//  ProkatAuto31
//
//  Created by alex on 26.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTextField.h"

@interface RememberPasswordController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UITextField *countryCode;
@property (weak, nonatomic) IBOutlet RCTextField *phoneNumber;
@property (weak, nonatomic) IBOutlet RCTextField *captchaValue;
@property (weak, nonatomic) IBOutlet UIImageView *captchaImg;
@property (weak, nonatomic) IBOutlet UIButton *getNewPasswordButton;

@end
