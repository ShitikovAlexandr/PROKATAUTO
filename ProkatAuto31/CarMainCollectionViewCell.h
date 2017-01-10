//
//  CarMainCollectionViewCell.h
//  ProkatAuto31
//
//  Created by MacUser on 12.09.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarMainCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *mainDescription;



#pragma mark - CellProperty

- (UICollectionViewCell*) addCollectionViewCellProperty: (UICollectionViewCell*) cell;


@end
