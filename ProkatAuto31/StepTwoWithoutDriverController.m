//
//  StepTwoWithoutDriverController.m
//  ProkatAuto31
//
//  Created by alex on 12.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "StepTwoWithoutDriverController.h"
#import "StepTwoMainCell.h"
#import "StepTwoOptionsCell.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "Option.h"
#import "ButtonCell.h"
#import "RegistrationController.h"
#import "AuthorizationController.h"
#import "StepFourWithoutdriverController.h"




@interface StepTwoWithoutDriverController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *optionsArray;
@property (strong, nonatomic) NSString *baseAddress;
@property (strong, nonatomic) UIAlertController *alert;
@property (strong, nonatomic) NSNumberFormatter* numberFormatter;




@end

@implementation StepTwoWithoutDriverController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseAddress = @"http://83.220.170.187";
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [self.numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    
    self.order.selectOptionArray = [NSMutableArray array];

    
    self.optionsArray = [NSMutableArray array];
    
    [self getCarOptionsFromAPI];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_phone.png"] style:UIBarButtonItemStylePlain target:self action:@selector(CallAction)];

    
    
}

- (void) CallAction {
    NSLog(@"make call");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://+79036420187"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else {
         return [self.optionsArray count]+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString* identifier = @"StepTwoMainCell";
        StepTwoMainCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
        cell.carName.text = [NSString stringWithFormat:@"%@ %@ %@", self.order.car.itemFullName, self.order.car.itemEngine, self.order.car.itemTransmissionName];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseAddress, self.order.car.imageURL]];
        [cell.carImage setImageWithURL:url];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
        
        NSDateFormatter *screenDate = [[NSDateFormatter alloc] init];
        [screenDate setDateFormat:@"dd.MM.yyyy"];
        NSDate *startRental = [df dateFromString:self.order.startDateOfRentalString];
        NSDate *endRental = [df dateFromString:self.order.endDateOfRentalString];

        NSDateFormatter *screenTime = [[NSDateFormatter alloc] init];
        [screenTime setDateFormat:@"HH:mm"];
        
        cell.rentalStartDate.text = [NSString stringWithFormat:@"%@ %@", [screenDate stringFromDate:self.order.dateOfRentalStart], [screenTime stringFromDate:self.order.timeOfRentalStart]];
        cell.rentalEndDate.text = [NSString stringWithFormat:@"%@ %@", [screenDate stringFromDate:self.order.dateOfRentalEnd], [screenTime stringFromDate:self.order.timeOfRentalEnd]];
        
        
        NSLog(@"rentalPeriod %f", [endRental timeIntervalSinceDate:startRental]);
        NSInteger rentalPeriod = (NSInteger)([endRental timeIntervalSinceDate:startRental]/60/60);
        NSInteger rentalPeriodDay = (NSInteger)rentalPeriod/24;
        self.order.rentalPeriodDays = rentalPeriodDay;
        if (rentalPeriod % 24 > 0) {
            rentalPeriodDay = rentalPeriodDay+1;
        }
        NSNumber *range;
        NSInteger dayPrice;
        if (rentalPeriodDay < 4) {
            range =  self.order.car.priceRange1 ;
        } else if (rentalPeriodDay >= 4 && rentalPeriodDay < 7) {
            range =  self.order.car.priceRange2;
        } else {
            range = self.order.car.priceRange3;
        }
        dayPrice = rentalPeriodDay * [range integerValue];
        NSString *daysText = [NSString stringWithFormat:@"%ld", (long)rentalPeriodDay];

        self.order.totalPrice = [NSNumber numberWithInteger:dayPrice];
        cell.rentalPrice.text = [NSString stringWithFormat:@"%@", [self.numberFormatter stringFromNumber:self.order.totalPrice]];
        cell.rentalPriceCalculation.text = [NSString stringWithFormat:@"%@ x %ld %@", [self.numberFormatter stringFromNumber:range], (long)rentalPeriodDay, [daysText hasSuffix:@"1"] ? NSLocalizedString(@"day", nil) : NSLocalizedString(@"days", nil)];

        
        cell.deposite.text = [NSString stringWithFormat:@"%@", [self.numberFormatter stringFromNumber:self.order.car.deposit]];
        

        cell.rentalDayPeriod.text = [NSString stringWithFormat:@"%ld %@", (long)rentalPeriodDay, [daysText hasSuffix:@"1"] ? NSLocalizedString(@"day", nil) : NSLocalizedString(@"days", nil)];
        
        
        //cell.rentalDayPeriod.text = [NSString stringWithFormat:NSLocalizedString(@"%ld days", nil), (long)rentalPeriodDay];
        
        cell.placeStart.text = self.order.startPlace.locationName;
        cell.placeend.text = self.order.endPlace.locationName;
        
        
        return cell;
        
    } else {
        
        if (indexPath.row == [self.optionsArray count]) {
            ButtonCell *cell =[self.tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
            
            [cell.buttonNext addTarget:self action:@selector(registerOrLoginAlert) forControlEvents:UIControlEventTouchDown];
            
            
            return cell;
        } else {
            
            static NSString* identifier = @"StepTwoOptionsCell";
            StepTwoOptionsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
            
            Option *option = [self.optionsArray objectAtIndex:indexPath.row];
            cell.nameOption.text = [NSString stringWithFormat:@"%@",option.optionName]; //option.optionName;
            cell.optionCount.text = @"1";
            
            if ([option.optionPrice integerValue] <1) {
                cell.priceOption.text = NSLocalizedString(@"Free", nil);
            } else {
                cell.priceOption.text = [NSString stringWithFormat:NSLocalizedString(@"%d rubles per day", nil), [option.optionPrice integerValue]];
            }
            NSLog(@"optionsMultiple %@", option.optionsMultiple);
            if ([option.optionsMultiple intValue] >0) {
                NSLog(@"option name %@", option.optionAvaliableAmount);
                [cell.optionCount setUserInteractionEnabled:YES];
                cell.dropDownImg.image = [UIImage imageNamed:@"ic_arrow_drop_down_2x.png"];
                
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectOptionCount:)];
                [tapGestureRecognizer setNumberOfTapsRequired:1];
                [cell.optionCount addGestureRecognizer:tapGestureRecognizer];
            }
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 430;
    } else {
        if (indexPath.row == [self.optionsArray count]) {
            return 45;
        } else {
        return 35;
        }
    }
    
}

#pragma mark - UIAlertController



- (void) selectOptionCount: (UITapGestureRecognizer *) gesture  {
    CGPoint touchPoint=[gesture locationInView:self.tableView];
     NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    //Option *option = [self.optionsArray objectAtIndex:indexPath.row];
    
    StepTwoOptionsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    self.alert = nil;
    self.alert = [UIAlertController alertControllerWithTitle:
                  NSLocalizedString(@"Count", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    self.alert.view.transform = CGAffineTransformIdentity;
    self.alert.view.transform = CGAffineTransformScale( self.alert.view.transform, 0.8, 0.8);
    
    
    for (int i = 0; i < 3; i++) {
        
        NSString *value = [NSString stringWithFormat:@"%d",i+1];
        UIAlertAction *point = [UIAlertAction actionWithTitle:value style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [cell.switchOption setOn:YES animated:YES];
                                                          [cell.switchOption addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                                                          
                                                          cell.optionCount.text = value;
                                                          
                                                      }];
                [self.alert addAction:point];
        
    }
    [self presentViewController:self.alert animated:YES completion:nil];
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
}



- (void) registerOrLoginAlert {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:@"tokenString"];
    NSLog(@"token strin is %@", token);

    
    if ([token length] > 6) {
        [self.order.selectOptionArray removeAllObjects];
        for (NSInteger i = 0; i <[self.optionsArray count]; i++) {
            StepTwoOptionsCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            if (cell.switchOption.isOn) {
                Option *option = [self.optionsArray objectAtIndex:i];
                option.selectedAmount = cell.optionCount.text;
                NSLog(@"selectedAmount %@", cell.optionCount.text);
                [self.order.selectOptionArray addObject:option];
            }
        }
        
        
        StepFourWithoutdriverController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StepFourWithoutdriverController"];
        vc.order = self.order;
        [self.navigationController pushViewController:vc animated:YES];

    } else {
        
        AuthorizationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthorizationController"];
        vc.StepBack = true;
        StepFourWithoutdriverController *nVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StepFourWithoutdriverController"];
        nVC.order = self.order;
        vc.nextController = nVC;
        
        [self.navigationController pushViewController:vc animated:YES];

    }
}

-(void) myCustomBack {
    // Some anything you need to do before leaving
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - API

- (void) getCarOptionsFromAPI {
    
    [[ServerManager sharedManager] getCarOptionsOnSuccess:^(NSArray *thisData) {
        [self.optionsArray addObjectsFromArray:thisData];
        [self.tableView reloadData];
    } onFail:^(NSError *error, NSInteger statusCode) {
    }];
    
}


@end
