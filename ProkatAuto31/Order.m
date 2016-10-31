//
//  Order.m
//  ProkatAuto31
//
//  Created by alex on 08.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "Order.h"

@implementation Order

- (id) initWithServerResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    
    if (self) {
        self.orderId = [responseObject objectForKey:@"id"];
        self.car = [[Car alloc] initWithServerOrderResponse:[responseObject objectForKey:@"car"]];
        self.status = [responseObject objectForKey:@"status"];
        self.number = [responseObject objectForKey:@"number"];
        self.startDateOfRentalString = [responseObject objectForKey:@"date_from"];
        self.endDateOfRentalString = [responseObject objectForKey:@"date_to"];
        self.days = [responseObject objectForKey:@"days"];
        self.totalPrice = [responseObject objectForKey:@"total_amount"];
        self.paymentStatus = [responseObject objectForKey:@"payment_status"];
        self.paid = [responseObject objectForKey:@"paid"];
    }
    
    
    return self;
}

@end
