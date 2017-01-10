//
//  Car.m
//  ProkatAuto31
//
//  Created by MacUser on 26.09.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "Car.h"

@implementation Car

- (id) initWithServerResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    
    if (self) {
        self.itemColor = [NSMutableArray array];
        self.carID = [NSMutableArray array];
        
        self.itemCategoryId = [[responseObject objectForKey:@"category"] objectForKey:@"id"];
        self.itemCategoryId = [[responseObject objectForKey:@"category"] objectForKey:@"name"];
        
        self.itemFullName = [responseObject objectForKey:@"full_name"];
        self.itemBrandName = [[responseObject objectForKey:@"brand"] objectForKey:@"name"];
        self.itemBrandID = [[responseObject objectForKey:@"brand"] objectForKey:@"id"];
        self.itemModelName = [[responseObject objectForKey:@"model"] objectForKey:@"name"];
        self.itemModelID = [[responseObject objectForKey:@"model"] objectForKey:@"id"];
        
        self.itemEngine = [responseObject objectForKey:@"engine"];
        
        NSDictionary *fuelDic = [[responseObject objectForKey:@"fuel"] objectAtIndex:0];
        self.itemFuelID = [fuelDic objectForKey:@"id"];
        self.itemFuelName = [fuelDic objectForKey:@"name"];
        self.itemPower = [responseObject objectForKey:@"power"];
        
        self.itemTransmissionName = [[responseObject objectForKey:@"transmission"] objectForKey:@"name"];
        self.itemTransmissionType = [[responseObject objectForKey:@"transmission"] objectForKey:@"type"];

        self.minimumPrice = [responseObject objectForKey:@"minimum_price"];
        
        NSDictionary *imgDic = [[responseObject objectForKey:@"car_images"] objectAtIndex:0];
        self.imageURL = [imgDic objectForKey:@"url"];
        
        NSDictionary *idDic = [responseObject objectForKey:@"cars"] ;
        for (NSDictionary*  str in idDic) {
            NSString *carId = [str objectForKey:@"id"];
            NSString *color = [[str objectForKey:@"color"] objectForKey:@"name"];
            
            [self.carID addObject:carId];
            [self.itemColor addObject:color];
        }
      

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *status =  [defaults valueForKey:@"status"];
        
        self.deposit = [responseObject objectForKey:@"deposit"];
        
      
        if ([status integerValue] == 2) {
            // @"Постоянный клиент"; stable_client_price
            NSDictionary *range1Dic = [[responseObject objectForKey:@"car_prices"] objectAtIndex:0];
            self.priceRange1 = [range1Dic objectForKey:@"stable_client_price"];
            
            NSDictionary *range2Dic = [[responseObject objectForKey:@"car_prices"] objectAtIndex:1];
            self.priceRange2 = [range2Dic objectForKey:@"stable_client_price"];
            
            NSDictionary *range3Dic = [[responseObject objectForKey:@"car_prices"] objectAtIndex:2];
            self.priceRange3 = [range3Dic objectForKey:@"stable_client_price"];
            
        } else if ([status integerValue] == 3) {
            //@"VIP клиент"; vip_client_price
            NSDictionary *range1Dic = [[responseObject objectForKey:@"car_prices"] objectAtIndex:0];
            self.priceRange1 = [range1Dic objectForKey:@"vip_client_price"];
            
            NSDictionary *range2Dic = [[responseObject objectForKey:@"car_prices"] objectAtIndex:1];
            self.priceRange2 = [range2Dic objectForKey:@"vip_client_price"];
            
            NSDictionary *range3Dic = [[responseObject objectForKey:@"car_prices"] objectAtIndex:2];
            self.priceRange3 = [range3Dic objectForKey:@"vip_client_price"];
            
        } else {
            
            NSDictionary *range1Dic = [[responseObject objectForKey:@"car_prices"] objectAtIndex:0];
            self.priceRange1 = [range1Dic objectForKey:@"price"];
            
            NSDictionary *range2Dic = [[responseObject objectForKey:@"car_prices"] objectAtIndex:1];
            self.priceRange2 = [range2Dic objectForKey:@"price"];
            
            NSDictionary *range3Dic = [[responseObject objectForKey:@"car_prices"] objectAtIndex:2];
            self.priceRange3 = [range3Dic objectForKey:@"price"];
            
        }

        
       
        
        
        
    }
    
    
    return self;
}

- (id) initWithServerOrderResponse: (NSDictionary*) responseObject
{
    self.carID = [responseObject objectForKey:@"id"];
    self.itemFullName = [responseObject objectForKey:@"full_name"];
    self.regNumber = [responseObject objectForKey:@"reg_number"];
    
    return self;
}

@end
