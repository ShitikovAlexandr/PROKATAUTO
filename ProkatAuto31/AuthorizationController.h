//
//  AuthorizationController.h
//  ProkatAuto31
//
//  Created by alex on 26.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTextField.h"


@interface AuthorizationController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet RCTextField *CountryCode;
@property (weak, nonatomic) IBOutlet RCTextField *PhoneNumber;
@property (weak, nonatomic) IBOutlet RCTextField *password;

@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *EnterButton;
@property (weak, nonatomic) IBOutlet UIButton *RegisterButton;

@property (strong, nonatomic ) id nextController;
@property (strong, nonatomic ) id backController;




@end
