//
//  StepTwoMainCell.h
//  ProkatAuto31
//
//  Created by alex on 13.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepTwoMainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UILabel *carName;

@property (weak, nonatomic) IBOutlet UILabel *rentalDayPeriod;
@property (weak, nonatomic) IBOutlet UILabel *rentalStartDate;
@property (weak, nonatomic) IBOutlet UILabel *rentalEndDate;
@property (weak, nonatomic) IBOutlet UILabel *placeStart;
@property (weak, nonatomic) IBOutlet UILabel *placeend;
@property (weak, nonatomic) IBOutlet UILabel *rentalPrice;
@property (weak, nonatomic) IBOutlet UILabel *rentalPriceCalculation;
@property (weak, nonatomic) IBOutlet UILabel *deposite;

@end
