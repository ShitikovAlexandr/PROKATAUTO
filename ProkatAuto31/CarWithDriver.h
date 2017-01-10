//
//  CarWithDriver.h
//  ProkatAuto31
//
//  Created by Ivan Bielko on 19.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarWithDriver : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *carDescription;
@property (strong, nonatomic) NSNumber *carId;
@property (strong, nonatomic) NSString *imageURL;

- (id) initWithServerResponse: (NSDictionary*) responseObject;

@end
