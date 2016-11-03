//
//  ChangePasswordController.h
//  ProkatAuto31
//
//  Created by alex on 02.11.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTextField.h"

@interface ChangePasswordController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet RCTextField *oldPasswordInput;
@property (weak, nonatomic) IBOutlet RCTextField *passwordNew;
@property (weak, nonatomic) IBOutlet RCTextField *retryNewPassword;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end
