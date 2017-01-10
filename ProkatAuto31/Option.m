//
//  Option.m
//  ProkatAuto31
//
//  Created by alex on 17.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "Option.h"

@implementation Option

- (instancetype) initWithServerResponse:(NSDictionary *)responseObject {
    self =[super init];
    
    if (self) {
        self.optionId = [responseObject objectForKey:@"id"];
        self.optionName = [responseObject objectForKey:@"name"];
        self.optionComent = [responseObject objectForKey:@"comment"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *status =  [defaults valueForKey:@"status"];
        
        if ([status integerValue] == 2) {
            // @"Постоянный клиент"; stable_client_price
            self.optionPrice = [responseObject objectForKey:@"stable_client_price"];
        } else if ([status integerValue] == 3) {
            //@"VIP клиент"; vip_client_price
            self.optionPrice = [responseObject objectForKey:@"vip_client_price"];
        } else {
            self.optionPrice = [responseObject objectForKey:@"price"];
        }

        self.optionStableClientPrice = [responseObject objectForKey:@"stable_client_price"];
        self.optionVipClientPrice = [responseObject objectForKey:@"vip_client_price"];
        self.optionDailyPayment = [responseObject objectForKey:@"daily_payment"];
        self.optionsMultiple = [responseObject objectForKey:@"multiple"];
        self.optionImage = [responseObject objectForKey:@"image"];
        self.optionAvaliableAmount = [responseObject objectForKey:@"avaliable_amount"];
        self.optionWeight = [responseObject objectForKey:@"weight"];
        
    }
    
    return self;
    
}

@end
