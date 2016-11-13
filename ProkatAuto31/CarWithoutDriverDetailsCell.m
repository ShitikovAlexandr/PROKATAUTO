//
//  CarWithoutDriverDetailsCell.m
//  ProkatAuto31
//
//  Created by MacUser on 25.09.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "CarWithoutDriverDetailsCell.h"

@implementation CarWithoutDriverDetailsCell

- (UICollectionViewCell*) addCollectionViewCellProperty: (UICollectionViewCell*) cell {
    
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.cornerRadius = 4.f;
    cell.contentView.layer.cornerRadius = 4.f;
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(2.f, 2.0f);
    cell.layer.shadowRadius = 4.0f;
    cell.layer.shadowOpacity = 2.0f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    self.rentalButton.layer.cornerRadius = 3.f;
    self.rentalButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.rentalButton.layer.masksToBounds = YES;

    
    cell.userInteractionEnabled = YES;
    
    
    return cell;
    
    
}


@end
