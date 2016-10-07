//
//  CarMainCollectionViewCell.h
//  ProkatAuto31
//
//  Created by MacUser on 12.09.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarMainCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;

#pragma mark - CellProperty

- (UICollectionViewCell*) addCollectionViewCellProperty: (UICollectionViewCell*) cell;


@end
