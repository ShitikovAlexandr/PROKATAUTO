//
//  SMSController.h
//  ProkatAuto31
//
//  Created by alex on 09.11.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTextField.h"

@interface SMSController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet RCTextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) id nextController;

@end
