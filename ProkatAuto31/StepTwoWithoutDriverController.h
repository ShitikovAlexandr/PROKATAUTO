//
//  StepTwoWithoutDriverController.h
//  ProkatAuto31
//
//  Created by alex on 12.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"



@interface StepTwoWithoutDriverController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) Order *order;




@end
