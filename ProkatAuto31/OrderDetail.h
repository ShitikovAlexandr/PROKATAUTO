//
//  OrderDetail.h
//  ProkatAuto31
//
//  Created by alex on 04.11.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetail : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *amount;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSNumber *option;

- (id) initWithServerResponse: (NSDictionary*) responseObject;

@end
