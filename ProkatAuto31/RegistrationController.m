//
//  RegistrationController.m
//  ProkatAuto31
//
//  Created by alex on 18.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//


/*
  ** to get values use keys:
 
 @"tokenString"
 @"firstName"
 @"lastName"
 @"fatherName"
 @"phone"
 @"dateOfBirth"
 @"passportSeries"
 @"passportNumber"
 @"passportIssueDate"
 
 @"passport_issue"
 
 @"license_issue"
 @"license_series"
 @"license_number"
 @"license_issue_date"
 
 @"address"
 @"fakt_address"

  exemple:
 
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 NSLog(@"user saved data %@", [defaults valueForKey:@"tokenString"]);
 
 */

#import "RegistrationController.h"
#import "RCTextField.h"
#import "ServerManager.h"
#import "RCDatePicker.h"
#import "Person.h"
#import "User.h"

@interface RegistrationController ()
@property (strong, nonatomic) UIAlertController *alert;


@property (strong, nonatomic) UIPickerView *countriCodePicker;
@property (strong, nonatomic) NSDictionary *pickerDateArray;

//main info
@property (weak, nonatomic) IBOutlet RCTextField *surnameTextField;
@property (weak, nonatomic) IBOutlet RCTextField *nameTextField;
@property (weak, nonatomic) IBOutlet RCTextField *middleNameTextField;
@property (weak, nonatomic) IBOutlet RCTextField *emailTextField;
@property (weak, nonatomic) IBOutlet RCTextField *countryCodeTextField;
@property (weak, nonatomic) IBOutlet RCTextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet RCTextField *dateOfBirthTextField;

// passport info
@property (weak, nonatomic) IBOutlet RCTextField *passportSeriesTextField;
@property (weak, nonatomic) IBOutlet RCTextField *passportNumberTextField;
@property (weak, nonatomic) IBOutlet RCTextField *dateOfPassport;

// Driver's license info
@property (weak, nonatomic) IBOutlet RCTextField *driverLicenseTextField;
@property (weak, nonatomic) IBOutlet RCTextField *driverLicenseNumber;
@property (weak, nonatomic) IBOutlet RCTextField *drivelLicenseDate;

// password

@property (weak, nonatomic) IBOutlet RCTextField *firstPassword;
@property (weak, nonatomic) IBOutlet RCTextField *secondPassword;
@property (weak, nonatomic) IBOutlet UISwitch *switcherLicenseArg;
@property (weak, nonatomic) IBOutlet UIImageView *imageWithPassword;
@property (weak, nonatomic) IBOutlet RCTextField *passwordFromImage;

@property (strong, nonatomic) NSString *CapchaKey;
@property (strong, nonatomic) NSString *captchaValue;
@property (strong, nonatomic) RCDatePicker *datePicker;

@property (strong, nonatomic) Person *person;

@property (assign, nonatomic) NSInteger datePickerFlag;

@property (weak, nonatomic) IBOutlet UIButton *RegistrButton;

extern NSString *baseAddress;


@property (weak, nonatomic) IBOutlet UILabel *CountryNameLabel;

@property (strong, nonatomic) NSMutableArray *isTextFieldEnterText;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;



@end

@implementation RegistrationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.color = [UIColor blackColor];
    self.activityIndicatorView.center = self.view.center;
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];

    
    self.isTextFieldEnterText = [NSMutableArray array];
    self.person = [[Person alloc] init];
    self.person.countryCode = @"+7";
    [self getCapchaImg];
    
    // Do any additional setup after loading the view.
    
    self.pickerDateArray = [[NSDictionary alloc] init];
    self.countriCodePicker = [[UIPickerView alloc] init];
    self.countriCodePicker.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.countriCodePicker.layer.shadowColor = [UIColor grayColor].CGColor;
    self.countriCodePicker.layer.shadowOffset = CGSizeMake(0.f, -3.0f);
    self.countriCodePicker.layer.shadowRadius = 3;
    self.countriCodePicker.layer.shadowOpacity = 3;
    self.countriCodePicker.layer.masksToBounds = NO;
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.countryCodeTextField setInputAccessoryView:toolBar];
    self.countryCodeTextField.inputView = self.countriCodePicker;

    
    self.pickerDateArray = [self dataForPickerCountry];
    self.countriCodePicker.delegate = self;
    self.countriCodePicker.dataSource = self;
    self.countryCodeTextField.delegate = self;
    
    self.pickerDateArray = [self dataForPickerCountry];
    self.countryCodeTextField.placeholder =  [NSString stringWithFormat:@"%@", [self.pickerDateArray objectForKey:@"Russia"]];
    self.CountryNameLabel.text = @"Russia";
    
    [self.countriCodePicker selectRow:(int)[self.pickerDateArray objectForKey:@"Russia"] inComponent:0 animated:YES];
    
    [self.RegistrButton addTarget:self action:@selector(sendRegisterForm) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    
    [self styleRCButton:self.RegistrButton];

    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) doneButtonPressed:(id)sender  {
    
    [self.countryCodeTextField resignFirstResponder];
    self.countryCodeTextField.layer.shadowColor = [UIColor grayColor].CGColor;
    //self.countryCodeTextField.textColor = [UIColor blackColor];
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.pickerDateArray count];
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *str = [NSString stringWithFormat:@"%@ %@",[self.pickerDateArray allKeys][row], [self.pickerDateArray objectForKey:[self.pickerDateArray allKeys][row]]];
    
   return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *str = [NSString stringWithFormat:@"%@", [self.pickerDateArray objectForKey:[self.pickerDateArray allKeys][row]]];
    NSString *str2 = [NSString stringWithFormat:@"%@", [self.pickerDateArray allKeys][row]];
    
    self.countryCodeTextField.text = str;
    self.CountryNameLabel.text = str2;
    //save date
    NSLog(@"Select picker");
    
    
}



- (BOOL)textFieldShouldBeginEditing:(RCTextField *)textField {
    
    
    if (textField.tag !=6 && textField.tag !=7) {
        [textField starEditeffect:textField];
    }
    
    if (textField.tag == 7  || textField.tag == 10 || textField.tag == 13) {
        
        self.datePicker = [[RCDatePicker alloc] initWithShadowAndTextField:textField];
        [self.datePicker addTarget:self action:@selector (textFieldDidChange:) forControlEvents:UIControlEventValueChanged];
        self.datePicker.locale =  [NSLocale currentLocale];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        textField.inputView = self.datePicker;
        self.datePicker.maximumDate = [NSDate date];
    }
    
    if (textField.tag == 7) { // date
        self.datePickerFlag = 7;
    } else if (textField.tag == 10) { // date
        self.datePickerFlag = 10;
    } else if (textField.tag == 13) { // date
        self.datePickerFlag = 13;
    }
    
    
    
    
        return YES;
}

- (BOOL)textFieldShouldEndEditing:(RCTextField *)textField {
    if (textField.tag !=6 && textField.tag !=7) {
        [textField EndEditeffect:textField];
        
        if (textField.tag == 1) {
            self.person.surname = [NSString stringWithFormat:@"%@",textField.text];
        } else if (textField.tag == 2) {
            self.person.name = [NSString stringWithFormat:@"%@", textField.text];
        } else if (textField.tag == 3) {
            self.person.middleName = [NSString stringWithFormat:@"%@", textField.text];
        } else if (textField.tag == 4) {
            self.person.email = [NSString stringWithFormat:@"%@", textField.text];
        } else if (textField.tag == 5) {
            self.person.phoneNumber = [NSString stringWithFormat:@"%@", textField.text];
        } else if (textField.tag == 6) {
            self.person.countryCode = [NSString stringWithFormat:@"%@", textField.text];
        }  else if (textField.tag == 8) {
            self.person.passportSeries = [NSString stringWithFormat:@"%@", textField.text];
        } else if (textField.tag == 9) {
            self.person.passportNumber = [NSString stringWithFormat:@"%@", textField.text];
            self.person.driverLicense = [NSString stringWithFormat:@"%@", textField.text];
        } else if (textField.tag == 12) {
            self.person.driverLicenseNumber = [NSString stringWithFormat:@"%@", textField.text];
        } else if (textField.tag == 15) {
            self.person.Password = [NSString stringWithFormat:@"%@", textField.text];
        } else if (textField.tag == 16) {
            self.passwordFromImage.text = [NSString stringWithFormat:@"%@", textField.text];
        }
        else {
            self.datePickerFlag = 0;
        }


    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

-(void)textFieldDidChange:(UIDatePicker*) datePicker {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
    if (self.datePickerFlag == 7) {
        self.person.dateOfBirth = datePicker.date;
        self.dateOfBirthTextField.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.person.dateOfBirth]];
        NSLog(@"dateOfBirth%@", self.person.dateOfBirth);

    } else if (self.datePickerFlag == 10) {
        self.person.dateOfPassport = datePicker.date;
        self.dateOfPassport.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.person.dateOfPassport]];
        NSLog(@"dateOfPassport%@", self.person.dateOfPassport);


    } else if (self.datePickerFlag == 13) {
        self.person.drivelLicenseDate = datePicker.date;
        self.drivelLicenseDate.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.person.drivelLicenseDate]];
        NSLog(@"drivelLicenseDate%@", self.person.drivelLicenseDate);

    }
    
    
    
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

- (IBAction) sendRegisterForm {
    [self.activityIndicatorView startAnimating];

    
    [self chackTextfield];
    
    if ([self chackTextfield]) {
        
        [[ServerManager sharedManager] registrationWithPersonData:self.person
                                                           andKey:self.CapchaKey
                                                  PasswordFromImg:self.passwordFromImage.text
                                                        OnSuccess:^(NSString* token, id user) {
                                                            [self.activityIndicatorView stopAnimating];

                                                            // save data
                                                            
                                                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                            NSString *tokenString = token;
                                                            
                                                            [defaults setValue:tokenString forKey:@"tokenString"];

                                                            User *newUser = [[User alloc] init];
                                                            newUser = user;
                                                            [defaults setValue:newUser.firstName forKey:@"firstName"];
                                                            [defaults setValue:newUser.lastName forKey:@"lastName"];
                                                            [defaults setValue:newUser.fatherName forKey:@"fatherName"];
                                                            [defaults setValue:newUser.phone forKey:@"phone"];
                                                            [defaults setValue:newUser.dateOfBirth forKey:@"dateOfBirth"];
                                                            [defaults setValue:newUser.passportSeries forKey:@"passportSeries"];
                                                            [defaults setValue:newUser.passportNumber forKey:@"passportNumber"];
                                                            [defaults setValue:newUser.passportIssueDate forKey:@"passportIssueDate"];
                                                            
                                                            [defaults setValue:newUser.passportIssue forKey:@"passport_issue"];
                                                            [defaults setValue:newUser.licenseNumber forKey:@"license_number"];
                                                            [defaults setValue:newUser.licenseSeries forKey:@"license_series"];
                                                            [defaults setValue:newUser.licenseIssueDate forKey:@"license_issue_date"];
                                                            [defaults setValue:newUser.licenseIssue forKey:@"license_issue"];
                                                            
                                                            [defaults setValue:newUser.address forKey:@"address"];
                                                            [defaults setValue:newUser.faktAddress forKey:@"fakt_address"];



                                                            

                                                        }
                                                           onFail:^(NSError *error, NSInteger statusCode, NSArray* dictsArray) {
                                                               [self.activityIndicatorView stopAnimating];

                                                               //[self getCapchaImg];
                                                               if (dictsArray) {
                                                                  NSString* newString = [[[dictsArray objectAtIndex:0]objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                                                                   [self ErrorTextFieldInput:[NSString stringWithFormat:@"%@",newString]];
                                                                   self.passwordFromImage.text = @"";
                                                                   [self getCapchaImg];
                                                               }
                                                               
                                                               
                                                           }];

    }
    

  
}

- (void) getCapchaImg {
    
    [[ServerManager sharedManager] registrationGetCaptchaOnSuccess:^(NSString *thisData) {
        
        self.CapchaKey = [NSString stringWithString:thisData];
        NSLog(@"self.CapchaKey %@", self.CapchaKey);

        
        [[ServerManager sharedManager] registrationGetCaptchaImgWithKey:self.CapchaKey
                                                              OnSuccess:^(id thisData) {
                                                                  self.imageWithPassword.image = thisData;
                                                                  [self.activityIndicatorView stopAnimating];

                                                              }
                                                                 onFail:^(NSError *error, NSInteger statusCode) {
                                                                     [self.activityIndicatorView stopAnimating];

                                                                 }];
        
    }
                                                            onFail:^(NSError *error, NSInteger statusCode) {
                                                                [self.activityIndicatorView stopAnimating];

                                                            }];
    
}

- (void) ErrorTextFieldInput: (NSString*) errorText {
    
    self.alert = nil;
    self.alert = [UIAlertController alertControllerWithTitle:
                  errorText message:nil preferredStyle:UIAlertControllerStyleAlert];
    //self.alert.view.transform = CGAffineTransformIdentity;
    //self.alert.view.transform = CGAffineTransformScale( self.alert.view.transform, 0.5, 0.5);
    
    
    UIAlertAction *okButtlon = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      
                                                  }];


    [self.alert addAction:okButtlon];

    
    [self presentViewController:self.alert animated:YES completion:nil];


    
}
// return NO  when have error in TextFields
- (BOOL) chackTextfield {
    [self.activityIndicatorView stopAnimating];

    [self.isTextFieldEnterText removeAllObjects];
    NSString *empty = [NSString string];
    empty = @"Заполните все поля!";

    if ([self.person.name length] <1) {
       // empty = @"name";
        [self.isTextFieldEnterText addObject:empty];
    } else if ([self.person.middleName length] <1) {
        //empty = @"middleName";
        [self.isTextFieldEnterText addObject:empty];
    } else if ([self.person.surname length] <1) {
       // empty = @"surname";
        [self.isTextFieldEnterText addObject:empty];
    } else if ([self.person.email length] <6 || ([self.person.email rangeOfString:@"@"].location == NSNotFound)) {
        empty = @"Введите корректный адрес электронной почты";
        [self.isTextFieldEnterText addObject:empty];
    } else if ([self.person.countryCode length]<1) {
        empty = @"Заполните все поля!";
        [self.isTextFieldEnterText addObject:empty];
    } else if ([self.person.phoneNumber length]<1) {
        empty = @"Заполните все поля!";
        [self.isTextFieldEnterText addObject:empty];
    } else if (self.person.dateOfBirth == NULL) {
        empty = @"Заполните все поля!";
        [self.isTextFieldEnterText addObject:empty];
    } else if ([self.person.passportSeries length] < 1) {
        empty = @"Заполните все поля!";
        [self.isTextFieldEnterText addObject:empty];
    } else if ([self.person.passportNumber length] <1) {
        empty = @"Заполните все поля!";
        [self.isTextFieldEnterText addObject:empty];
    } else if (self.person.dateOfPassport == NULL) {
        empty = @"Заполните все поля!";
        [self.isTextFieldEnterText addObject:empty];
    } else if ([self.person.driverLicense length] <1) {
        empty = @"Заполните все поля!";
        [self.isTextFieldEnterText addObject:empty];
    } else if ([self.person.driverLicenseNumber length] <1) {
        empty = @"Заполните все поля!";
        [self.isTextFieldEnterText addObject:empty];
    } else if (self.person.drivelLicenseDate == NULL) {
        empty = @"Заполните все поля!";
        [self.isTextFieldEnterText addObject:empty];
    } else if ([self.person.Password length] <8) {
        empty = @"Password";
        [self.isTextFieldEnterText addObject:empty];
    }
    NSLog(@"errors count in array is %d", (int)[self.isTextFieldEnterText count]);
    if ([self.isTextFieldEnterText count] >0) {
        [self ErrorTextFieldInput:empty];
        return NO;
    } else {
        return YES;
    }
    
}

-(void) myCustomBack {
    // Some anything you need to do before leaving
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) styleRCButton: (UIButton*) button {
    
    button.layer.cornerRadius = 3.f;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.masksToBounds = YES;
}





- (NSDictionary*) dataForPickerCountry {
    NSDictionary *codes = @{
                            @"Canada"                                       : @"+1",
                            @"China"                                        : @"+86",
                            @"France"                                       : @"+33",
                            @"Germany"                                      : @"+49",
                            @"India"                                        : @"+91",
                            @"Japan"                                        : @"+81",
                            @"Pakistan"                                     : @"+92",
                            @"United Kingdom"                               : @"+44",
                            @"United States"                                : @"+1",
                            @"Abkhazia"                                     : @"+7 840",
                            @"Abkhazia"                                     : @"+7 940",
                            @"Afghanistan"                                  : @"+93",
                            @"Albania"                                      : @"+355",
                            @"Algeria"                                      : @"+213",
                            @"American Samoa"                               : @"+1 684",
                            @"Andorra"                                      : @"+376",
                            @"Angola"                                       : @"+244",
                            @"Anguilla"                                     : @"+1 264",
                            @"Antigua and Barbuda"                          : @"+1 268",
                            @"Argentina"                                    : @"+54",
                            @"Armenia"                                      : @"+374",
                            @"Aruba"                                        : @"+297",
                            @"Ascension"                                    : @"+247",
                            @"Australia"                                    : @"+61",
                            @"Australian External Territories"              : @"+672",
                            @"Austria"                                      : @"+43",
                            @"Azerbaijan"                                   : @"+994",
                            @"Bahamas"                                      : @"+1 242",
                            @"Bahrain"                                      : @"+973",
                            @"Bangladesh"                                   : @"+880",
                            @"Barbados"                                     : @"+1 246",
                            @"Barbuda"                                      : @"+1 268",
                            @"Belarus"                                      : @"+375",
                            @"Belgium"                                      : @"+32",
                            @"Belize"                                       : @"+501",
                            @"Benin"                                        : @"+229",
                            @"Bermuda"                                      : @"+1 441",
                            @"Bhutan"                                       : @"+975",
                            @"Bolivia"                                      : @"+591",
                            @"Bosnia and Herzegovina"                       : @"+387",
                            @"Botswana"                                     : @"+267",
                            @"Brazil"                                       : @"+55",
                            @"British Indian Ocean Territory"               : @"+246",
                            @"British Virgin Islands"                       : @"+1 284",
                            @"Brunei"                                       : @"+673",
                            @"Bulgaria"                                     : @"+359",
                            @"Burkina Faso"                                 : @"+226",
                            @"Burundi"                                      : @"+257",
                            @"Cambodia"                                     : @"+855",
                            @"Cameroon"                                     : @"+237",
                            @"Canada"                                       : @"+1",
                            @"Cape Verde"                                   : @"+238",
                            @"Cayman Islands"                               : @"+ 345",
                            @"Central African Republic"                     : @"+236",
                            @"Chad"                                         : @"+235",
                            @"Chile"                                        : @"+56",
                            @"China"                                        : @"+86",
                            @"Christmas Island"                             : @"+61",
                            @"Cocos-Keeling Islands"                        : @"+61",
                            @"Colombia"                                     : @"+57",
                            @"Comoros"                                      : @"+269",
                            @"Congo"                                        : @"+242",
                            @"Congo, Dem. Rep. of (Zaire)"                  : @"+243",
                            @"Cook Islands"                                 : @"+682",
                            @"Costa Rica"                                   : @"+506",
                            @"Ivory Coast"                                  : @"+225",
                            @"Croatia"                                      : @"+385",
                            @"Cuba"                                         : @"+53",
                            @"Curacao"                                      : @"+599",
                            @"Cyprus"                                       : @"+537",
                            @"Czech Republic"                               : @"+420",
                            @"Denmark"                                      : @"+45",
                            @"Diego Garcia"                                 : @"+246",
                            @"Djibouti"                                     : @"+253",
                            @"Dominica"                                     : @"+1 767",
                            @"Dominican Republic"                           : @"+1 809",
                            @"Dominican Republic"                           : @"+1 829",
                            @"Dominican Republic"                           : @"+1 849",
                            @"East Timor"                                   : @"+670",
                            @"Easter Island"                                : @"+56",
                            @"Ecuador"                                      : @"+593",
                            @"Egypt"                                        : @"+20",
                            @"El Salvador"                                  : @"+503",
                            @"Equatorial Guinea"                            : @"+240",
                            @"Eritrea"                                      : @"+291",
                            @"Estonia"                                      : @"+372",
                            @"Ethiopia"                                     : @"+251",
                            @"Falkland Islands"                             : @"+500",
                            @"Faroe Islands"                                : @"+298",
                            @"Fiji"                                         : @"+679",
                            @"Finland"                                      : @"+358",
                            @"France"                                       : @"+33",
                            @"French Antilles"                              : @"+596",
                            @"French Guiana"                                : @"+594",
                            @"French Polynesia"                             : @"+689",
                            @"Gabon"                                        : @"+241",
                            @"Gambia"                                       : @"+220",
                            @"Georgia"                                      : @"+995",
                            @"Germany"                                      : @"+49",
                            @"Ghana"                                        : @"+233",
                            @"Gibraltar"                                    : @"+350",
                            @"Greece"                                       : @"+30",
                            @"Greenland"                                    : @"+299",
                            @"Grenada"                                      : @"+1 473",
                            @"Guadeloupe"                                   : @"+590",
                            @"Guam"                                         : @"+1 671",
                            @"Guatemala"                                    : @"+502",
                            @"Guinea"                                       : @"+224",
                            @"Guinea-Bissau"                                : @"+245",
                            @"Guyana"                                       : @"+595",
                            @"Haiti"                                        : @"+509",
                            @"Honduras"                                     : @"+504",
                            @"Hong Kong SAR China"                          : @"+852",
                            @"Hungary"                                      : @"+36",
                            @"Iceland"                                      : @"+354",
                            @"India"                                        : @"+91",
                            @"Indonesia"                                    : @"+62",
                            @"Iran"                                         : @"+98",
                            @"Iraq"                                         : @"+964",
                            @"Ireland"                                      : @"+353",
                            @"Israel"                                       : @"+972",
                            @"Italy"                                        : @"+39",
                            @"Jamaica"                                      : @"+1 876",
                            @"Japan"                                        : @"+81",
                            @"Jordan"                                       : @"+962",
                            @"Kazakhstan"                                   : @"+7 7",
                            @"Kenya"                                        : @"+254",
                            @"Kiribati"                                     : @"+686",
                            @"North Korea"                                  : @"+850",
                            @"South Korea"                                  : @"+82",
                            @"Kuwait"                                       : @"+965",
                            @"Kyrgyzstan"                                   : @"+996",
                            @"Laos"                                         : @"+856",
                            @"Latvia"                                       : @"+371",
                            @"Lebanon"                                      : @"+961",
                            @"Lesotho"                                      : @"+266",
                            @"Liberia"                                      : @"+231",
                            @"Libya"                                        : @"+218",
                            @"Liechtenstein"                                : @"+423",
                            @"Lithuania"                                    : @"+370",
                            @"Luxembourg"                                   : @"+352",
                            @"Macau SAR China"                              : @"+853",
                            @"Macedonia"                                    : @"+389",
                            @"Madagascar"                                   : @"+261",
                            @"Malawi"                                       : @"+265",
                            @"Malaysia"                                     : @"+60",
                            @"Maldives"                                     : @"+960",
                            @"Mali"                                         : @"+223",
                            @"Malta"                                        : @"+356",
                            @"Marshall Islands"                             : @"+692",
                            @"Martinique"                                   : @"+596",
                            @"Mauritania"                                   : @"+222",
                            @"Mauritius"                                    : @"+230",
                            @"Mayotte"                                      : @"+262",
                            @"Mexico"                                       : @"+52",
                            @"Micronesia"                                   : @"+691",
                            @"Midway Island"                                : @"+1 808",
                            @"Micronesia"                                   : @"+691",
                            @"Moldova"                                      : @"+373",
                            @"Monaco"                                       : @"+377",
                            @"Mongolia"                                     : @"+976",
                            @"Montenegro"                                   : @"+382",
                            @"Montserrat"                                   : @"+1664",
                            @"Morocco"                                      : @"+212",
                            @"Myanmar"                                      : @"+95",
                            @"Namibia"                                      : @"+264",
                            @"Nauru"                                        : @"+674",
                            @"Nepal"                                        : @"+977",
                            @"Netherlands"                                  : @"+31",
                            @"Netherlands Antilles"                         : @"+599",
                            @"Nevis"                                        : @"+1 869",
                            @"New Caledonia"                                : @"+687",
                            @"New Zealand"                                  : @"+64",
                            @"Nicaragua"                                    : @"+505",
                            @"Niger"                                        : @"+227",
                            @"Nigeria"                                      : @"+234",
                            @"Niue"                                         : @"+683",
                            @"Norfolk Island"                               : @"+672",
                            @"Northern Mariana Islands"                     : @"+1 670",
                            @"Norway"                                       : @"+47",
                            @"Oman"                                         : @"+968",
                            @"Pakistan"                                     : @"+92",
                            @"Palau"                                        : @"+680",
                            @"Palestinian Territory"                        : @"+970",
                            @"Panama"                                       : @"+507",
                            @"Papua New Guinea"                             : @"+675",
                            @"Paraguay"                                     : @"+595",
                            @"Peru"                                         : @"+51",
                            @"Philippines"                                  : @"+63",
                            @"Poland"                                       : @"+48",
                            @"Portugal"                                     : @"+351",
                            @"Puerto Rico"                                  : @"+1 787",
                            @"Puerto Rico"                                  : @"+1 939",
                            @"Qatar"                                        : @"+974",
                            @"Reunion"                                      : @"+262",
                            @"Romania"                                      : @"+40",
                            @"Russia"                                       : @"+7",
                            @"Rwanda"                                       : @"+250",
                            @"Samoa"                                        : @"+685",
                            @"San Marino"                                   : @"+378",
                            @"Saudi Arabia"                                 : @"+966",
                            @"Senegal"                                      : @"+221",
                            @"Serbia"                                       : @"+381",
                            @"Seychelles"                                   : @"+248",
                            @"Sierra Leone"                                 : @"+232",
                            @"Singapore"                                    : @"+65",
                            @"Slovakia"                                     : @"+421",
                            @"Slovenia"                                     : @"+386",
                            @"Solomon Islands"                              : @"+677",
                            @"South Africa"                                 : @"+27",
                            @"South Georgia and the South Sandwich Islands" : @"+500",
                            @"Spain"                                        : @"+34",
                            @"Sri Lanka"                                    : @"+94",
                            @"Sudan"                                        : @"+249",
                            @"Suriname"                                     : @"+597",
                            @"Swaziland"                                    : @"+268",
                            @"Sweden"                                       : @"+46",
                            @"Switzerland"                                  : @"+41",
                            @"Syria"                                        : @"+963",
                            @"Taiwan"                                       : @"+886",
                            @"Tajikistan"                                   : @"+992",
                            @"Tanzania"                                     : @"+255",
                            @"Thailand"                                     : @"+66",
                            @"Timor Leste"                                  : @"+670",
                            @"Togo"                                         : @"+228",
                            @"Tokelau"                                      : @"+690",
                            @"Tonga"                                        : @"+676",
                            @"Trinidad and Tobago"                          : @"+1 868",
                            @"Tunisia"                                      : @"+216",
                            @"Turkey"                                       : @"+90",
                            @"Turkmenistan"                                 : @"+993",
                            @"Turks and Caicos Islands"                     : @"+1 649",
                            @"Tuvalu"                                       : @"+688",
                            @"Uganda"                                       : @"+256",
                            @"Ukraine"                                      : @"+380",
                            @"United Arab Emirates"                         : @"+971",
                            @"United Kingdom"                               : @"+44",
                            @"United States"                                : @"+1",
                            @"Uruguay"                                      : @"+598",
                            @"U.S. Virgin Islands"                          : @"+1 340",
                            @"Uzbekistan"                                   : @"+998",
                            @"Vanuatu"                                      : @"+678",
                            @"Venezuela"                                    : @"+58",
                            @"Vietnam"                                      : @"+84",
                            @"Wake Island"                                  : @"+1 808",
                            @"Wallis and Futuna"                            : @"+681",
                            @"Yemen"                                        : @"+967",
                            @"Zambia"                                       : @"+260",
                            @"Zanzibar"                                     : @"+255",
                            @"Zimbabwe"                                     : @"+263"
                            };
    
    return codes;
    
}






@end
