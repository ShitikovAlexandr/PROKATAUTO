//
//  Place.h
//  ProkatAuto31
//
//  Created by alex on 12.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject

@property (assign, nonatomic) NSNumber *placeID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *locationName;
@property (strong, nonatomic) NSString *descriptionPlace;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *serviceType;


- (id) initWithServerResponse: (NSDictionary*) responseObject;

@end
