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
#import "SideMenuItem.h"
#import "Order.h"


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
        //[self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadRevalidatingCacheData];
    }
    return self;
}



#pragma mark - API Methods

- (void) getCarWithoutDriverCategoryOnSuccess:(void(^)(NSArray* thisData)) success
                                       onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];

    
    [self.sessionManager GET:@"thesaurus/"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         NSNumber* minimalPayment = [responseObject objectForKey:@"minimal_payment"];
                         [defaults setValue:minimalPayment forKey:@"minimal_payment"];


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
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];


    
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
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];



    
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
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];


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
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];


    
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
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    
    
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


- (void) getCarWithoutDriverDetailWithTransmissionOnSuccess:(void(^)(NSArray* thisData)) success
                                                     onFail:(void(^)(NSError* error, NSInteger statusCode)) failure
                                             withCategoryID: (NSNumber*) categoryID {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:categoryID, @"transmission", nil];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];


    
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
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];


    
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
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];


    
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
                           NSLog(@"Errorcars/check/ //////////////: %@", error);
                          if (failure) {
                              failure(error, 7);
                              NSLog(@"Resualt _________chack error %@", error);

                          }
                      }];
}

- (void) getCarOptionsOnSuccess:(void(^)(NSArray* thisData)) success
                         onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];


    
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
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];


    
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
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    
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
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    
    NSString *currentPhoneNumber = [NSString stringWithFormat:@"%@%@", [person.countryCode stringByReplacingOccurrencesOfString:@"+" withString:@""], person.phoneNumber];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            currentPhoneNumber, @"phone",
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
    
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    
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

- (void) rememberPasswordWithCapchaKey:(NSString *)key
                        andCapchaValue:(NSString *)value
                              andPhone:(NSString *)phone
                             OnSuccess:(void (^)(NSString *))success
                                onFail:(void (^)(NSError *, NSInteger, NSArray* dataArray))failure {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            phone,  @"phone",
                            key,    @"key",
                            value,  @"captcha_value",nil];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    
    [self.sessionManager POST:@"remember-password/"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSLog(@"responseObject rememberPassword %@", responseObject);
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error ) {
                          
                          NSLog(@"error text field *** %@", task.response);
                          NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                          NSLog(@"Error is %@",ErrorResponse);
                          
                          
                          NSError* JSONerror;
                          if (error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]) {
                              NSDictionary *dJSON = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingAllowFragments error:&JSONerror];
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
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    
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


- (void) sideMenuOnSuccess:(void (^)(NSArray *))success
                    onFail:(void (^)(NSError *))failure {
    
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];


    [self.sessionManager GET:@"side-menu/"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSLog(@"side menu responseObject %@", responseObject);
                         NSArray *dicArray = [responseObject allObjects];
                         NSMutableArray *dataArray = [NSMutableArray array];
                         
                         for(NSDictionary* dic in dicArray) {
                             SideMenuItem *item = [[SideMenuItem alloc] initWithServerResponse:dic];
                             [dataArray addObject:item];
                         }
                         
                         if (success) {
                             success(dataArray);
                         }
                        
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"error side menu %@", error);
                     }];
}

- (void) sideMenuWithPageId:(NSNumber*) pageId OnSuccess:(void(^)(NSString* title, NSString* content)) success
                     onFail:(void(^)(NSError* error)) failure {
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];

    
    
    [self.sessionManager GET:[NSString stringWithFormat:@"side-menu/%@/", pageId]
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSLog(@"responseObject WithPageId: %@ -> %@", pageId, responseObject);
                         NSString *content = [responseObject objectForKey:@"content"];
                         NSString *title = [responseObject objectForKey:@"title"];
                         
                         if (success) {
                             success (content, title);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"error %@", error);
                     }];
}

- (void) ordersHistory:(void (^)(NSArray *))success
                onFail:(void (^)(NSError *))failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenString = [defaults valueForKey:@"tokenString"];
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"JWT %@", tokenString] forHTTPHeaderField:@"Authorization"];
    [self.sessionManager GET:@"orders/"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSArray *dicArray = [responseObject objectForKey:@"results"];
                         NSMutableArray *dataArray = [NSMutableArray array];
                         for(NSDictionary* dic in dicArray) {
                             Order *item = [[Order alloc] initWithServerResponse:dic];
                             [dataArray addObject:item];
                         }
                         if (success) {
                             success(dataArray);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"error orders %@", error);
                     }];
}

- (void) getProfileInfoWithToken:(NSString *)tokenString
                       OnSuccess:(void (^)(NSNumber* days, NSNumber* orderCount, NSNumber* penalties, NSNumber* status))success
                          onFail:(void (^)(NSError *))failure {
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"JWT %@", tokenString] forHTTPHeaderField:@"Authorization"];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [self.sessionManager GET:@"profile/"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSLog(@"data with token %@", responseObject);
                         NSNumber *days = [responseObject objectForKey:@"days"];
                         NSNumber *orderCount = [responseObject objectForKey:@"order_count"];
                         NSNumber *penalties = [responseObject objectForKey:@"penalties"];                          NSNumber *status = [responseObject objectForKey:@"status"];
                         if (success) {
                             success(days, orderCount,penalties,status);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"error with token %@", error);
                         NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                         NSLog(@"Error is %@",ErrorResponse);
                     }];
}

- (void) changePasswordWithToken: (NSString*) tokenString
                     OldPassword: (NSString*) oldPassword
                     newPassword: (NSString*) password
                     RetryPassword: (NSString*) retryPassword
                       OnSuccess:(void(^)(NSString* massage)) success
                          onFail:(void(^)(NSArray* errorArray)) failure {
    
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"JWT %@", tokenString] forHTTPHeaderField:@"Authorization"];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            oldPassword, @"old_password",
                            password, @"new_password",
                            retryPassword, @"retype_new_password", nil];
    
    [self.sessionManager POST:@"change-password/"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSLog(@"responseObject change password %@", responseObject);
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                         NSLog(@"Error changePassword %@",ErrorResponse);
                         
                         NSError* JSONerror;
                          if (error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]) {
                         NSDictionary *dJSON = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingAllowFragments error:&JSONerror];
                         NSArray *dictsArray = [dJSON allValues];
                         NSLog(@"errorArray %@", dictsArray);
                         if (failure) {
                             failure( dictsArray);
                         }
                     } else {
                         NSLog(@"Error пароль сменен упешно %@",ErrorResponse);
                         NSArray *dictsArray = [[NSArray alloc] init];
                         failure( dictsArray);
                     }

                     }];
}

- (void) preparePaymentWithOrderId: (NSString*) orderId
                         AndMethod: (NSString*) payMethod
                         AndtToken: (NSString*) tokenString
                         OnSuccess:(void(^)(NSString* urlString)) success
                            onFail:(void(^)(NSArray* errorArray)) failure {
    
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"JWT %@", tokenString] forHTTPHeaderField:@"Authorization"];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:payMethod, @"method", nil];
    
    [self.sessionManager POST:[NSString stringWithFormat:@"orders/%@/prepare_payment/", orderId]
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSString* payURL = [responseObject objectForKey:@"sberbank_payment_form"];
                          
                          if (success) {
                              success(payURL);
                          }
                          
                          NSLog(@"pay responseObject %@", responseObject);
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                   
                          NSError* JSONerror;
                          if (error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]) {
                              NSDictionary *dJSON = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingAllowFragments error:&JSONerror];
                              NSArray *dictsArray = [dJSON allValues];
                              NSLog(@"errorArray %@", dictsArray);
                              if (failure) {
                                  failure( dictsArray);
                              }
                          }
                          
                          
                          

                      }];
    
    
}



@end
