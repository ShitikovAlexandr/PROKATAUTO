//
//  CarWithoutDriverDetailsCell.h
//  ProkatAuto31
//
//  Created by MacUser on 25.09.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarWithoutDriverDetailsCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainCarImage;

@property (weak, nonatomic) IBOutlet UILabel *carName;//

@property (weak, nonatomic) IBOutlet UILabel *priceFrom;//
@property (weak, nonatomic) IBOutlet UILabel *priceRange1;
@property (weak, nonatomic) IBOutlet UILabel *priceRange2;
@property (weak, nonatomic) IBOutlet UILabel *priceRange3;
@property (weak, nonatomic) IBOutlet UILabel *deposit;//


@property (weak, nonatomic) IBOutlet UIButton *InfoButton;//
@property (weak, nonatomic) IBOutlet UIButton *rentalButton;

@property (weak, nonatomic) IBOutlet UILabel *transmission;//
@property (weak, nonatomic) IBOutlet UILabel *engine;//
@property (weak, nonatomic) IBOutlet UILabel *power;//
@property (weak, nonatomic) IBOutlet UILabel *fuel;//
@property (weak, nonatomic) IBOutlet UILabel *color;


- (UICollectionViewCell*) addCollectionViewCellProperty: (UICollectionViewCell*) cell;

@end
