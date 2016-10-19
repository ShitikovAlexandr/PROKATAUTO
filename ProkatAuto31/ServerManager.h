//
//  ServerManager.h
//  ProkatAuto31
//
//  Created by MacUser on 19.09.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category.h"

@interface ServerManager : NSObject

+ (ServerManager*) sharedManager;

//___________

- (void) getCarWithoutDriverCategoryOnSuccess:(void(^)(NSArray* thisData)) success
                                       onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getCarWithDriverCategoryOnSuccess:(void(^)(NSArray* thisData)) success
                                       onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getCarOtherCategoryOnSuccess:(void(^)(NSArray* thisData)) success
                                       onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getCarWithoutDriverDetailOnSuccess:(void(^)(NSArray* thisData)) success
                                     onFail:(void(^)(NSError* error, NSInteger statusCode)) failure
                             withCategoryID: (NSNumber*) categoryID;

- (void) getCarWithDriverDetailOnSuccess:(void(^)(NSArray* thisData)) success
                                     onFail:(void(^)(NSError* error, NSInteger statusCode)) failure
                             withCategoryID: (NSNumber*) categoryID;


@end
