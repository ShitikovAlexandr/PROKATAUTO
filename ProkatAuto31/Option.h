//
//  Option.h
//  ProkatAuto31
//
//  Created by alex on 17.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Option : NSObject

@property (strong, nonatomic) NSString *optionId;
@property (strong, nonatomic) NSString *optionName;
@property (strong, nonatomic) NSString *optionComent;
@property (strong, nonatomic) NSString *optionPrice;
@property (strong, nonatomic) NSString *optionStableClientPrice;
@property (strong, nonatomic) NSString *optionVipClientPrice;
@property (strong, nonatomic) NSString *optionDailyPayment;
@property (strong, nonatomic) NSString *optionsMultiple;
@property (strong, nonatomic) NSString *optionImage;
@property (strong, nonatomic) NSNumber *optionAvaliableAmount;
@property (strong, nonatomic) NSString *optionWeight;
@property (strong, nonatomic) NSString *selectedAmount;


- (id) initWithServerResponse: (NSDictionary*) responseObject;



@end
