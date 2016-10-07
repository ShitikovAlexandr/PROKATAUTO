//
//  StepOneCollectionViewCell.h
//  ProkatAuto31
//
//  Created by alex on 05.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepOneCollectionViewCell : UICollectionViewCell 

@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *priceRange1;
@property (weak, nonatomic) IBOutlet UILabel *priceRange2;
@property (weak, nonatomic) IBOutlet UILabel *priceRange3;
@property (weak, nonatomic) IBOutlet UILabel *deposit;

@property (weak, nonatomic) IBOutlet UIView *supplyCarView;
@property (weak, nonatomic) IBOutlet UIView *ReturnCarView;
@property (weak, nonatomic) IBOutlet UITextField *DateReturnTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeReturnTextField;



@property (weak, nonatomic) IBOutlet UITextField *dateStartTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeStartTextField;




@end
