//
//  OrderCell.h
//  ProkatAuto31
//
//  Created by Ivan Bielko on 28.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell: UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *carLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentStatus;
@property (weak, nonatomic) IBOutlet UILabel *penaltyLabel;
@property (weak, nonatomic) IBOutlet UILabel *penaltyStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *book;

- (UICollectionViewCell*) addCollectionViewCellProperty: (UICollectionViewCell*) cell;

@end
