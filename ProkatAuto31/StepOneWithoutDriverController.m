//
//  StepOneWithoutDriverController.m
//  ProkatAuto31
//
//  Created by alex on 04.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "StepOneWithoutDriverController.h"
#import "StepOneCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "Order.h"
#import "RCDatePicker.h"
#import "RCPickerView.h"
#import "ServerManager.h"
#import "Place.h"
#import "StepTwoWithoutDriverController.h"
#import "WithoutDriverDetailController.h"



@interface StepOneWithoutDriverController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIAlertController *alert;
@property (strong, nonatomic) NSString *baseAddress;
@property (strong, nonatomic) Order *order;
@property (assign, nonatomic) int tagTF;
@property (strong, nonatomic) UIPickerView *picker;

@property (strong, nonatomic) NSMutableArray *PickerDateArray;
@property (strong, nonatomic) NSMutableArray *startPlace;
@property (strong, nonatomic) NSMutableArray *endPlace;

@property (assign, nonatomic) int chackCount;


@property (strong, nonatomic) StepOneCollectionViewCell *cell;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;


@end

@implementation StepOneWithoutDriverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.color = [UIColor blackColor];
    self.activityIndicatorView.center = self.view.center;
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];

    [self getPlacesFromAPI];
    
    self.PickerDateArray = [[NSMutableArray alloc] init];
    self.startPlace = [NSMutableArray array];
    self.endPlace = [NSMutableArray array];
    
    self.picker = [[UIPickerView alloc] init];
    self.picker.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.picker.layer.shadowColor = [UIColor grayColor].CGColor;
    self.picker.layer.shadowOffset = CGSizeMake(0.f, -3.0f);
    self.picker.layer.shadowRadius = 3;
    self.picker.layer.shadowOpacity = 3;
    self.picker.layer.masksToBounds = NO;
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
  
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_phone.png"] style:UIBarButtonItemStylePlain target:self action:@selector(CallAction)];
    
    
    
    
    self.order = [[Order alloc] init];
    self.baseAddress = @"http://83.220.170.187";
}

- (void) CallAction {
    NSLog(@"make call");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://+79036420187"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width - 16, 700);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
    
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *const identifier = @"StepOneCollectionViewCell";
    
    self.cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    self.cell.supplyCarView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cell.supplyCarView.layer.cornerRadius = 2.f;
    self.cell.supplyCarView.layer.borderWidth =2.f;
    
    self.cell.ReturnCarView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cell.ReturnCarView.layer.cornerRadius = 2.f;
    self.cell.ReturnCarView.layer.borderWidth =2.f;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseAddress, self.car.imageURL]];
    [self.cell.carImage setImageWithURL:url];
    self.cell.fullName.text = [NSString stringWithFormat:@"%@ %@ %@", self.car.itemFullName, self.car.itemEngine, self.car.itemTransmissionName]; //self.car.itemFullName;
    self.cell.priceRange1.text = [NSString stringWithFormat:NSLocalizedString(@"%@ rubles", nil), self.car.priceRange1];
    self.cell.priceRange2.text = [NSString stringWithFormat:NSLocalizedString(@"%@ rubles", nil), self.car.priceRange2];
    self.cell.priceRange3.text = [NSString stringWithFormat:NSLocalizedString(@"%@ rubles", nil), self.car.priceRange3];
    self.cell.deposit.text = [NSString stringWithFormat:NSLocalizedString(@"%@ rubles", nil), self.car.deposit];
  
    self.cell.timeStartTextField = [self setShadowToTextField:self.cell.timeStartTextField];
    self.cell.dateStartTextField = [self setShadowToTextField:self.cell.dateStartTextField];
    
    self.cell.DateReturnTextField = [self setShadowToTextField:self.cell.DateReturnTextField];
    self.cell.timeReturnTextField = [self setShadowToTextField:self.cell.timeReturnTextField];
    
    self.cell.startPlase = [self setShadowToTextField:self.cell.startPlase];
    self.cell.returnPlase = [self setShadowToTextField:self.cell.returnPlase];
    
    self.cell.dateStartTextField.delegate = self;
    self.cell.timeStartTextField.delegate = self;
    self.cell.DateReturnTextField.delegate = self;
    self.cell.timeReturnTextField.delegate = self;
    self.cell.startPlase.delegate =self;
    self.cell.returnPlase.delegate = self;
    
    //self.pickerStart = [[RCPickerView alloc] initWithShadowAndTextField:self.cell.startPlase];
    //self.pickerEnd = [[RCPickerView alloc] initWithShadowAndTextField:self.cell.returnPlase];
    self.picker.delegate = self;
    self.picker.dataSource =self;


    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
    
    NSDateFormatter *tf = [[NSDateFormatter alloc] init];
    [tf setDateFormat:@"HH:mm"];

    
    self.order.dateOfRentalStart = [[NSDate  date] dateByAddingTimeInterval:60*60*24];
    self.cell.dateStartTextField.text = [NSString stringWithFormat:@"%@", [df stringFromDate:self.order.dateOfRentalStart]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.order.dateOfRentalStart];
    [components setHour:12];
    NSDate *today12am = [calendar dateFromComponents:components];
    self.order.timeOfRentalStart = today12am;
    self.cell.timeStartTextField.text = [NSString stringWithFormat:@"%@", [tf stringFromDate:self.order.timeOfRentalStart]];
    
    
    self.order.dateOfRentalEnd = [self.order.dateOfRentalStart dateByAddingTimeInterval:60*60*24];
    self.cell.DateReturnTextField.text = [NSString stringWithFormat:@"%@", [df stringFromDate:self.order.dateOfRentalEnd]];
    NSCalendar *calendarReturn = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *componentsReturn = [calendarReturn components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.order.dateOfRentalEnd];
    [componentsReturn setHour:12];
    NSDate *return12am = [calendarReturn dateFromComponents:components];
    self.order.timeOfRentalEnd = return12am;
    self.cell.timeReturnTextField.text = [NSString stringWithFormat:@"%@", [tf stringFromDate:self.order.timeOfRentalEnd]];
    self.cell.deposit.text = [NSString stringWithFormat:@"%@", self.car.deposit];
    
    self.cell.startPlase.text = self.order.startPlace.name;
    self.cell.returnPlase.text = self.order.endPlace.name;
    
    [self.cell.rentalButton addTarget:self action:@selector(checkCarAndGo) forControlEvents:UIControlEventTouchUpInside];
   
    self.cell.rentalButton.layer.cornerRadius = 3.f;
    self.cell.rentalButton.layer.borderWidth = 1.0f;
    self.cell.rentalButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.cell.rentalButton.layer.masksToBounds = YES;

    
    
    
    return self.cell;
}


- (UITextField*) setShadowToTextField: (UITextField*) textField {
    
    textField.layer.shadowColor = [UIColor grayColor].CGColor;
    textField.layer.shadowOffset = CGSizeMake(0.f, 1.0f);
    textField.layer.shadowRadius = 0;
    textField.layer.shadowOpacity = 1;
    textField.layer.masksToBounds = NO;
    
    return textField;
    
}



-(void) myCustomBack {
    // Some anything you need to do before leaving
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    
    textField.layer.shadowColor = [UIColor redColor].CGColor;
    textField.textColor = [UIColor redColor];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
    
    NSDateFormatter *tf = [[NSDateFormatter alloc] init];
    [tf setDateFormat:@"HH:mm"];
    
    RCDatePicker *datePicker = [[RCDatePicker alloc] initWithShadowAndTextField:textField];
    [datePicker addTarget:self action:@selector (textFieldDidChange:) forControlEvents:UIControlEventValueChanged];
    
    
    
    
    if (textField.tag == 1) { // stard date of rental
        self.tagTF = 1;
        datePicker.minimumDate =  [NSDate date]; //[[NSDate  date] dateByAddingTimeInterval:60*60*24];
        textField.text = [NSString stringWithFormat:@"%@", [df stringFromDate:self.order.dateOfRentalStart]];
        [datePicker setDate:self.order.dateOfRentalStart animated:YES];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.locale =  [NSLocale currentLocale];

        
        if ([self.order.dateOfRentalStart timeIntervalSinceNow]< 60) {
            self.order.timeOfRentalStart = [NSDate date];
            [(UITextField *)[self.view viewWithTag:2] setText: [NSString stringWithFormat:@"%@", [tf stringFromDate:self.order.timeOfRentalStart]]];
        }
        
    } else if (textField.tag == 2) { // stard time of rental
        self.tagTF = 2;
        datePicker.locale =  [NSLocale currentLocale];
        textField.text = [NSString stringWithFormat:@"%@", [tf stringFromDate:self.order.timeOfRentalStart]];
        datePicker.datePickerMode = UIDatePickerModeTime;
        
        if ([self.order.dateOfRentalStart timeIntervalSinceNow]< 120) {
            datePicker.minimumDate = [NSDate date];
            self.order.timeOfRentalStart = datePicker.date;
            self.cell.timeStartTextField.text = [NSString stringWithFormat:@"%@", [tf stringFromDate:self.order.timeOfRentalStart]];
            
        } else {
            [datePicker setDate:self.order.timeOfRentalStart animated:YES];
        }

    } else if (textField.tag == 3) { // end date of rental
        datePicker.locale =  [NSLocale currentLocale];
        self.tagTF = 3;
        datePicker.minimumDate =  self.order.dateOfRentalStart;
        [datePicker setDate:self.order.dateOfRentalEnd animated:YES];

        textField.text = [NSString stringWithFormat:@"%@", [df stringFromDate:self.order.dateOfRentalEnd]];
        datePicker.datePickerMode = UIDatePickerModeDate;
        
        
    } else if (textField.tag == 4) { // end time of rental
        datePicker.locale =  [NSLocale currentLocale];
        self.tagTF = 4;
        textField.text = [NSString stringWithFormat:@"%@", [tf stringFromDate:self.order.timeOfRentalEnd]];
        datePicker.datePickerMode = UIDatePickerModeTime;
        [datePicker setDate:self.order.timeOfRentalEnd animated:YES];
        if ([self.order.dateOfRentalEnd timeIntervalSinceNow]< 60) {
            datePicker.minimumDate = [[NSDate date] dateByAddingTimeInterval:60*60];
        }

        //datePicker.minimumDate =  [self.order.dateOfRentalStart;
        
    } else if (textField.tag == 5) {
        self.tagTF = 5;
        textField.inputView = self.picker;
    } else if (textField.tag == 6) {
        self.tagTF = 6;
       textField.inputView = self.picker;

    }
    
    
    return YES;
}


-(void)textFieldDidChange:(UIDatePicker*) datePicker {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
    
    NSDateFormatter *tf = [[NSDateFormatter alloc] init];
    [tf setDateFormat:@"HH:mm"];

    
    if (self.tagTF == 1) {
        self.order.dateOfRentalStart = datePicker.date;
        self.cell.dateStartTextField.text = [NSString stringWithFormat:@"%@", [df stringFromDate:self.order.dateOfRentalStart]];
        
        if ([self.order.dateOfRentalStart timeIntervalSinceNow]< 60) {
            self.order.timeOfRentalStart = [NSDate date];
            [(UITextField *)[self.view viewWithTag:2] setText: [NSString stringWithFormat:@"%@", [tf stringFromDate:self.order.timeOfRentalStart]]];
        } else if ([self.order.dateOfRentalStart timeIntervalSinceDate:self.order.dateOfRentalEnd]> 60) {
            self.order.dateOfRentalEnd = self.order.dateOfRentalStart;
            [(UITextField *)[self.view viewWithTag:3] setText: [NSString stringWithFormat:@"%@", [df stringFromDate:self.order.dateOfRentalEnd]]];
        }
        
    } else if (self.tagTF == 2) {
        self.order.timeOfRentalStart = datePicker.date;
        self.cell.timeStartTextField.text = [NSString stringWithFormat:@"%@", [tf stringFromDate:self.order.timeOfRentalStart]];
        if ([self.order.dateOfRentalStart timeIntervalSinceDate:self.order.dateOfRentalEnd]< 60) { //
            self.order.timeOfRentalEnd = [self.order.timeOfRentalStart dateByAddingTimeInterval:60*60];
            [(UITextField *)[self.view viewWithTag:4] setText: [NSString stringWithFormat:@"%@", [tf stringFromDate:self.order.timeOfRentalEnd]]];
        }
        
    } else if (self.tagTF == 3) {
        
        self.order.dateOfRentalEnd = datePicker.date;
        self.cell.DateReturnTextField.text = [NSString stringWithFormat:@"%@", [df stringFromDate:self.order.dateOfRentalEnd]];
        
        if ([self.order.dateOfRentalStart timeIntervalSinceDate:self.order.dateOfRentalEnd]< 60) {
            self.order.timeOfRentalEnd = [self.order.timeOfRentalStart dateByAddingTimeInterval:60*60];
            [(UITextField *)[self.view viewWithTag:4] setText: [NSString stringWithFormat:@"%@", [tf stringFromDate:self.order.timeOfRentalEnd]]];
        }

        
    } else if (self.tagTF == 4) {
        
        self.order.timeOfRentalEnd = datePicker.date;
        self.cell.timeReturnTextField.text = [NSString stringWithFormat:@"%@", [tf stringFromDate:self.order.timeOfRentalEnd]];
        
    }
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([self.cell.startPlase isFirstResponder]) {
        return [self.startPlace count];
    } else {
        return [self.endPlace count];
    }
    
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([self.cell.startPlase isFirstResponder]) {
        Place *place = [self.startPlace objectAtIndex:row];
         return place.name;
    } else {
        Place *place = [self.endPlace objectAtIndex:row];
         return place.name;
    }
   
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if ([self.cell.startPlase isFirstResponder]) {
        Place *place = [self.startPlace objectAtIndex:row];
        self.cell.startPlase.text = place.name;
        self.order.startPlace = place;
    } else {
        Place *place = [self.endPlace objectAtIndex:row];
        self.cell.returnPlase.text =place.name;
        self.order.endPlace = place;

    }
}

- (void) doneButtonPressed:(id)sender  {
    
    //self.textField.layer.shadowColor =[UIColor grayColor].CGColor;
    [self.cell.startPlase resignFirstResponder];
    [self.cell.returnPlase resignFirstResponder];
    self.cell.startPlase.layer.shadowColor = [UIColor grayColor].CGColor;
    self.cell.returnPlase.layer.shadowColor = [UIColor grayColor].CGColor;
    self.cell.startPlase.textColor = [UIColor blackColor];
    self.cell.returnPlase.textColor = [UIColor blackColor];

}

#pragma mark - API

- (void) getPlacesFromAPI {
    
    [[ServerManager sharedManager] getPlacesOnSuccess:^(NSArray *thisData) {
        [self.PickerDateArray addObjectsFromArray:thisData];
        [self.activityIndicatorView stopAnimating];

        for(Place* pl in self.PickerDateArray) {
            if ([pl.serviceType isEqualToString:@"1"]) {
                [self.startPlace addObject:pl];
            } else if ([pl.serviceType isEqualToString:@"5"]){
                [self.endPlace addObject:pl];
            }
        }
        
        self.order.startPlace = [self.startPlace objectAtIndex:0];
        self.order.endPlace = [self.endPlace objectAtIndex:0];
        [self.collectionView reloadData];
        
    } onFail:^(NSError *error, NSInteger statusCode) {
        [self.activityIndicatorView stopAnimating];

        
    }];
}

- (void) chckCarForFreeAPI {
    [self.activityIndicatorView startAnimating];

    //for(NSNumber* numId in self.car.carID) {
    [[ServerManager sharedManager] checkCarWithCarId:[self.car.carID objectAtIndex:0]
                                        withDateFrom:self.order.startDateOfRentalString
                                          withDateTo:self.order.endDateOfRentalString
                                           OnSuccess:^(NSArray *thisData ) {
                                               [self.activityIndicatorView stopAnimating];

                                               if (thisData == NULL) {
                                                  // NSLog(@"авто СВОБОДНО %hhd", stopChack);
                                                   
                                                   StepTwoWithoutDriverController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StepTwoWithoutDriverController"];
                                                   self.order.car = self.car;
                                                   vc.order = self.order;

                                                   [self.navigationController pushViewController:vc animated:YES];
                                                  
                                               }

                                           }
                                              onFail:^(NSError *error, NSInteger statusCode) {
                                                  [self.activityIndicatorView stopAnimating];

                                                  if (statusCode == 7) {
                                                      NSLog(@"Это авто занято!!!!!");
                                                      [self carsBusyAlert];
                                                  }
                                    
                                              }];
    

}


#pragma mark - UIPickerView

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* newView = (UILabel*)view;
    if (!newView){
        newView = [[UILabel alloc] init];
        [newView setFont:[UIFont systemFontOfSize:16]];
        newView.textAlignment = NSTextAlignmentCenter;
        
    }
    if ([self.cell.startPlase isFirstResponder]) {
        Place *place = [self.startPlace objectAtIndex:row];
        newView.text = place.name;
    } else {
        Place *place = [self.endPlace objectAtIndex:row];
        newView.text = place.name;

       
    }
    return newView;
}

- (IBAction)checkCarAndGo {
    NSLog(@"klick___klick___klick");
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *tf = [[NSDateFormatter alloc] init];
    [tf setDateFormat:@"HH:mm"];
    
    self.order.startDateOfRentalString = [NSString stringWithFormat:@"%@T%@",[df stringFromDate:self.order.dateOfRentalStart],[tf stringFromDate:self.order.timeOfRentalStart]];
    NSLog(@"Date of start rental is ->%@", self.order.startDateOfRentalString);
    
    self.order.endDateOfRentalString = [NSString stringWithFormat:@"%@T%@",[df stringFromDate:self.order.dateOfRentalEnd],[tf stringFromDate:self.order.timeOfRentalEnd]];
    NSLog(@"Date of end rental is ->%@", self.order.endDateOfRentalString);
    
    
    
    [self chckCarForFreeAPI];

    
    
}

#pragma mark - UIAlertController



- (void) carsBusyAlert {
    
    self.alert = nil;
    self.alert = [UIAlertController alertControllerWithTitle:
                  @"" message:NSLocalizedString(@"The car is reserved. Do you want go to the list of available cars?", nil) preferredStyle:UIAlertControllerStyleAlert];
    
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"No", nil) style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {}];
    
            UIAlertAction *topic = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", nil) style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                  
                                                      WithoutDriverDetailController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WithoutDriverDetailController"];
                                                      //vc.categoryID = category.categoryID;

                                                      [self.navigationController pushViewController:vc animated:YES];

                                                  
                                                  }];
    [self.alert addAction:topic];
    [self.alert addAction:cancel];

    
    
    
    
    [self presentViewController:self.alert animated:YES completion:nil];
    
}


@end
