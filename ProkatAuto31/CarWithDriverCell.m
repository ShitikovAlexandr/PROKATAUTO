//
//  CarWithDriverCell.m
//  ProkatAuto31
//
//  Created by Ivan Bielko on 09.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "CarWithDriverCell.h"

@implementation CarWithDriverCell : UICollectionViewCell

- (UICollectionViewCell*) addCollectionViewCellProperty: (UICollectionViewCell*) cell {
    
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.cornerRadius = 4.f;
    cell.contentView.layer.cornerRadius = 4.f;
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(2.f, 2.0f);
    cell.layer.shadowRadius = 4.0f;
    cell.layer.shadowOpacity = 2.0f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    cell.userInteractionEnabled = YES;
    
    
    return cell;
    
    
}

@end
