//
//  Category.h
//  ProkatAuto31
//
//  Created by MacUser on 15.09.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *slug;
@property (strong, nonatomic) NSString *image;
@property (assign, nonatomic) NSNumber *categoryID;
@property (strong, nonatomic) NSString *maimDescription;


- (id) initWithServerResponse: (NSDictionary*) responseObject;

@end
