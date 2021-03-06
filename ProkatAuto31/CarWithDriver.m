//
//  CarWithDriver.m
//  ProkatAuto31
//
//  Created by Ivan Bielko on 19.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "CarWithDriver.h"
#import <Foundation/Foundation.h>

@implementation CarWithDriver

- (id) initWithServerResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    
    if (self) {
        
        self.name = [responseObject objectForKey:@"name"];
        self.carId = [responseObject objectForKey:@"id"];
        self.carDescription = [responseObject objectForKey:@"description"];

        NSDictionary *imgDic = [[responseObject objectForKey:@"car_images"] objectAtIndex:0];
        self.imageURL = [imgDic objectForKey:@"image"];
    }
    
    
    return self;
}

@end
