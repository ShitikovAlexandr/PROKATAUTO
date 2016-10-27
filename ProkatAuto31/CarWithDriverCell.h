//
//  CarWithDriverCell.h
//  ProkatAuto31
//
//  Created by Ivan Bielko on 09.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarWithDriverCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;

- (UICollectionViewCell*) addCollectionViewCellProperty: (UICollectionViewCell*) cell;

@end
