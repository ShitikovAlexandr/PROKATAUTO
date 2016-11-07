//
//  OrderDitailOptionsCell.h
//  ProkatAuto31
//
//  Created by alex on 04.11.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDitailOptionsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *optionName;
@property (weak, nonatomic) IBOutlet UILabel *optionTotalPrice;
@property (weak, nonatomic) IBOutlet UIView *optionView;

@end
