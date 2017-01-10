//
//  OrderDetailMainCell.m
//  ProkatAuto31
//
//  Created by alex on 04.11.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "OrderDetailMainCell.h"

@implementation OrderDetailMainCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setRCStyleOfView:self.mainInfoView];
    [self setRCStyleOfView:self.rentalCarView];
    [self setRCStyleOfView:self.startPlaceView];
    [self setRCStyleOfView:self.endPlaceView];
    
    self.orderStatus.layer.cornerRadius = 3.f;
    self.orderStatus.layer.borderWidth = 1.f;
    
}

- (void) setRCStyleOfView: (UIView*) view {
    view.layer.cornerRadius = 2.f;
    view.layer.borderWidth = 0.5f;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(2.f, 2.0f);
    view.layer.shadowRadius = 2.0f;
    view.layer.shadowOpacity = 2.0f;
    view.layer.masksToBounds = NO;
}


@end
