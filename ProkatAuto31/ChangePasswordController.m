//
//  ChangePasswordController.m
//  ProkatAuto31
//
//  Created by alex on 02.11.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "ChangePasswordController.h"
#import "SWRevealViewController.h"
#import "ServerManager.h"

@interface ChangePasswordController ()

@property (strong, nonatomic) NSString *passwordOldText;
@property (strong, nonatomic) NSString *passwordNewText;
@property (strong, nonatomic) NSString *passwordNewConfirmText;



@end

@implementation ChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.alertView.layer.cornerRadius = 2.f;
    self.alertView.layer.borderWidth = 0.5f;
    self.alertView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.alertView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.alertView.layer.shadowOffset = CGSizeMake(2.f, 2.0f);
    self.alertView.layer.shadowRadius = 2.0f;
    self.alertView.layer.shadowOpacity = 2.0f;
    self.alertView.layer.masksToBounds = NO;
    self.alertView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.alertView.bounds cornerRadius:self.alertView.layer.cornerRadius].CGPath;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    [self styleRCButton:self.doneButton];
    [self.doneButton addTarget:self action:@selector(changePassword) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) myCustomBack {
    SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) styleRCButton: (UIButton*) button {
    
    button.layer.cornerRadius = 3.f;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor clearColor].CGColor;
    button.layer.masksToBounds = YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(RCTextField *)textField {
        [textField starEditeffect:textField];
   
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(RCTextField *)textField {
        [textField EndEditeffect:textField];
    if (textField.tag == 0) {
        self.passwordOldText = textField.text;
    } else if (textField.tag == 1) {
        self.passwordNewText = textField.text;
    } else if (textField.tag == 2) {
        self.passwordNewConfirmText = textField.text;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(RCTextField *)textField {
    UIView *view = [self.view viewWithTag:textField.tag + 1];
    if (!view)
        [textField resignFirstResponder];
    else
        [view becomeFirstResponder];
    return YES;
}


#pragma mark - API

- (void) changePassword {

   [self.oldPasswordInput resignFirstResponder];
   [self.passwordNew resignFirstResponder];
   [self.retryNewPassword resignFirstResponder];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults valueForKey:@"tokenString"];
    
    [[ServerManager sharedManager] changePasswordWithToken:token
                                               OldPassword:self.passwordOldText
                                               newPassword:self.passwordNewText
                                             RetryPassword:self.passwordNewConfirmText
                                                 OnSuccess:^(NSString *massage) {
                                                        [self passwordChangeTextFieldInput:NSLocalizedString(@"The password has been changed succesfully", nil)];
                                                 }
                                                    onFail:^(NSArray* errorArray, NSError *error) {
                                                        
                                                        if ([errorArray count] > 0) {
                                                            NSString* newString = [[[errorArray objectAtIndex:0]objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                                                            [self ErrorTextFieldInput:[NSString stringWithFormat:@"%@",newString]];
                                                        } else if (error.code == -1009) {
                                                            [self passwordChangeTextFieldInput:NSLocalizedString(@"Check your internet connection!", nil)];
                                                        } else {
                                                            [self passwordChangeTextFieldInput:NSLocalizedString(@"The password has been changed succesfully", nil)];
                                                        }

                                                        
                                                        
                                                    }];
}

#pragma mark - Alert
    
- (void) ErrorTextFieldInput: (NSString*) errorText {
    
    UIAlertController *alert = nil;
    alert = [UIAlertController alertControllerWithTitle:
                  errorText message:nil preferredStyle:UIAlertControllerStyleAlert];
   
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }];
    
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void) passwordChangeTextFieldInput: (NSString*) errorText {
    
    UIAlertController *alert = nil;
    alert = [UIAlertController alertControllerWithTitle:
             errorText message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                                                         [self presentViewController:vc animated:YES completion:nil];

                                                         
                                                     }];
    
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}







@end
