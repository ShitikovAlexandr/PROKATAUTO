//
//  ProfileController.m
//  ProkatAuto31
//
//  Created by alex on 31.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

/*
 @"tokenString"
 @"firstName"
 @"lastName"
 @"fatherName"
 @"phone"
 @"dateOfBirth"
 @"passportSeries"
 @"passportNumber"
 @"passportIssueDate"
 */

#import "ProfileController.h"
#import "SWRevealViewController.h"
#import "ServerManager.h"

@interface ProfileController ()

//main info
@property (weak, nonatomic) IBOutlet UILabel *ordersCount;
@property (weak, nonatomic) IBOutlet UILabel *arrears;
@property (weak, nonatomic) IBOutlet UILabel *fines;
@property (weak, nonatomic) IBOutlet UILabel *clientType;
//personal data
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBirth;
//passport data
@property (weak, nonatomic) IBOutlet UILabel *siriesAndNumberPassport;
@property (weak, nonatomic) IBOutlet UILabel *dateOfPassport;
// adresses
@property (weak, nonatomic) IBOutlet UILabel *mainAdress;
@property (weak, nonatomic) IBOutlet UILabel *realAdress;
// driver's
@property (weak, nonatomic) IBOutlet UILabel *siriesAndNumberLicense;
@property (weak, nonatomic) IBOutlet UILabel *dateLicense;



@end

@implementation ProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Мой профиль";
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    [self setRCStyleOfView:self.orderView];
    [self setRCStyleOfView:self.personalDataView];
    [self setRCStyleOfView:self.passportView];
    [self setRCStyleOfView:self.registerView];
    [self setRCStyleOfView:self.driverLicenceView];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.fullName.text = [NSString stringWithFormat:@"%@ %@ %@", [defaults valueForKey:@"lastName"],
                                                                 [defaults valueForKey:@"firstName"],
                                                                 [defaults valueForKey:@"fatherName"]];
    self.phoneNumber.text = [NSString stringWithFormat:@"+ %@", [defaults valueForKey:@"phone"]];
    self.dateOfBirth.text = [self dataFormaterMethod:[defaults valueForKey:@"dateOfBirth"]];
    self.siriesAndNumberPassport.text = [NSString stringWithFormat:@"%@ %@",[defaults valueForKey:@"passportSeries"],
                                                                            [defaults valueForKey:@"passportNumber"]];
    self.dateOfPassport.text = [NSString stringWithFormat:@"%@  %@", [self dataFormaterMethod:[defaults valueForKey:@"passportIssueDate"]],
                                                                     [defaults valueForKey:@"passport_issue"]];
    self.mainAdress.text = [defaults valueForKey:@"address"];
    self.realAdress.text = [defaults valueForKey:@"fakt_address"];
    
    self.siriesAndNumberLicense.text = [NSString stringWithFormat:@"%@ %@", [defaults valueForKey:@"license_series"],
                                                                 [defaults valueForKey:@"license_number"]];
    
    self.dateLicense.text = [self dataFormaterMethod:[defaults valueForKey:@"license_issue_date"]];

  

    
    
    
    
    /*
     @"address"
     @"fakt_address"
     [defaults setValue:newUser.passportIssue forKey:@"passport_issue"];
     [defaults setValue:newUser.licenseNumber forKey:@"license_number"];
     [defaults setValue:newUser.licenseSeries forKey:@"license_series"];
     [defaults setValue:newUser.licenseIssueDate forKey:@"license_issue_date"];
     [defaults setValue:newUser.licenseIssue forKey:@"license_issue"];

     */



    
    
    [self getOrderInfo];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setRCStyleOfView: (UIView*) view {
    
    view.layer.cornerRadius = 2.f;
    view.layer.borderWidth = 0.5f;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(2.f, 2.0f);
    view.layer.shadowRadius = 2.0f;
    view.layer.shadowOpacity = 2.0f;
    view.layer.masksToBounds = NO;
    
}

-(void) myCustomBack {
    
    SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [self presentViewController:vc animated:YES completion:nil];

}

- (NSString*) dataFormaterMethod: (NSString*) dataString {
    
    NSString* newDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dataString];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    newDate = [dateFormatter stringFromDate:dateFromString];
    
    return newDate;
}

#pragma mark - API

- (void) getOrderInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults valueForKey:@"tokenString"];
    NSLog(@"token %@", token);
    [[ServerManager sharedManager]  getProfileInfoWithToken:token
                                                  OnSuccess:^(NSNumber* days, NSNumber* orderCount, NSNumber* penalties, NSNumber* status) {
                                                      
                                                      self.ordersCount.text = [NSString stringWithFormat:@"%@", orderCount];
                                                      self.fines.text = [NSString stringWithFormat:@"%@ руб.", penalties];
                                                      
                                                      int arrears = [days integerValue]* [penalties integerValue];
                                                      self.arrears.text = [NSString stringWithFormat:@"%d руб.", arrears];
                                                      
                                                      if ([status integerValue]==1) {
                                                          self.clientType.text = @"Новый клиент";
                                                      } else if ([status integerValue] == 2) {
                                                          self.clientType.text = @"Постоянный клиент";
                                                      } else if ([status integerValue] == 3) {
                                                          self.clientType.text = @"VIP клиент";
                                                      }
                                                      
                                                      
                                                  }
                                                     onFail:^(NSError *error) {
                                                         
                                                     }];
}


@end
