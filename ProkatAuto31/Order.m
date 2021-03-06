//
//  Order.m
//  ProkatAuto31
//
//  Created by alex on 08.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
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
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
        self.dateOfRentalStart = [[NSDate alloc] init];
        self.dateOfRentalStart = [dateFormatter dateFromString:self.startDateOfRentalString];
        self.dateOfRentalEnd = [[NSDate alloc] init];
        self.dateOfRentalEnd = [dateFormatter dateFromString:self.endDateOfRentalString];
        
        self.days = [responseObject objectForKey:@"days"];
        self.totalPrice = [responseObject objectForKey:@"total_amount"];
        self.paymentStatus = [responseObject objectForKey:@"payment_status"];
        self.paid = [responseObject objectForKey:@"paid"];
        
        self.penaltyStatus = [responseObject objectForKey:@"penalty_status"];
        self.penalty = [responseObject objectForKey:@"penalty"];
        self.penaltyPaid = [responseObject objectForKey:@"penalty_paid"];
        self.selectOptionArray = [NSMutableArray array];

        
    }
    
    
    return self;
}

@end
