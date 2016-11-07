//
//  OrderDitailOptionsCell.m
//  ProkatAuto31
//
//  Created by alex on 04.11.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "OrderDitailOptionsCell.h"

@implementation OrderDitailOptionsCell

- (void)awakeFromNib {
     [super awakeFromNib];
    
    self.optionView.layer.cornerRadius = 2.f;
    self.optionView.layer.borderWidth = 0.5f;
    self.optionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.optionView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.optionView.layer.shadowOffset = CGSizeMake(2.f, 2.0f);
    self.optionView.layer.shadowRadius = 2.0f;
    self.optionView.layer.shadowOpacity = 2.0f;
    self.optionView.layer.masksToBounds = NO;

}


@end
