//
//  OrderDetail.m
//  ProkatAuto31
//
//  Created by alex on 04.11.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "OrderDetail.h"

@implementation OrderDetail

- (id) initWithServerResponse: (NSDictionary*) responseObject {
    
    self = [super init];
    
    if (self) {
        self.amount = [responseObject objectForKey:@"amount"];
        self.name = [responseObject objectForKey:@"name"];
        self.price = [responseObject objectForKey:@"price"];
        self.option = [responseObject objectForKey:@"option"];
    }


    return self;
}

@end
