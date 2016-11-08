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
@property (weak, nonatomic) IBOutlet UILabel *optionPriceText;

@property (strong, nonatomic) NSString *baseAddress;


@end

@implementation StepFourWithoutdriverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseAddress = @"http://83.220.170.187";
    
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
    self.calculateRental.text = [NSString stringWithFormat:@"%d x %d %@", range, self.order.rentalPeriodDays ,[daysText hasSuffix:@"1"] ? NSLocalizedString(@"day", nil) : NSLocalizedString(@"days", nil)];
    self.deposite.text = [NSString stringWithFormat:@"%@", self.order.car.deposit];//self.order.car.deposit;
    
    
    
    NSInteger optionTotalPrice = 0;
    for (Option *opt in self.order.selectOptionArray) {
        optionTotalPrice = optionTotalPrice + [opt.optionPrice integerValue] * [opt.selectedAmount integerValue];
        NSLog(@"optionPrice - %d, %d", [opt.optionPrice integerValue], [opt.selectedAmount integerValue]);
        
    }
    
    self.optionPrice.text = [NSString stringWithFormat:@"%d", optionTotalPrice];
    self.totalPrice.text = [NSString stringWithFormat:@"%d", optionTotalPrice + [self.order.totalPrice integerValue] + [self.order.car.deposit integerValue]];
    
    if ([self.optionPrice.text integerValue]<1) {
        CGRect rect = self.priceVew.frame;
        rect.size.height = self.priceVew.frame.size.height - 25.f;
        self.priceVew.frame = rect;
        [self.optionPrice removeFromSuperview];
        [self.optionPriceText removeFromSuperview];
        
    }
    
    
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
