//
//  Order.h
//  ProkatAuto31
//
//  Created by alex on 08.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Car.h"
#import "Place.h"

@interface Order : NSObject

@property (strong, nonatomic) Car *car;

@property (strong, nonatomic) NSDate *dateOfRentalStart;
@property (strong, nonatomic) NSDate *timeOfRentalStart;

@property (strong, nonatomic) NSDate *dateOfRentalEnd;
@property (strong, nonatomic) NSDate *timeOfRentalEnd;

@property (strong, nonatomic) Place *startPlace;
@property (strong, nonatomic) Place *endPlace;

@property (strong, nonatomic) NSString *startDateOfRentalString;
@property (strong, nonatomic) NSString *endDateOfRentalString;



@property (strong, nonatomic) NSNumber *totalPrice;

@end