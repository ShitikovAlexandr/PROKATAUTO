//
//  ServerManager.h
//  ProkatAuto31
//
//  Created by MacUser on 19.09.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category.h"
#import "Person.h"

@interface ServerManager : NSObject

+ (ServerManager*) sharedManager;

//___________

- (void) getCarWithoutDriverCategoryOnSuccess:(void(^)(NSArray* thisData)) success
                                       onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getCarWithDriverCategoryOnSuccess:(void(^)(NSArray* thisData)) success
                                       onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getCarOtherCategoryOnSuccess:(void(^)(NSArray* thisData)) success
                                       onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;
- (void) getCarOtherCategoryWithPageOnSuccess:(void(^)(NSArray* thisData)) success
                               onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getCarWithoutDriverDetailOnSuccess:(void(^)(NSArray* thisData)) success
                                     onFail:(void(^)(NSError* error, NSInteger statusCode)) failure
                             withCategoryID: (NSNumber*) categoryID;

- (void) getCarWithoutDriverDetailWithTransmissionOnSuccess:(void(^)(NSArray* thisData)) success
                                                     onFail:(void(^)(NSError* error, NSInteger statusCode)) failure
                                             withCategoryID: (NSNumber*) categoryID;

- (void) getCarWithDriverDetailOnSuccess:(void(^)(NSArray* thisData)) success
                                     onFail:(void(^)(NSError* error, NSInteger statusCode)) failure
                             withCategoryID: (NSNumber*) categoryID;

- (void) getPlacesOnSuccess:(void(^)(NSArray* thisData)) success
                                       onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) checkCarWithCarId: (NSNumber*) carId withDateFrom: (NSString*) dateFrom withDateTo: (NSString*) dateTo
                 OnSuccess:(void(^)(NSArray* thisData)) success
                    onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getCarOptionsOnSuccess:(void(^)(NSArray* thisData)) success
                         onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) registrationGetCaptchaOnSuccess:(void(^)(NSString* thisData)) success
                                  onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) registrationGetCaptchaImgWithKey:(NSString*) key  OnSuccess:(void(^)(id thisData)) success
                                  onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;
- (void) registrationWithPersonData: (Person*) person
                             andKey: (NSString*) key
                    PasswordFromImg:(NSString*) password
                          OnSuccess:(void(^)(NSString* token, id user)) success
                             onFail:(void(^)(NSError* error, NSInteger statusCode, NSArray* dataArray)) failure;
- (void) orderCarWithDriver: (NSNumber*) carId
                  userName : (NSString*) name
            userPhoneNumber: (NSString*) phone
                  userEmail: (NSString*) email
           orderDescription: (NSString*) description
                     andKey: (NSString*) key
            passwordFromImg: (NSString*) password
                  OnSuccess: (void(^)()) success
                     onFail: (void(^)(NSError* error, NSString* errorMessage)) failure;

- (void) logInWithLogin: (NSString*) login
            andPassword: (NSString*) password
              OnSuccess:(void(^)(NSString* token, id user)) success
                 onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) rememberPasswordWithCapchaKey: (NSString*) key
                        andCapchaValue: (NSString*) value andPhone: (NSString*) phone
                             OnSuccess:(void(^)(NSString* data)) success
                                onFail:(void(^)(NSError* error, NSInteger statusCode, NSArray* dataArray)) failure;


@end