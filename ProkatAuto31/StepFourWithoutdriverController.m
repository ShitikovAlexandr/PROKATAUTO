//
//  StepFourWithoutdriverController.m
//  ProkatAuto31
//
//  Created by alex on 26.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "StepFourWithoutdriverController.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "Option.h"

@interface StepFourWithoutdriverController ()
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *carFullName;
@property (weak, nonatomic) IBOutlet UILabel *rentalPeriodDays;
@property (weak, nonatomic) IBOutlet UILabel *startRental;
@property (weak, nonatomic) IBOutlet UILabel *endRental;
@property (weak, nonatomic) IBOutlet UILabel *startPlace;
@property (weak, nonatomic) IBOutlet UILabel *endPlace;
@property (weak, nonatomic) IBOutlet UILabel *calculateRental;
@property (weak, nonatomic) IBOutlet UILabel *deposite;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *optionPrice;
@property (weak, nonatomic) IBOutlet UIView *priceVew;
@property (weak, nonatomic) IBOutlet UILabel *priceForDaysOnly;

@property (strong, nonatomic) NSString *baseAddress;


@end

@implementation StepFourWithoutdriverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseAddress = @"http://83.220.170.187";
    self.title = @"Шаг 4: Подтверждение заказа";
    

    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseAddress, self.order.car.imageURL]];
    [self.carImageView setImageWithURL:url];
    
    self.carFullName.text = [NSString stringWithFormat:@"%@ %@", self.order.car.itemFullName, self.order.car.itemTransmissionName];
    self.rentalPeriodDays.text = [NSString stringWithFormat:@"%d", self.order.rentalPeriodDays];
    NSDateFormatter *screenDate = [[NSDateFormatter alloc] init];
    [screenDate setDateFormat:@"dd.MM.yyyy"];
    NSDateFormatter *screenTime = [[NSDateFormatter alloc] init];
    [screenTime setDateFormat:@"HH:mm"];
    
    self.startRental.text = [NSString stringWithFormat:@"%@ %@", [screenDate stringFromDate:self.order.dateOfRentalStart], [screenTime stringFromDate:self.order.timeOfRentalStart]];
    self.endRental.text = [NSString stringWithFormat:@"%@ %@", [screenDate stringFromDate:self.order.dateOfRentalEnd], [screenTime stringFromDate:self.order.timeOfRentalEnd]];
    self.startPlace.text = [NSString stringWithFormat:@"%@", self.order.startPlace.locationName];
    self.endPlace.text = [NSString stringWithFormat:@"%@", self.order.endPlace.locationName];
    self.priceForDaysOnly.text = [self.order.totalPrice stringValue];
    
    NSInteger range;
    if (self.order.rentalPeriodDays  < 4) {
        range =  [self.order.car.priceRange1 integerValue];
    } else if (self.order.rentalPeriodDays >= 4 && self.order.rentalPeriodDays < 7) {
        range =  [self.order.car.priceRange2 integerValue];
    } else {
        range =  [self.order.car.priceRange3 integerValue];
        
    }
    NSString *daysText = [NSString stringWithFormat:@"%d", self.order.rentalPeriodDays];
    self.calculateRental.text = [NSString stringWithFormat:@"%d x %d %@", range, self.order.rentalPeriodDays ,[daysText hasSuffix:@"1"] ? @"сутки" : @"суток"];
    
    
    
    NSInteger optionTotalPrice = 0;
    for (Option *opt in self.order.selectOptionArray) {
        optionTotalPrice = optionTotalPrice + [opt.optionPrice integerValue] * [opt.selectedAmount integerValue];
        NSLog(@"optionPrice - %d, %d", [opt.optionPrice integerValue], [opt.selectedAmount integerValue]);
    }
    /*
    if ([self.order.selectOptionArray count] == 0) {
        CGSize recSize = CGSizeMake(self.priceVew.frame.size.width, self.priceVew.frame.size.height - 50);
        self.priceVew.frame.size = recSize;
    }
    
    self.optionPrice.text = [NSString stringWithFormat:@"%d", optionTotalPrice];
    self.totalPrice.text = [NSString stringWithFormat:@"%d", optionTotalPrice + [self.order.totalPrice integerValue]];
    */
    
/*
 cell.carName.text = [NSString stringWithFormat:@"%@ %@ %@", self.order.car.itemFullName, self.order.car.itemEngine, self.order.car.itemTransmissionName];
 NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseAddress, self.order.car.imageURL]];
 [cell.carImage setImageWithURL:url];
 
 NSDateFormatter *df = [[NSDateFormatter alloc] init];
 [df setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
 
 NSDateFormatter *screenDate = [[NSDateFormatter alloc] init];
 [screenDate setDateFormat:@"dd.MM.yyyy"];
 
 NSDate *startRental = [df dateFromString:self.order.startDateOfRentalString];
 NSDate *endRental = [df dateFromString:self.order.endDateOfRentalString];
 NSLog(@"Date of start rental %@", startRental);
 NSLog(@"Date of end rental %@", endRental);
 
 cell.rentalStartDate.text = [screenDate stringFromDate:startRental];
 cell.rentalEndDate.text = [screenDate stringFromDate:endRental];
 
 
 NSLog(@"rentalPeriod %f", [endRental timeIntervalSinceDate:startRental]);
 NSInteger rentalPeriod = (NSInteger)([endRental timeIntervalSinceDate:startRental]/60/60);
 NSInteger rentalPeriodDay = (NSInteger)rentalPeriod/24;
 if (rentalPeriod % 24 > 0) {
 rentalPeriodDay = rentalPeriodDay+1;
 }
 NSInteger range;
 NSInteger dayPrice;
 if (rentalPeriodDay < 4) {
 range =  [self.order.car.priceRange1 integerValue];
 } else if (rentalPeriodDay >= 4 && rentalPeriodDay < 7) {
 range =  [self.order.car.priceRange2 integerValue];
 } else {
 range =  [self.order.car.priceRange3 integerValue];
 
 }
 dayPrice = rentalPeriodDay * range;

 
 
 */
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
