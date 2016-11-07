//
//  ButtonCell.m
//  ProkatAuto31
//
//  Created by alex on 17.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "ButtonCell.h"

@implementation ButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.buttonNext.layer.cornerRadius = 3.f;
    self.buttonNext.layer.borderWidth = 1.0f;
    self.buttonNext.layer.borderColor = [UIColor blackColor].CGColor;
    self.buttonNext.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
