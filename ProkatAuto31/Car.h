//
//  Car.h
//  ProkatAuto31
//
//  Created by MacUser on 26.09.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Car : NSObject

@property (strong, nonatomic) NSMutableArray *carID;
@property (strong, nonatomic) NSString *itemCategoryId;//
@property (strong, nonatomic) NSString *itemCategoryName;//


@property (strong, nonatomic) NSString *itemFullName; //
@property (strong, nonatomic) NSString *itemBrandName;//
@property (strong, nonatomic) NSString *itemBrandID;//
@property (strong, nonatomic) NSString *itemModelName;//
@property (strong, nonatomic) NSString *itemModelID;//

@property (strong, nonatomic) NSMutableArray *itemColor;

@property (strong, nonatomic) NSString *itemEngine;//
@property (strong, nonatomic) NSString *itemFuelName;//
@property (strong, nonatomic) NSString *itemFuelID;//

@property (strong, nonatomic) NSString *itemPower;//

@property (strong, nonatomic) NSString *itemTransmissionName;//
@property (strong, nonatomic) NSNumber *itemTransmissionType;//

@property (strong, nonatomic) NSNumber *deposit;//
@property (assign, nonatomic) BOOL *isBusy;
@property (strong, nonatomic) NSString *dateFrom;
@property (strong, nonatomic) NSString *dateTo;

@property (strong, nonatomic) NSNumber *minimumPrice;//
@property (strong, nonatomic) NSNumber *priceRange1;//
@property (strong, nonatomic) NSNumber *priceRange2;//
@property (strong, nonatomic) NSNumber *priceRange3;//

@property (strong, nonatomic) NSString *imageURL;//
@property (strong, nonatomic) NSString *regNumber;





- (id) initWithServerResponse: (NSDictionary*) responseObject;
- (id) initWithServerOrderResponse: (NSDictionary*) responseObject;




@end
