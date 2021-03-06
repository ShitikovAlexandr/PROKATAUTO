//
//  UITableViewController+TransferOrderController.m
//  ProkatAuto31
//
//  Created by Ivan Bielko on 04.11.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "TransferOrderController.h"
#import "ServerManager.h"
#import "RCDatePicker.h"

@interface TransferOrderController ()
@property (strong, nonatomic) UIPickerView *countryCodePicker;
@property (strong, nonatomic) NSDictionary *countryCodeArray;
@property (strong, nonatomic) NSString *capchaKey;
@property (strong, nonatomic) NSString *sentMessage;
@property (strong, nonatomic) NSString *tokenString;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property (nonatomic) NSInteger currentTag;
@end

@implementation TransferOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sentMessage = NSLocalizedString(@"Thank you for your order! Our staff will contact you shortly.", nil_);
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.tokenString = [defaults valueForKey:@"tokenString"];
    if([self.tokenString isEqualToString:@""] || self.tokenString == nil)
    {
        [self getCapchaImg];
    }else
    {
        [self hideElements];
    }
    
    self.titleLabel.text = self.category.name;
    NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithData:[self.category.maimDescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    CGRect descriptionRect = [description boundingRectWithSize:CGSizeMake(self.descriptionLabel.frame.size.width, 0)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
    self.descriptionLabel.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.origin.y, descriptionRect.size.width, descriptionRect.size.height + 40);
    [self moveViews:self.descriptionLabel.frame.size.height-60];
    [self.tableView reloadData];
    
    self.descriptionLabel.attributedText = description;
    
    [self styleRCButton:self.sendOrderButton];
    [self.sendOrderButton addTarget:self action:@selector(sendOrder:event:) forControlEvents:UIControlEventTouchUpInside];
    
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
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.codeField setInputAccessoryView:toolBar];
    [self.phoneField setInputAccessoryView:toolBar];
    [self.passagersField setInputAccessoryView:toolBar];
    
    self.codeField.inputView = self.countryCodePicker;
    
    self.dateView.layer.borderColor = [UIColor grayColor].CGColor;
    self.dateView.layer.borderWidth = 1;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    self.timeFormatter = [[NSDateFormatter alloc] init];
    [self.timeFormatter setDateFormat:@"HH:mm"];
    
    self.startDate = [[NSDate date] dateByAddingTimeInterval:60*60*24];
    NSCalendar *calendarReturn = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *componentsReturn = [calendarReturn components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.startDate];
    [componentsReturn setHour:12];
    self.startDate = [calendarReturn dateFromComponents:componentsReturn];
    
    self.dateField.text = [self.dateFormatter stringFromDate:self.startDate];
    self.timeField.text = [self.timeFormatter stringFromDate:self.startDate];
}

-(void)moveViews:(float) delta
{
    for(UIView* subview in self.contentView.subviews)
    {
        if(subview.frame.origin.y>self.descriptionLabel.frame.origin.y && !subview.hidden)
        {
            subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + delta, subview.frame.size.width, subview.frame.size.height);
        }
    }
}

- (void) styleRCButton: (UIButton*) button {
    
    button.layer.cornerRadius = 3.f;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor clearColor].CGColor;
    button.layer.masksToBounds = YES;
}

-(void) myCustomBack {
    // Some anything you need to do before leaving
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) doneButtonPressed:(id)sender  {
}

-(void) hideElements
{
    self.contactDataLabel.hidden = TRUE;
    self.nameField.hidden = TRUE;
    self.countryField.hidden = TRUE;
    self.codeField.hidden = TRUE;
    self.phoneField.hidden = TRUE;
    self.emailField.hidden = TRUE;
    self.captchaImageView.hidden = TRUE;
    self.captchaLabel.hidden = TRUE;
    self.captchaField.hidden = TRUE;
    //self.captchaField.tag = 0;
    //self.commentField.returnKeyType = UIReturnKeyDone;
    //self.commentField.enablesReturnKeyAutomatically = FALSE;
    
    float delta = self.contactDataLabel.frame.origin.y - self.carField.frame.origin.y;
    [self moveViews:delta];
    self.sendOrderButton.frame = CGRectMake(self.sendOrderButton.frame.origin.x, self.commentField.frame.origin.y + self.commentField.frame.size.height + 10, self.sendOrderButton.frame.size.width, self.sendOrderButton.frame.size.height);
}

- (IBAction)sendOrder:(id) sender event: (id) event {
    
    if([self.tokenString length] <6)
    {
        [self sendOrderWithCaptcha];
    }else
    {
        [self sendOrderWithToken];
    }
    
}

-(void) sendOrderWithCaptcha
{
    if(![self validateFieldsEmpty])
        [self showAlert:NSLocalizedString(@"Fill in all fields!!!", nil)];
    else if(![self validatePhoneNumber])
        [self showAlert:NSLocalizedString(@"Please, input correct phone number", nil)];
    else
    {
        [[ServerManager sharedManager] sendTransferOrderWithCaptchaKey:self.capchaKey andCaptchaValue:self.captchaField.text andUserName:self.nameField.text userPhoneNumber:[NSString stringWithFormat:@"%@%@", self.codeField.text, self.phoneField.text] userEmail:self.emailField.text orderComment:self.commentField.text pickupLocation:self.placeField.text pickUpDateTime:[self makeDateTime] passengersCount:self.passagersField.text destinationPlace:self.destinationField.text carName:self.carField.text OnSuccess:^ {
            [self showAlert:self.sentMessage];
        } onFail:^(NSError *error, NSString *errorMessage) {
            if (error.code == -1009 || error.code == 3840) {
                errorMessage = NSLocalizedString(@"Check your internet connection!", nil);
            }
            [self showAlert:errorMessage];
            [self getCapchaImg];
            self.captchaField.text = @"";
        }];
    }
}

-(void) sendOrderWithToken
{
    if(![self validateFieldsEmptyShort])
        [self showAlert:NSLocalizedString(@"Fill in all fields!!!", nil)];
    else
    {
        [[ServerManager sharedManager] sendTransferOrderWithToken:self.tokenString orderComment:self.commentField.text pickupLocation:self.placeField.text pickUpDateTime:[self makeDateTime] passengersCount:self.passagersField.text destinationPlace:self.destinationField.text carName:self.carField.text OnSuccess:^ {
            [self showAlert:self.sentMessage];
        } onFail:^(NSError *error, NSString *errorMessage) {
            if (error.code == -1009 || error.code == 3840) {
                errorMessage = NSLocalizedString(@"Check your internet connection!", nil);
            }
            [self showAlert:errorMessage];
        }];
    }
}

-(NSString*) makeDateTime
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    return [NSString stringWithFormat:@"%@T%@:00Z", [df stringFromDate:self.startDate], self.timeField.text];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.sendOrderButton.frame.origin.y + 40;
}



- (BOOL)textFieldShouldBeginEditing:(RCTextField *)textField {
    [textField starEditeffect:textField];
    
   
    
    self.currentTag = textField.tag;
    if(self.currentTag == 5 || self.currentTag == 6)
    {
        RCDatePicker *datePicker = [[RCDatePicker alloc] initWithShadowAndTextField:textField];
        [datePicker addTarget:self action:@selector (textFieldDidChange:) forControlEvents:UIControlEventValueChanged];
        datePicker.locale =  [NSLocale currentLocale];
        [datePicker setDate:self.startDate animated:YES];
        
        if (textField.tag == 5) { // stard date of rental
            datePicker.minimumDate =  [NSDate date];
            datePicker.datePickerMode = UIDatePickerModeDate;
        } else if (textField.tag == 6) { // stard time of rental
            datePicker.datePickerMode = UIDatePickerModeTime;
        }
    }
    
    return YES;
}

-(void)textFieldDidChange:(UIDatePicker*) datePicker {
    if (self.currentTag == 5) {
        self.startDate = datePicker.date;
        self.dateField.text =[self.dateFormatter stringFromDate:self.startDate];
    }else if (self.currentTag == 6) {
        self.timeField.text =[self.timeFormatter stringFromDate:datePicker.date];
    }
}

- (BOOL)textFieldShouldEndEditing:(RCTextField *)textField {
    [textField EndEditeffect:textField];
    if (textField.tag == 5 || textField.tag == 6) {
        
    }
    return YES;
}
/*
- (BOOL)textFieldShouldReturn:(RCTextField *)textField {
    UIView *view = [self.view viewWithTag:textField.tag + 1];
    if (!view)
        [textField resignFirstResponder];
    else
        [view becomeFirstResponder];
    return YES;
}
 */

- (void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if([theAlert.message isEqualToString:self.sentMessage])
        //[self.navigationController popToRootViewControllerAnimated:TRUE];
}

- (void)showAlert:(NSString *) message
{
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                    @"" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           if([message isEqualToString:self.sentMessage])
                                                               [self.navigationController popToRootViewControllerAnimated:YES];
                                                       }];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    
}

-(BOOL) validateFieldsEmpty
{
    NSMutableArray *fieldsArray = [[NSMutableArray alloc] init ];
    [fieldsArray addObject:[self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [fieldsArray addObject:[self.phoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [fieldsArray addObject:[self.captchaField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [fieldsArray addObject:[self.carField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [fieldsArray addObject:[self.placeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    return [fieldsArray indexOfObject:@""] == NSNotFound;
}

-(BOOL) validateFieldsEmptyShort
{
    NSMutableArray *fieldsArray = [[NSMutableArray alloc] init ];
    [fieldsArray addObject:[self.carField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [fieldsArray addObject:[self.placeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    return [fieldsArray indexOfObject:@""] == NSNotFound;
}

-(BOOL) validatePhoneNumber
{
    return [self.phoneField.text rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound;
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

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
    self.countryField.text = str2;
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
