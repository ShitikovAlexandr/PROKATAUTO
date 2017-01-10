//
//  StepTwoOptionsCell.h
//  ProkatAuto31
//
//  Created by alex on 13.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepTwoOptionsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *switchOption;
@property (weak, nonatomic) IBOutlet UILabel *nameOption;
@property (weak, nonatomic) IBOutlet UILabel *priceOption;
@property (weak, nonatomic) IBOutlet UILabel *optionCount;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImg;

@end
