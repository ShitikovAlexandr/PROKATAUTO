//
//  SMSController.m
//  ProkatAuto31
//
//  Created by alex on 09.11.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "SMSController.h"
#import "ServerManager.h"

@interface SMSController ()

@property (strong, nonatomic) NSString *codeText;

@end

@implementation SMSController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Регистрация";
    
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

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) myCustomBack {
        [self.navigationController popViewControllerAnimated:YES];
}

- (void) styleRCButton: (UIButton*) button {
    
    button.layer.cornerRadius = 3.f;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor blackColor].CGColor;
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


- (void) sendRegisterCode {
    [self.codeTextField resignFirstResponder];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults valueForKey:@"tokenString"];
    
    [[ServerManager sharedManager] validatePhoneWithCode:self.codeText
                                               withToken:token
                                               OnSuccess:^(NSString *resualtString) {
                                                   
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








@end
