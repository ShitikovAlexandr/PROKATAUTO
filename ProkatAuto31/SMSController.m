//
//  SMSController.m
//  ProkatAuto31
//
//  Created by alex on 09.11.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "SMSController.h"
#import "ServerManager.h"
#import "SWRevealViewController.h"

@interface SMSController ()

@property (strong, nonatomic) NSString *codeText;

@end

@implementation SMSController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self styleRCButton:self.registerButton];
    self.codeTextField.delegate =self;
    
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
    
    [self.registerButton addTarget:self action:@selector(sendRegisterCode) forControlEvents:UIControlEventTouchDown];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) myCustomBack {
    if (self.nextController) {
        [self.navigationController pushViewController:self.nextController animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    
    self.codeText = textField.text;
    
    return YES;
    
}

-(BOOL)textFieldShouldReturn:(RCTextField *)textField {
        [textField resignFirstResponder];
    return YES;
}



- (void) sendRegisterCode {
    
    [self.codeTextField resignFirstResponder];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults valueForKey:@"tokenString"];
    
    [[ServerManager sharedManager] validatePhoneWithCode:self.codeText
                                               withToken:token
                                               OnSuccess:^(NSString *resualtString) {
                                                   NSString *masege = NSLocalizedString (@"Thank You for registration", nil);
                                                   [self doneActionWithMasegr:masege];
                                                   
                                               }
                                                  onFail:^(NSString *detail) {
                                                      if (detail) {
                                                          [self errorActionWithMasegr:detail];

                                                      }
                                                      
                                                  }];
    
    
    
}

- (void) errorActionWithMasegr: (NSString*) masege {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                @"" message:masege preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
- (void) doneActionWithMasegr: (NSString*) masege {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                @"" message:masege preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                                                       [self presentViewController:vc animated:YES completion:nil];
                                                   }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}








@end
