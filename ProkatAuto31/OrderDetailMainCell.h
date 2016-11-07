//
//  OrderDetailMainCell.h
//  ProkatAuto31
//
//  Created by alex on 04.11.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailMainCell : UICollectionViewCell

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




@end
