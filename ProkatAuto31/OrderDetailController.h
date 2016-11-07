//
//  OrderDetailController.h
//  ProkatAuto31
//
//  Created by alex on 03.11.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"


@interface OrderDetailController: UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) Order *order;

@property (weak, nonatomic) IBOutlet UILabel *cancelLable;
@property (weak, nonatomic) IBOutlet UILabel *payLable;



@end
