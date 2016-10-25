//
//  OrderCarWithDriverController.m
//  ProkatAuto31
//
//  Created by Ivan Bielko on 22.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "OrderCarWithDriverController.h"
#import "UIImageView+AFNetworking.h"
#import "ServerManager.h"

@interface OrderCarWithDriverController ()
@property (strong, nonatomic) UIPickerView *countryCodePicker;
@property (strong, nonatomic) NSDictionary *countryCodeArray;
@property (strong, nonatomic) NSString *capchaKey;
@property (strong, nonatomic) NSString *sentMessage;
@end

@implementation OrderCarWithDriverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sentMessage = @"Спасибо за Ваш заказ! Наши сотрудники свяжутся с Вами в ближайшее время.";
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    NSURL *url = [NSURL URLWithString:self.car.imageURL];
    [self.carImageView setImageWithURL:url];
    [self getCapchaImg];
    
    self.titleLabel.text = self.car.name;
    self.descriptionLabel.attributedText = [[NSAttributedString alloc] initWithData:[self.car.carDescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    [self.descriptionLabel sizeToFit];
    
    [self.sendOrderButton addTarget:self action:@selector(SendOrder:event:) forControlEvents:UIControlEventTouchUpInside];
    
    self.countryCodeArray = [self dataForPickerCountry];
    self.countryCodePicker = [[UIPickerView alloc] init];
    self.countryCodePicker.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.countryCodePicker.layer.shadowColor = [UIColor grayColor].CGColor;
    self.countryCodePicker.layer.shadowOffset = CGSizeMake(0.f, -3.0f);
    self.countryCodePicker.layer.shadowRadius = 3;
    self.countryCodePicker.layer.shadowOpacity = 3;
    self.countryCodePicker.layer.masksToBounds = NO;
    self.countryCodePicker.delegate = self;
    self.countryCodePicker.dataSource = self;
    
    self.codeField.inputView = self.countryCodePicker;
}

-(void) myCustomBack {
    // Some anything you need to do before leaving
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SendOrder:(id) sender event: (id) event {
    
    if(![self validateFieldsEmpty])
        [self showAlert:@"Заполните все поля!"];
    else if(![self validatePhoneNumber])
        [self showAlert:@"Введите корректный номер телефона"];
    else if(![self validateEmail])
        [self showAlert:@"Введите корректный адрес электронной почты"];
    else
    {
        [[ServerManager sharedManager] orderCarWithDriver:self.car.carId userName:self.nameField.text userPhoneNumber:[NSString stringWithFormat:@"%@%@", self.codeField.text, self.phoneField.text] userEmail:self.emailField.text orderDescription:self.descriptionField.text andKey:self.capchaKey passwordFromImg:self.captchaField.text OnSuccess:^ {
            [self showAlert:self.sentMessage];
        } onFail:^(NSError *error, NSString *errorMessage) {
            [self showAlert:errorMessage];
            [self getCapchaImg];
            self.captchaField.text = @"";
        }];
    }

}

- (BOOL)textFieldShouldBeginEditing:(RCTextField *)textField {
    [textField starEditeffect:textField];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(RCTextField *)textField {
    [textField EndEditeffect:textField];
    return YES;
}

- (BOOL)textFieldShouldReturn:(RCTextField *)textField {
    UIView *view = [self.view viewWithTag:textField.tag + 1];
    if (!view)
        [textField endEditing:TRUE];
    else
        [view becomeFirstResponder];
    return YES;
}

- (void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([theAlert.message isEqualToString:self.sentMessage])
        [self.navigationController popToRootViewControllerAnimated:TRUE];
}
- (void)showAlert:(NSString *) message
{
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:nil
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [theAlert show];
}

-(BOOL) validateFieldsEmpty
{
    NSMutableArray *fieldsArray = [[NSMutableArray alloc] init ];
    [fieldsArray addObject:[self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [fieldsArray addObject:[self.phoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [fieldsArray addObject:[self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [fieldsArray addObject:[self.descriptionField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [fieldsArray addObject:[self.captchaField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    return [fieldsArray indexOfObject:@""] == NSNotFound;
}

-(BOOL) validateEmail
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.emailField.text];
}

-(BOOL) validatePhoneNumber
{
    return [self.phoneField.text rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound;
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.countryCodeArray count];
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *str = [NSString stringWithFormat:@"%@ %@",[self.countryCodeArray allKeys][row], [self.countryCodeArray objectForKey:[self.countryCodeArray allKeys][row]]];
    
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *str = [NSString stringWithFormat:@"%@", [self.countryCodeArray objectForKey:[self.countryCodeArray allKeys][row]]];
    NSString *str2 = [NSString stringWithFormat:@"%@", [self.countryCodeArray allKeys][row]];
    
    self.codeField.text = str;
    self.countryLabel.text = str2;
}

- (void) getCapchaImg {
    
    [[ServerManager sharedManager] registrationGetCaptchaOnSuccess:^(NSString *thisData) {
        
        self.capchaKey = [NSString stringWithString:thisData];
        
        [[ServerManager sharedManager] registrationGetCaptchaImgWithKey:self.capchaKey
                                                              OnSuccess:^(id thisData) {
                                                                  self.captchaImageView.image = thisData;
                                                                  
                                                              }
                                                                 onFail:^(NSError *error, NSInteger statusCode) {
                                                                     
                                                                 }];
        
    }
                                                            onFail:^(NSError *error, NSInteger statusCode) {
                                                                
                                                            }];
    
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
