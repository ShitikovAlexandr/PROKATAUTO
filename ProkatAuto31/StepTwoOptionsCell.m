//
//  StepTwoOptionsCell.m
//  ProkatAuto31
//
//  Created by alex on 13.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "StepTwoOptionsCell.h"

@implementation StepTwoOptionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
      //self.nameOption.layer.borderColor = [UIColor lightGrayColor].CGColor;
      //self.nameOption.layer.borderWidth = 1.0;
    self.nameView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.nameView.layer.shadowOffset = CGSizeMake(-1.f, 0.0f);
    self.nameView.layer.shadowRadius = 0;
    self.nameView.layer.shadowOpacity = 2;
    self.nameView.layer.masksToBounds = NO;
    
    self.priceView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.priceView.layer.shadowOffset = CGSizeMake(-1.f, 0.0f);
    self.priceView.layer.shadowRadius = 0;
    self.priceView.layer.shadowOpacity = 2;
    self.priceView.layer.masksToBounds = NO;
    
    self.countView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.countView.layer.shadowOffset = CGSizeMake(-1.f, 0.0f);
    self.countView.layer.shadowRadius = 0;
    self.countView.layer.shadowOpacity = 2;
    self.countView.layer.masksToBounds = NO;
    
    self.switchOption.transform = CGAffineTransformMakeScale(0.7, 0.7);
    self.switchOption.onTintColor = [UIColor redColor];
    
    


    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

/*
 @property (weak, nonatomic) IBOutlet UILabel *priceOption;
 @property (weak, nonatomic) IBOutlet UILabel *optionCount;
 
 textField.layer.shadowColor = [UIColor grayColor].CGColor;
 textField.layer.shadowOffset = CGSizeMake(0.f, 1.0f);
 textField.layer.shadowRadius = 0;
 textField.layer.shadowOpacity = 1;
 textField.layer.masksToBounds = NO;

 */
