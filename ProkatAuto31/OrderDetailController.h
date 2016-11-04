//
//  OrderDetailController.h
//  ProkatAuto31
//
//  Created by alex on 03.11.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"


@interface OrderDetailController : UITableViewController
@property (strong, nonatomic) Order *order;


@property (weak, nonatomic) IBOutlet UIView *mainInfoView;

@property (weak, nonatomic) IBOutlet UIView *rentalCarView;
@property (weak, nonatomic) IBOutlet UIView *startPlaceView;
@property (weak, nonatomic) IBOutlet UIView *endPlaceView;

@property (weak, nonatomic) IBOutlet UILabel *carModel;
@property (weak, nonatomic) IBOutlet UILabel *timeDay;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *rentalDatePeriod;

@property (weak, nonatomic) IBOutlet UILabel *statusPay;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *mathCountRental;
@property (weak, nonatomic) IBOutlet UILabel *mathCountTotal;
@property (weak, nonatomic) IBOutlet UILabel *starrtPlace;
@property (weak, nonatomic) IBOutlet UILabel *priceStartPlace;
@property (weak, nonatomic) IBOutlet UILabel *endPlace;
@property (weak, nonatomic) IBOutlet UILabel *endPlacePrice;


@property (weak, nonatomic) IBOutlet UILabel *cancelLable;
@property (weak, nonatomic) IBOutlet UILabel *payLable;


@end
