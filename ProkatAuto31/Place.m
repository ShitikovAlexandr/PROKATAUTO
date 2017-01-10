//
//  Place.m
//  ProkatAuto31
//
//  Created by alex on 12.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "Place.h"

@implementation Place


- (instancetype) initWithServerResponse:(NSDictionary *)responseObject {
    
     self = [super init];
    
    if (self) {
        self.placeID = [responseObject objectForKey:@"id"];
        self.name = [responseObject objectForKey:@"name"];
        self.locationName = [responseObject objectForKey:@"location_name"];
        self.descriptionPlace = [responseObject objectForKey:@"description"];
        self.image = [responseObject objectForKey:@"image"];
        self.serviceType = [responseObject objectForKey:@"service_type"];
        
        if ([responseObject objectForKey:@"price"]) {
            self.price = [responseObject objectForKey:@"price"];
        }
    }
    
    return self;
}

@end
