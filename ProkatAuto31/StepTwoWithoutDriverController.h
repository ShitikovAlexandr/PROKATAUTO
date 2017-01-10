//
//  StepTwoWithoutDriverController.h
//  ProkatAuto31
//
//  Created by alex on 12.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"



@interface StepTwoWithoutDriverController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) Order *order;




@end
