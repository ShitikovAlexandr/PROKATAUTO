//
//  RememberPasswordController.m
//  ProkatAuto31
//
//  Created by alex on 26.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "RememberPasswordController.h"
#import "ServerManager.h"
#import "SWRevealViewController.h"

@interface RememberPasswordController ()

@property (strong, nonatomic) UIPickerView *countriCodePicker;
@property (strong, nonatomic) NSDictionary *pickerDateArray;
@property (weak, nonatomic) IBOutlet UILabel *CountryNameLabel;

@property (strong, nonatomic) NSString *CapchaKey;
@property (strong, nonatomic) NSString *captchaText;
@property (strong, nonatomic) NSString *phoneText;

@property (strong, nonatomic) UIAlertController *alert;




@end

@implementation RememberPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getCapchaImg];
    
    // Do any additional setup after loading the view.
    [self styleRCButton:self.getNewPasswordButton];
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
    [self.countryCode setInputAccessoryView:toolBar];
    self.countryCode.inputView = self.countriCodePicker;
    
    self.pickerDateArray = [self dataForPickerCountry];
    self.countriCodePicker.delegate = self;
    [self.countriCodePicker selectRow:(int)[self.pickerDateArray objectForKey:@"Russia"] inComponent:0 animated:YES];
    self.CountryNameLabel.text = @"Russia";
    self.countryCode.placeholder =  [NSString stringWithFormat:@"%@", [self.pickerDateArray objectForKey:@"Russia"]];
    self.countryCode.text = @"+7";
    
    [self.getNewPasswordButton addTarget:self action:@selector(PressButtonPassword) forControlEvents:UIControlEventTouchDown];

    
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(RCTextField *)textField {
    
    if (textField.tag >0) {
        [textField starEditeffect:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(RCTextField *)textField {
    if (textField.tag >0) {
        [textField EndEditeffect:textField];
        
        if (textField.tag == 1) {
            self.phoneText = textField.text;
        } else if (textField.tag == 2) {
            self.captchaText = textField.text;
        }
    }
    
    return YES;
    
}


- (void) styleRCButton: (UIButton*) button {
    
    button.layer.cornerRadius = 3.f;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor clearColor].CGColor;
    button.layer.masksToBounds = YES;
}

-(void) myCustomBack {
        [self.navigationController popViewControllerAnimated:YES];
 }


#pragma mark - CountryCodePicker

- (void) doneButtonPressed:(id)sender  {
       [self.countryCode resignFirstResponder];
    self.countryCode.layer.shadowColor = [UIColor grayColor].CGColor;
}

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
    
    self.countryCode.text = str;
    self.CountryNameLabel.text = str2;
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

- (void) getCapchaImg {
    
    [[ServerManager sharedManager] registrationGetCaptchaOnSuccess:^(NSString *thisData) {
        
        self.CapchaKey = [NSString stringWithString:thisData];
        
        [[ServerManager sharedManager] registrationGetCaptchaImgWithKey:self.CapchaKey
                                                              OnSuccess:^(id thisData) {
                                                                  self.captchaImg.image = thisData;
                                                                  
                                                              }
                                                                 onFail:^(NSError *error, NSInteger statusCode) {
                                                                     
                                                                 }];
        
    }
                                                            onFail:^(NSError *error, NSInteger statusCode) {
                                                                
                                                            }];
    
}

- (void) PressButtonPassword {
    [self.phoneNumber resignFirstResponder];
    [self.captchaValue resignFirstResponder];
    
    [self getNewPasswordWithKey:self.CapchaKey andCapchaValue:self.captchaText andPhone:[NSString stringWithFormat:@"%@%@", self.countryCode.text, self.phoneText]];
}

- (void) getNewPasswordWithKey: (NSString*) key andCapchaValue: (NSString*) value andPhone: (NSString*) phone  {
    [[ServerManager sharedManager]  rememberPasswordWithCapchaKey:key
                                                   andCapchaValue:value
                                                         andPhone:phone
                                                        OnSuccess:^(NSString *data) {
                                                            
                                                            [self exitAlertMessage:NSLocalizedString(@"New password has been sent to the SMS", nil)];
                                                        }
                                                           onFail:^(NSError *error, NSInteger statusCode, NSArray* dataArray) {
                                                               if (error.code == -1009) {
                                                                   [self errorActionWithMasegr];
                                                               }
                                                               
                                                               else if (dataArray) {
                                                                   NSString* newString = [[[dataArray objectAtIndex:0]objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                                                                   [self ErrorTextFieldInput:[NSString stringWithFormat:@"%@",newString]];
                                                               }
                                                               
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

- (void) exitAlertMessage: (NSString*) text  {
    
    self.alert = nil;
    self.alert = [UIAlertController alertControllerWithTitle:
                  text message:nil preferredStyle:UIAlertControllerStyleAlert];
    //self.alert.view.transform = CGAffineTransformIdentity;
    //self.alert.view.transform = CGAffineTransformScale( self.alert.view.transform, 0.5, 0.5);
    
    
    UIAlertAction *okButtlon = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                          SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                                                          [self presentViewController:vc animated:YES completion:nil];
                                                      }];
    
    
    [self.alert addAction:okButtlon];
    
    
    [self presentViewController:self.alert animated:YES completion:nil];

    
    
}

- (void) errorActionWithMasegr {
    NSString* masege = NSLocalizedString(@"Check your internet connection!", nil);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                @"" message:masege preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
