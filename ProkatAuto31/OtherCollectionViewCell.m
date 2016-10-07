//
//  OtherCollectionViewCell.m
//  ProkatAuto31
//
//  Created by MacUser on 21.09.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "OtherCollectionViewCell.h"

@implementation OtherCollectionViewCell

- (UICollectionViewCell*) addCollectionViewCellProperty: (UICollectionViewCell*) cell {
    
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.cornerRadius = 1.f;
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(1.f, 2.0f);
    cell.layer.shadowRadius = 1.0f;
    cell.layer.shadowOpacity = 1.0f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    cell.userInteractionEnabled = YES;
    
    
    return cell;
    
    
}


@end
