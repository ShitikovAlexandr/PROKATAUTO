//
//  OrderDetailController.h
//  ProkatAuto31
//
//  Created by alex on 03.11.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"


@interface OrderDetailController: UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NSString *orderId;

@property (weak, nonatomic) IBOutlet UILabel *cancelLable;
@property (weak, nonatomic) IBOutlet UILabel *payLable;
@property (strong, nonatomic) id backController;
@property (strong, nonatomic) Order *order;




@end
