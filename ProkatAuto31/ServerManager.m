//
//  ServerManager.m
//  ProkatAuto31
//
//  Created by MacUser on 19.09.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
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
#import "OrderDetail.h"


@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) NSString *language;


@end

@implementation ServerManager

+ (ServerManager*) sharedManager {
    
    
        
        static ServerManager*  manager = nil ;
        manager = [[ServerManager alloc] init];
        
        
        /*
         static dispatch_once_t onceToken;
         dispatch_once(&onceToken, ^{
         manager = [[ServerManager alloc] init];
         });
         */
        
        return manager;
    }
    
    - (instancetype)init
    {
        self = [super init];
        if (self) {
            
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie *cookie in [storage cookies]) {
                [storage deleteCookie:cookie];
            }
            
            NSURL *url = [NSURL URLWithString:@"http://prokatauto31.ru/api/v1/public/"];
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            configuration.URLCache = nil;
            configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
            
            self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:configuration];
            NSString *currentLanguage =  [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
            if([currentLanguage isEqualToString:@"ru"] || [currentLanguage isEqualToString:@"uk"] || [currentLanguage isEqualToString:@"be"])
            {
                self.language = @"ru";
            }else
            {
                self.language = @"en";
            }
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
            
            
        }
        return self;
    }


#pragma mark - API Methods

- (void) getCarWithoutDriverCategoryOnSuccess:(void(^)(NSArray* thisData)) success
                                       onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];

    
    [self.sessionManager GET:@"thesaurus/"
                  parameters:[[NSDictionary alloc] initWithObjectsAndKeys:
                              self.language, @"lang", nil]
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
                         if (error.code == -1009) {
                             [self errorActionWithMasegr];
                         }
                     }];
    
}

- (void) getCarWithDriverCategoryOnSuccess:(void(^)(NSArray* thisData)) success
                                    onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];


    
    [self.sessionManager GET:@"thesaurus/"
                  parameters:[[NSDictionary alloc] initWithObjectsAndKeys:
                              self.language, @"lang", nil]
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
                         if (error.code == -1009) {
                             [self errorActionWithMasegr];
                         };
                     }];

    
}

- (void) getCarOtherCategoryOnSuccess:(void(^)(NSArray* thisData)) success
                               onFail:(void(^)(NSError* error, NSInteger statusCode)) failure  {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];



    
    [self.sessionManager GET:@"thesaurus/"
                  parameters:[[NSDictionary alloc] initWithObjectsAndKeys:
                              self.language, @"lang", nil]
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
                         if (error.code == -1009) {
                             [self errorActionWithMasegr];
                         }                     }];
}
////_______________________

- (void) getCarOtherCategoryWithPageOnSuccess:(void(^)(NSArray* thisData)) success
                                       onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];


    [self.sessionManager GET:@"pages/"
                  parameters:[[NSDictionary alloc] initWithObjectsAndKeys:
                              self.language, @"lang", nil]
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSArray *dictsArray = [responseObject allObjects];
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary* dic in dictsArray) {
                             Category *category = [[Category alloc] initWithServerResponse:dic];
                             category.categoryID = [NSNumber numberWithInt:[category.categoryID intValue]+10]; // added 10 to avoid conflicts with the auto 
                             [objectsArray addObject:category];
                             
                         }

                         if (success) {
                             success(objectsArray);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if (error.code == -1009) {
                             [self errorActionWithMasegr];
                         }
                     }];
    
    
}


- (void) getCarWithoutDriverDetailOnSuccess:(void(^)(NSArray* thisData)) success
                                     onFail:(void(^)(NSError* error, NSInteger statusCode)) failure
                                        withCategoryID: (NSNumber*) categoryID {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:categoryID, @"category",
                            self.language, @"lang", nil];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];


    
    [self.sessionManager GET:@"cars/"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                         if (error.code == -1009) {
                             [self errorActionWithMasegr];
                         }
                     }];
}
//****
- (void) getCarWithoutDriverDetailOnSuccess:(void(^)(NSArray* thisData)) success
                                     onFail:(void(^)(NSError* error, NSInteger statusCode)) failure
                              {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.language, @"lang", nil];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    
    
    [self.sessionManager GET:@"cars/"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                         if (error.code == -1009) {
                             [self errorActionWithMasegr];
                         }
                     }];
}





- (void) getCarWithDriverDetailOnSuccess:(void(^)(NSArray* thisData)) success
                                     onFail:(void(^)(NSError* error, NSInteger statusCode)) failure
                             withCategoryID: (NSNumber*) categoryID {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:categoryID, @"category",
                            self.language, @"lang", nil];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    
    
    [self.sessionManager GET:@"hourly-cars/"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                         if (error.code == -1009) {
                             [self errorActionWithMasegr];
                         }
                     }];
}


- (void) getCarWithoutDriverDetailWithTransmissionOnSuccess:(void(^)(NSArray* thisData)) success
                                                     onFail:(void(^)(NSError* error, NSInteger statusCode)) failure
                                             withCategoryID: (NSNumber*) categoryID {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:categoryID, @"transmission",
                            self.language, @"lang", nil];
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
                         if (error.code == -1009) {
                             [self errorActionWithMasegr];
                         }
                     }];

}
- (void) getPlacesOnSuccess:(void(^)(NSArray* thisData)) success
                     onFail:(void(^)(NSError* error, NSInteger statusCode)) failure{
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];


    
    [self.sessionManager GET:@"services/"
                  parameters:[[NSDictionary alloc] initWithObjectsAndKeys:
                              self.language, @"lang", nil]
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
                     }]; }

- (void) checkCarWithCarId: (NSNumber*) carId
              withDateFrom: (NSString*) dateFrom
                withDateTo: (NSString*) dateTo
                 OnSuccess:(void(^)(NSArray* thisData)) success
                    onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.language, @"lang",
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
                              
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          if (error.code == -1009) {
                              [self errorActionWithMasegr];
                          } else if (failure) {
                              failure(error, 7);
                          }
                          
                      }];
}

- (void) getCarOptionsOnSuccess:(void(^)(NSArray* thisData)) success
                         onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];


    
    [self.sessionManager GET:@"options/"
                  parameters:[[NSDictionary alloc] initWithObjectsAndKeys:
                              self.language, @"lang", nil]
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
                     }];
}


- (void) registrationGetCaptchaOnSuccess:(void (^)(NSString *))success
                                  onFail:(void (^)(NSError *, NSInteger))failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];


    
    [self.sessionManager GET:@"captcha/"
                  parameters:[[NSDictionary alloc] initWithObjectsAndKeys:
                              self.language, @"lang", nil]
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSString *key = [responseObject objectForKey:@"key"];
                         if (success) {
                             success(key);
                         }

                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                     }];
}

- (void) registrationGetCaptchaImgWithKey:(NSString *)key
                                OnSuccess:(void (^)(id))success
                                   onFail:(void (^)(NSError *, NSInteger))failure {
    
    AFImageResponseSerializer *imgSerializer = [[AFImageResponseSerializer alloc] init];
    self.sessionManager.responseSerializer = imgSerializer;
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    
    [self.sessionManager GET:[NSString stringWithFormat:@"captcha/%@/", key]
                  parameters:[[NSDictionary alloc] initWithObjectsAndKeys:
                              self.language, @"lang", nil]
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         UIImage *img = responseObject;
                         
                         if (success) {
                             success(img);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     }];
    
}

- (void) registrationWithPersonData: (Person*) person
                             andKey: (NSString*) key
                    PasswordFromImg:(NSString*) password
                          OnSuccess:(void(^)(NSString* token, id user )) success
                             onFail:(void(^)(NSError* error, NSInteger statusCode, NSArray* dataArray)) failure

{
    
    NSString *currentPhoneNumber = [NSString stringWithFormat:@"%@%@", [person.countryCode stringByReplacingOccurrencesOfString:@"+" withString:@""], person.phoneNumber];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = @"01-01-1900";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSString* tempData = @"noData";
    
    if ([person.passportNumber length] < 1) {
        person.passportNumber = tempData;
    }
    if ([person.passportSeries length] < 1 ) {
        person.passportSeries = tempData;
    }
    if ([[df stringFromDate:person.dateOfPassport] length] < 1) {
        person.dateOfPassport = date;
    }
    if ([person.driverLicense length] < 1) {
        person.driverLicense = tempData;
    }
    if ([person.driverLicenseNumber length] < 1) {
        person.driverLicenseNumber = tempData;
    }
    if ([[df stringFromDate:person.drivelLicenseDate] length] < 1) {
        person.drivelLicenseDate = date;
    }
    
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
    [self.sessionManager POST:[NSString stringWithFormat:@"register/?lang=%@", self.language]//@"register/"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          User *user = [[User alloc] initWithServerResponse:
                                        [responseObject objectForKey:@"user"]];
                          NSString *tokenString = [responseObject objectForKey:@"token"];
                          
                          if (success) {
                              success (tokenString, user);
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                          NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
                          NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data                                                                                        options:kNilOptions error:&error];
                          NSArray *errorArray= [jsonResponse allValues];
                          if (error.code == -1009) {
                              [self errorActionWithMasegr];
                          }
                          
                          else if (failure) {
                              failure (error, error.code, errorArray);
                          }
                          
                      }];
}

- (void) logInWithLogin:(NSString *)login
            andPassword:(NSString *)password
              OnSuccess:(void (^)(NSString *, id))success
                 onFail:(void (^)(NSError *, NSInteger))failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                                     @"text/json", @"text/javascript",@"text/html", nil];

    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];

    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            
                            login,    @"phone",
                            password, @"password", nil];
    
    [self.sessionManager POST:[NSString stringWithFormat:@"auth/obtain-jwt-token/?lang=%@", self.language]//@"auth/obtain-jwt-token/"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          User *user = [[User alloc] initWithServerResponse:[responseObject objectForKey:@"user"]];
                          NSString *tokenString = [responseObject objectForKey:@"token"];
                          
                          if (success) {
                              success (tokenString, user);
                          }

                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
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
    NSString *currentPhoneNumber = [NSString stringWithFormat:@"%@", [phone stringByReplacingOccurrencesOfString:@"+" withString:@""]];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            
                            currentPhoneNumber,  @"phone",
                            key,    @"captcha_key",
                            value,  @"captcha_value",nil];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    
    [self.sessionManager POST:[NSString stringWithFormat:@"remember-password/?lang=%@", self.language]//@"remember-password/"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          if(success) {
                              NSString *done;
                              success(done);
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error ) {
                                               NSError* JSONerror;
                          NSArray *dictsArray;
                          if (error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]) {
                              NSDictionary *dJSON = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingAllowFragments error:&JSONerror];
                              dictsArray = [dJSON allValues];
                              
                          }
                          if (failure) {
                              failure(error, 1, dictsArray);
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
    
    
    [self.sessionManager POST:[NSString stringWithFormat:@"hourly-orders/?lang=%@", self.language]
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          if(success)
                              success();
                          
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                          
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
                  parameters:[[NSDictionary alloc] initWithObjectsAndKeys:
                              self.language, @"lang", nil]
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                         if (error.code == -1009) {
                             [self errorActionWithMasegr];
                         }
                     }];
}

- (void) sideMenuWithPageId:(NSNumber*) pageId OnSuccess:(void(^)(NSString* title, NSString* content)) success
                     onFail:(void(^)(NSError* error)) failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    [self.sessionManager GET:[NSString stringWithFormat:@"side-menu/%@/", pageId]
                  parameters:[[NSDictionary alloc] initWithObjectsAndKeys:
                              self.language, @"lang", nil]
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSString *content = [responseObject objectForKey:@"content"];
                         NSString *title = [responseObject objectForKey:@"title"];
                         
                         if (success) {
                             success (content, title);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     }];
}

- (void) ordersHistory:(void (^)(NSArray *))success
                onFail:(void (^)(NSError *))failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenString = [defaults valueForKey:@"tokenString"];
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"JWT %@", tokenString] forHTTPHeaderField:@"Authorization"];
    [self.sessionManager GET:@"orders/"
                  parameters:[[NSDictionary alloc] initWithObjectsAndKeys:
                              self.language, @"lang", nil]
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
                         if (error.code == -1009) {
                             [self errorActionWithMasegr];
                         }
                     }];
}

- (void) getProfileInfoWithToken:(NSString *)tokenString
                       OnSuccess:(void (^)(NSNumber* days, NSNumber* orderCount, NSNumber* penalties, NSNumber* status))success
                          onFail:(void (^)(NSError *))failure {
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"JWT %@", tokenString] forHTTPHeaderField:@"Authorization"];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [self.sessionManager GET:@"profile/"
                  parameters:[[NSDictionary alloc] initWithObjectsAndKeys:
                              self.language, @"lang", nil]
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSNumber *days = [responseObject objectForKey:@"days"];
                         NSNumber *orderCount = [responseObject objectForKey:@"order_count"];
                         NSNumber *penalties = [responseObject objectForKey:@"penalties"];
                         NSNumber *status = [responseObject objectForKey:@"status"];
                         if (success) {
                             success(days, orderCount,penalties,status);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if (error.code == -1009) {
                             [self errorActionWithMasegr];
                         }
                     
                     }];
}

- (void) changePasswordWithToken: (NSString*) tokenString
                     OldPassword: (NSString*) oldPassword
                     newPassword: (NSString*) password
                     RetryPassword: (NSString*) retryPassword
                       OnSuccess:(void(^)(NSString* massage)) success
                          onFail:(void(^)(NSArray* errorArray, NSError *error)) failure {
    
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"JWT %@", tokenString] forHTTPHeaderField:@"Authorization"];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            
                            oldPassword, @"old_password",
                            password, @"new_password",
                            retryPassword, @"retype_new_password", nil];
    
    [self.sessionManager POST:[NSString stringWithFormat:@"change-password/?lang=%@", self.language]//@"change-password/"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSError* JSONerror;
                         
                         
                           if (error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]) {
                         NSDictionary *dJSON = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingAllowFragments error:&JSONerror];
                         NSArray *dictsArray = [dJSON allValues];
                              
                              
                         if (failure) {
                             failure( dictsArray, error);
                         }
                     } else {
                         NSArray *dictsArray = [[NSArray alloc] init];
                         
                         failure( dictsArray, error);
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
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:payMethod, @"method",
                            self.language, @"lang", nil];
    
    [self.sessionManager POST:[NSString stringWithFormat:@"orders/%@/prepare_payment/", orderId]
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSString* payURL = [responseObject objectForKey:@"sberbank_payment_form"];
                          
                          if (success) {
                              success(payURL);
                          }
                          
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSError* JSONerror;
                          if (error.code == -1009) {
                              [self errorActionWithMasegr];
                          }
                          else if (error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]) {
                              NSDictionary *dJSON = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingAllowFragments error:&JSONerror];
                              NSArray *dictsArray = [dJSON allValues];
                              
                              if (failure) {
                                  failure( dictsArray);
                              }
                          }
                      }];
    
    
}

- (void) orderCarWithDriverWithToken: (NSString*) tokenString
                              carId : (NSNumber*) car
                    orderDescription: (NSString*) description
                           OnSuccess: (void(^)()) success
                              onFail: (void(^)(NSError* error, NSString* errorMessage)) failure
{
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%@", car], @"car",
                            description, @"description", nil];
    
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"JWT %@", tokenString] forHTTPHeaderField:@"Authorization"];
    
    
    [self.sessionManager POST:[NSString stringWithFormat:@"hourly-orders/?lang=%@", self.language]
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          if(success)
                              success();
                          
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                          
                          NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
                          NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                                       options:kNilOptions
                                                                                         error:&error];
                          NSString *errorMessage = [[[jsonResponse allValues] objectAtIndex:0] objectAtIndex:0];
                           if(failure)
                              failure(error, errorMessage);
                      }];
    
    
}

- (void) paymentSuccessWithAccesTocen: (NSString*) token
                               andURL: (NSString*) urlString
                            OnSuccess:(void(^)(NSString* urlString)) success
                               onFail:(void(^)(NSArray* errorArray)) failure {
    
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"JWT %@", token] forHTTPHeaderField:@"Authorization"];

    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    
    [self.sessionManager GET:urlString
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         if (success) {
                             NSString *url;
                             success(url);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSArray *errorArray;
                         if (failure) {
                             failure(errorArray);
                         }
                     }];
    
    
}

- (void) orderDitailOptionsWithToken: (NSString*) tokenString
                          andOrderId: (NSString*) orderId
                           OnSuccess:(void(^)(NSArray *optionArray, NSArray *placeArray, NSString *dailyAmount, NSString *totalAmount, NSString *amount, id order)) success
                              onFail:(void(^)(NSArray* errorArray)) failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"JWT %@", tokenString] forHTTPHeaderField:@"Authorization"];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [self.sessionManager GET:[NSString stringWithFormat:@"orders/%@/", orderId]
                  parameters:[[NSDictionary alloc] initWithObjectsAndKeys:
                              self.language, @"lang", nil]
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         Order *order = [[Order alloc] initWithServerResponse:responseObject];
                         NSString *dailyAmount = [responseObject objectForKey:@"daily_amount"];
                         NSString *totalAmount = [responseObject objectForKey:@"total_amount"];
                         NSString *amount = [responseObject objectForKey:@"amount"];
                         NSArray *dicArray = [responseObject objectForKey:@"equipment"];
                         NSMutableArray *dataArray = [NSMutableArray array];
                         for(NSDictionary* dic in dicArray) {
                             OrderDetail *item = [[OrderDetail alloc] initWithServerResponse:dic];
                             [dataArray addObject:item];
                         }
                         NSArray *dicArrayPlace = [responseObject objectForKey:@"services"];
                         NSMutableArray *dataArrayPlace = [NSMutableArray array];
                         for(NSDictionary* dic in dicArrayPlace) {
                             Place *item = [[Place alloc] initWithServerResponse:dic];
                             [dataArrayPlace addObject:item];
                         }
                         
                         if (success) {
                             success(dataArray, dataArrayPlace,dailyAmount,totalAmount,amount, order);
                         }
      
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if (error.code == -1009) {
                             [self errorActionWithMasegr];
                         }
                        
                     }];
}

- (void) deleteOrdrWithPK:(NSString *)keyPK
            andAccesToken:(NSString *)tokenString
                OnSuccess:(void (^)(NSString *))success
                   onFail:(void (^)(NSError*))failure {
    
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"JWT %@", tokenString] forHTTPHeaderField:@"Authorization"];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    
    
    [self.sessionManager DELETE:[NSString stringWithFormat:@"orders/%@/", keyPK]
                     parameters:[[NSDictionary alloc] initWithObjectsAndKeys:
                                 self.language, @"lang", nil]
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            if (success) {
                                NSString *str;
                                success(str);
                            }
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            if (error.code == -1009) {
                                [self errorActionWithMasegr];
                            }
                            else if (failure) {
                                failure(error);
                            }

                        }];
}

- (void) getTransferCategoryInfo:(void (^)(Category *, NSString*))success
                          onFail:(void (^)(NSError *))failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    [self.sessionManager GET:@"transfer/"
                  parameters:[[NSDictionary alloc] initWithObjectsAndKeys:
                              self.language, @"lang", nil]
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         Category *category = [[Category alloc] initWithServerResponse:responseObject];
                         NSString *contentText;;
                         if (success) {
                             success(category, contentText);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     }];
} - (void) sendTransferOrderWithCaptchaKey: (NSString*) key
                           andCaptchaValue: (NSString*) captcha
                               andUserName: (NSString*) name
                           userPhoneNumber: (NSString*) phone
                                 userEmail: (NSString*) email
                              orderComment: (NSString*) comment
                            pickupLocation: (NSString*) location
                            pickUpDateTime: (NSString*) dateTime
                           passengersCount: (NSString*) passengers
                          destinationPlace: (NSString*) destination
                                   carName: (NSString*) car
                                 OnSuccess: (void(^)()) success
                                    onFail: (void(^)(NSError* error, NSString* errorMessage)) failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            self.language, @"lang",
                            car, @"car",
                            name, @"name",
                            phone, @"phone",
                            email, @"email",
                            location, @"pickup_location",
                            dateTime, @"pickup_datetime",
                            passengers, @"passengers",
                            destination, @"destination",
                            comment, @"comment",
                            key, @"captcha_key",
                            captcha, @"captcha_value", nil];
    [self.sessionManager POST:@"transfer/"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          if(success)
                              success();
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                          NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
                          NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data                                                                                        options:kNilOptions                                                                                          error:&error];
                          NSString *errorMessage = [[[jsonResponse allValues] objectAtIndex:0] objectAtIndex:0];
                          if (error.code == -1009) {
                              [self errorActionWithMasegr];
                          }
                          
                          else if(failure)
                              failure(error, errorMessage);
                      }];
}

- (void) sendTransferOrderWithToken: (NSString*) tokenString
                       orderComment: (NSString*) comment
                     pickupLocation: (NSString*) location
                     pickUpDateTime: (NSString*) dateTime
                    passengersCount: (NSString*) passengers
                   destinationPlace: (NSString*) destination
                            carName: (NSString*) car
                          OnSuccess: (void(^)()) success
                             onFail: (void(^)(NSError* error, NSString* errorMessage)) failure {
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            self.language, @"lang",
                            car, @"car",
                            location, @"pickup_location",
                            dateTime, @"pickup_datetime",
                            passengers, @"passengers",
                            destination, @"destination",
                            comment, @"comment", nil];
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"JWT %@", tokenString] forHTTPHeaderField:@"Authorization"];
    [self.sessionManager POST:@"transfer/"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          if(success)
                              success();
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                          NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
                          NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data                                                                                        options:kNilOptions                                                                                          error:&error];
                          NSString *errorMessage = [[[jsonResponse allValues] objectAtIndex:0] objectAtIndex:0];
                         if(failure) {
                              failure(error, errorMessage);
                          }
                      }];
}

- (void) publicOrderWithCarId: (NSString*) carId
                     dateFrom:(NSString*) dateFrom
                       dateTo: (NSString*) dateTo
               giveCarService: (NSString*) give
                returnService: (NSString*) returnService
                      options:(NSString*) options
                    withToken: (NSString*) tokenString
                    OnSuccess:(void(^)(NSString* resualtString, NSString *resultId)) success
                       onFail:(void(^)(NSString* errorArray, NSString *openedOrders, NSString *detail)) failure {
    
     [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"JWT %@", tokenString] forHTTPHeaderField:@"Authorization"];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            carId, @"car",
                            dateFrom, @"date_from",
                            dateTo, @"date_to",
                            give, @"give_car_service",
                            returnService, @"return_car_service",
                            options, @"options", nil];
    
    [self.sessionManager POST:[NSString stringWithFormat:@"orders/?lang=%@", self.language]  //@"orders/?lang=en"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          NSString *resultId =  [responseObject objectForKey:@"id"];
                          NSString *resultIDstr = resultId;
                          if (success) {
                              success(resultIDstr, resultId);
                          }
                          
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          
                          
                          NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                          NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
                          NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data                                                                                        options:kNilOptions                                                                                          error:&error];
                          NSString *errorMessage;
                          NSString *openedOrders;
                          NSString *detail;
                          if ([jsonResponse objectForKey:@"opened_orders"]) {
                              openedOrders = [[jsonResponse objectForKey:@"opened_orders"]objectAtIndex:0];
                          } else {
                              errorMessage = [[[jsonResponse allValues] objectAtIndex:0] objectAtIndex:0];

                          }
                          
                          if (error.code == -1009) {
                              [self errorActionWithMasegr];
                          }
                          
                          else if (failure) {
                              failure (errorMessage, openedOrders, detail);
                          }
                      }];
}

- (void) validatePhoneWithCode:(NSString *)code
                     withToken:(NSString *)tokrnString
                     OnSuccess:(void (^)(NSString *))success
                        onFail:(void (^)(NSString *))failure {
    
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"JWT %@", tokrnString] forHTTPHeaderField:@"Authorization"];
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:code, @"code", nil];
    
    [self.sessionManager POST:@"auth/validate-phone/"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          if (success) {
                              NSString *done = @"done";
                              success(done);
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                          NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
                          NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data                                                                                        options:kNilOptions error:&error];
                          NSString *errorMasage;
                          if ([[[jsonResponse objectForKey:@"code"] objectAtIndex:0] isKindOfClass:[NSString class]]) {
                              errorMasage = [[jsonResponse objectForKey:@"code"] objectAtIndex:0];
                          }
                          if (error.code == -1009) {
                              [self errorActionWithMasegr];
                          }
                          
                          else if (failure) {
                              failure(errorMasage);
                          }

                      }];
    
    
}

- (void) errorActionWithMasegr {
    NSString* masege = NSLocalizedString(@"Check your internet connection!", nil);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                @"" message:masege preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancel];
    
    UIViewController *rootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [rootVC presentViewController:alert animated:YES completion:nil];
    //[self presentViewController:alert animated:YES completion:nil];
    //[[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];
    
}

- (void) rentPayOnSuccess:(void(^)(NSString* urlString,NSString *title)) success
                   onFail:(void(^)(NSArray* errorArray)) failure {
    
    [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [self.sessionManager GET:@"pages/5/"
                  parameters:[[NSDictionary alloc] initWithObjectsAndKeys:
                              self.language, @"lang", nil]
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSString *content = [responseObject objectForKey:@"content"];
                         NSString *title = [responseObject objectForKey:@"title"];
                         if (success) {
                             success(content,title);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                     }];
    
}

    
    


@end
