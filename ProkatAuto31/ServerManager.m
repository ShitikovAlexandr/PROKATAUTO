//
//  ServerManager.m
//  ProkatAuto31
//
//  Created by MacUser on 19.09.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "Category.h"
#import "Car.h"
#import "Place.h"
#import "Option.h"
#import "User.h"
#import "Person.h"
#import "CarWithDriver.h"


@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;


@end

@implementation ServerManager

+ (ServerManager*) sharedManager {
    
    static ServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:@"http://83.220.170.187/api/v1/public/"];
        
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
       //[self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    }
    return self;
}

#pragma mark - API Methods

- (void) getCarWithoutDriverCategoryOnSuccess:(void(^)(NSArray* thisData)) success
                                       onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

    
    [self.sessionManager GET:@"thesaurus/"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSArray *dictsArray = [responseObject objectForKey:@"carCategories"];
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary* dic in dictsArray) {
                             Category *category = [[Category alloc] initWithServerResponse:dic];
                             [objectsArray addObject:category];
                         }
                         if (success) {
                             success(objectsArray);
                         }
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"Error: %@", error);
                     }];
    
}

- (void) getCarWithDriverCategoryOnSuccess:(void(^)(NSArray* thisData)) success
                                    onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

    
    [self.sessionManager GET:@"thesaurus/"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSArray *dictsArray = [responseObject objectForKey:@"hourlyCarCategories"];
                         NSArray *otherCategory = [responseObject objectForKey:@"hourlyCarsGroups"];
                         
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         NSMutableArray *filterArrayID = [NSMutableArray array];
                         
                         for (NSDictionary* filter in  otherCategory) {
                             NSArray *filterString = [filter objectForKey:@"categories"];
                             [filterArrayID addObjectsFromArray:filterString];
                         }
                         
                         for (NSDictionary* dic in dictsArray) {
                                 Category *category = [[Category alloc] initWithServerResponse:dic];
                             
                             for (NSNumber* num in filterArrayID) {
                                 if ([num isEqualToNumber:category.categoryID]) {
                                     [objectsArray addObject:category];
                                     break;
                                 }
                             }
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);
                     }];

    
}

- (void) getCarOtherCategoryOnSuccess:(void(^)(NSArray* thisData)) success
                               onFail:(void(^)(NSError* error, NSInteger statusCode)) failure  {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];


    
    [self.sessionManager GET:@"thesaurus/"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         NSArray *dictsArray = [responseObject objectForKey:@"hourlyCarCategories"];
                         NSArray *otherCategory = [responseObject objectForKey:@"hourlyCarsGroups"];
                         
                         
                         NSMutableArray *filterArrayID = [NSMutableArray array];
                         
                         for (NSDictionary* filter in  otherCategory) {
                             NSArray *filterString = [filter objectForKey:@"categories"];
                             [filterArrayID addObjectsFromArray:filterString];
                         }
                         
                         for (NSDictionary* dic in dictsArray) {
                             Category *category = [[Category alloc] initWithServerResponse:dic];
                              [objectsArray addObject:category];
                             for (NSNumber* num in filterArrayID) {
                               
                                 if ([num isEqualToNumber:category.categoryID]) {
                                     
                                     [objectsArray removeObject:category];
                                     break;
                                 }
                             }
                         }
                         if (success) {
                             success(objectsArray);
                         }
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);
                     }];
}
////_______________________

- (void) getCarOtherCategoryWithPageOnSuccess:(void(^)(NSArray* thisData)) success
                                       onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

    [self.sessionManager GET:@"pages/"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSArray *dictsArray = [responseObject allObjects];
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary* dic in dictsArray) {
                             Category *category = [[Category alloc] initWithServerResponse:dic];
                             [objectsArray addObject:category];
                         }

                         if (success) {
                             success(objectsArray);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);

                     }];
    
    
}


- (void) getCarWithoutDriverDetailOnSuccess:(void(^)(NSArray* thisData)) success
                                     onFail:(void(^)(NSError* error, NSInteger statusCode)) failure
                                        withCategoryID: (NSNumber*) categoryID {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:categoryID, @"category", nil];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

    
    [self.sessionManager GET:@"cars/"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         //NSLog(@"responseObject cars %@", responseObject);
                         NSArray *dictsArray = [responseObject objectForKey:@"results"];
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary* dic in dictsArray) {
                             Car *car = [[Car alloc] initWithServerResponse:dic];

                             [objectsArray addObject:car];
                             
                         }
                         if (success) {
                             success(objectsArray);
                         }
                         
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);
                     }];
}

- (void) getCarWithDriverDetailOnSuccess:(void(^)(NSArray* thisData)) success
                                     onFail:(void(^)(NSError* error, NSInteger statusCode)) failure
                             withCategoryID: (NSNumber*) categoryID {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:categoryID, @"category", nil];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [self.sessionManager GET:@"hourly-cars/"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         //NSLog(@"responseObject cars %@", responseObject);
                         NSArray *dictsArray = [responseObject objectForKey:@"results"];
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary* dic in dictsArray) {
                             CarWithDriver *car = [[CarWithDriver alloc] initWithServerResponse:dic];
                             
                             [objectsArray addObject:car];
                             
                         }
                         if (success) {
                             success(objectsArray);
                         }
                         
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);
                     }];
}


- (void) getCarWithDriverDetailWithTransmissionOnSuccess:(void(^)(NSArray* thisData)) success
                                                   onFail:(void(^)(NSError* error, NSInteger statusCode)) failure
                                           withCategoryID: (NSNumber*) categoryID {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:categoryID, @"transmission", nil];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

    
    [self.sessionManager GET:@"cars/"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         NSArray *dictsArray = [responseObject objectForKey:@"results"];
                         
                         for (NSDictionary* dic in dictsArray) {
                             Car *car = [[Car alloc] initWithServerResponse:dic];
                             [objectsArray addObject:car];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);
                     }];

}
- (void) getPlacesOnSuccess:(void(^)(NSArray* thisData)) success
                     onFail:(void(^)(NSError* error, NSInteger statusCode)) failure{
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

    
    [self.sessionManager GET:@"services/"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSArray *dictsArray = [responseObject allObjects];
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         for (NSDictionary* dic in dictsArray) {
                             Place *place = [[Place alloc] initWithServerResponse:dic];
                             [objectsArray addObject:place];
                         }
                         if (success) {
                             success(objectsArray);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);
                     }]; }
- (void) checkCarWithCarId: (NSNumber*) carId
              withDateFrom: (NSString*) dateFrom
                withDateTo: (NSString*) dateTo
                 OnSuccess:(void(^)(NSArray* thisData)) success
                    onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            carId,      @"car",
                            dateFrom,   @"date_from",
                            dateTo,     @"date_to" , nil];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

    
    [self.sessionManager POST:@"cars/check/"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSArray *dictsArray = [responseObject allObjects];

                          if (success) {
                              success(dictsArray);
                              
                              NSLog(@"____________  car clear responseObject %@", responseObject);
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           //NSLog(@"Error: %@", error);
                          if (failure) {
                              failure(error, 7);
                              NSLog(@"Resualt _________chack error %@", error);

                          }
                      }];
}

- (void) getCarOptionsOnSuccess:(void(^)(NSArray* thisData)) success
                         onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

    
    [self.sessionManager GET:@"options/"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSArray *dictsArray = [responseObject allObjects];
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary* dic in dictsArray) {
                             Option *option = [[Option alloc] initWithServerResponse:dic];
                             [objectsArray addObject:option];
                         }
                         if (success) {
                             success(objectsArray);
                         }

                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);
                     }];
}


- (void) registrationGetCaptchaOnSuccess:(void (^)(NSString *))success
                                  onFail:(void (^)(NSError *, NSInteger))failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

    
    [self.sessionManager GET:@"captcha/"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSString *key = [responseObject objectForKey:@"key"];
                         NSLog(@"capcha key %@", responseObject);
                         if (success) {
                             success(key);
                         }

                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);

                     }];
}

- (void) registrationGetCaptchaImgWithKey:(NSString *)key
                                OnSuccess:(void (^)(id))success
                                   onFail:(void (^)(NSError *, NSInteger))failure {
    
    AFImageResponseSerializer *imgSerializer = [[AFImageResponseSerializer alloc] init];
    self.sessionManager.responseSerializer = imgSerializer;
    
    [self.sessionManager GET:[NSString stringWithFormat:@"captcha/%@/", key]
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         UIImage *img = responseObject;
                         
                         if (success) {
                             success(img);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", [NSString stringWithFormat:@"%@", error]);
                     }];
    
}

- (void) registrationWithPersonData: (Person*) person
                             andKey: (NSString*) key
                    PasswordFromImg:(NSString*) password
                          OnSuccess:(void(^)(NSString* token, id user )) success
                             onFail:(void(^)(NSError* error, NSInteger statusCode, NSArray* dataArray)) failure
{
    //self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                                     @"text/json", @"text/javascript",@"text/html", nil];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%@", person.phoneNumber], @"phone",//
                            person.Password,
                            @"password",
                            key,
                            @"captcha_key",
                            password,                                                                    @"captcha_value",
                            person.name,
                            @"first_name",
                            person.surname,
                            @"last_name",
                            person.middleName,
                            @"last_name",
                            person.email,
                            @"email",
                            [NSString stringWithFormat:@"%@",[df stringFromDate:person.dateOfBirth]],
                            @"date_of_birth",
                            person.passportSeries,
                            @"passport_series",
                            person.passportNumber,
                            @"passport_number",
                            [NSString stringWithFormat:@"%@",[df stringFromDate:person.dateOfPassport]],
                            @"passport_issue_date",
                            person.driverLicense,
                            @"license_series",
                            person.driverLicenseNumber,
                            @"license_number",
                            [NSString stringWithFormat:@"%@",
                             [df stringFromDate:person.drivelLicenseDate]],@"license_issue_date", nil];
    [self.sessionManager POST:@"register/"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSLog(@"register rspons______________%@", responseObject);
                          User *user = [[User alloc] initWithServerResponse:
                                        [responseObject objectForKey:@"user"]];
                          NSString *tokenString = [responseObject objectForKey:@"token"];
                          
                          if (success) {
                              success (tokenString, user);
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"error text field *** %@", task.response);
                          NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo
                                                     [AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                          encoding:NSUTF8StringEncoding];
                          NSLog(@"Error is %@",ErrorResponse);
                          // NSArray *errorArray = [[NSArray alloc] initWithObjects:ErrorResponse, nil];
                          NSError* JSONerror;
                          if (error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]) {
                              NSDictionary *dJSON = [NSJSONSerialization JSONObjectWithData:(NSData *)error.
                                                     userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                                    options:
                                                     NSJSONReadingAllowFragments error:&JSONerror];
                              NSLog(@"errorInfo*** %@", dJSON);
                              NSLog(@"password %@", [dJSON objectForKey:@"password"]);
                              NSArray *dictsArray = [dJSON allValues];
                              NSLog(@"errorArray %@", dictsArray);
                              if (failure) {
                                  failure(error, 1, dictsArray);
                              }
                          } else {
                              NSLog(@"Error JSONerror %@",ErrorResponse);
                          }
                      }];
}

- (void) logInWithLogin:(NSString *)login
            andPassword:(NSString *)password
              OnSuccess:(void (^)(NSString *, id))success
                 onFail:(void (^)(NSError *, NSInteger))failure {
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            login,    @"phone",
                            password, @"password", nil];
    
    [self.sessionManager POST:@"auth/obtain-jwt-token/"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSLog(@"responseObject %@", responseObject);
                          
                          User *user = [[User alloc] initWithServerResponse:[responseObject objectForKey:@"user"]];
                          NSString *tokenString = [responseObject objectForKey:@"token"];
                          if (success) {
                              success (tokenString, user);
                          }

                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"Error LogIn %@", error);
                          if (failure) {
                              failure (error, 7);
                          }
                      }];
}

- (void) orderCarWithDriver: (NSNumber*) carId
                  userName : (NSString*) name
            userPhoneNumber: (NSString*) phone
                  userEmail: (NSString*) email
           orderDescription: (NSString*) description
                     andKey: (NSString*) key
            passwordFromImg: (NSString*) password
                  OnSuccess: (void(^)()) success
                     onFail: (void(^)(NSError* error, NSString* errorMessage)) failure
{

    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%@", carId], @"car",
                            description, @"description",
                            name, @"name",
                            phone, @"phone",
                            email, @"email",
                            key, @"captcha_key",
                            password, @"captcha_value", nil];
    
    
    [self.sessionManager POST:@"hourly-orders/"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          if(success)
                              success();
                          
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          NSLog(@"error text field *** %@", task.response);
                          NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                          NSLog(@"Error is %@",ErrorResponse);
                          
                          NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
                          NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                                       options:kNilOptions
                                                                                         error:&error];
                          NSString *errorMessage = [[[jsonResponse allValues] objectAtIndex:0] objectAtIndex:0];
                          if(failure)
                              failure(error, errorMessage);

                      }];
    
    
    
    
}


@end
