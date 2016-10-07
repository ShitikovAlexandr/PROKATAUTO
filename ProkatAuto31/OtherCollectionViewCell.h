//
//  OtherCollectionViewCell.h
//  ProkatAuto31
//
//  Created by MacUser on 21.09.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *mainText;

- (UICollectionViewCell*) addCollectionViewCellProperty: (UICollectionViewCell*) cell;

@end
