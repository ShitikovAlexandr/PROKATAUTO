//
//  Category.h
//  ProkatAuto31
//
//  Created by MacUser on 15.09.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *slug;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSNumber *categoryID;
@property (strong, nonatomic) NSString *maimDescription;
@property (strong, nonatomic) NSString *textContenier;


- (id) initWithServerResponse: (NSDictionary*) responseObject;

@end
