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

- (void) getCarWithoutDriverDetailWithTransmissionOnSuccess:(void(^)(NSArray* thisData)) success
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
                            carId, @"car",
                            dateFrom, @"date_from",
                            dateTo, @"date_to" , nil];
    [self.sessionManager POST:@"cars/check/"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {                           NSArray *dictsArray = [responseObject allObjects];
                          if (success) {
                              success(dictsArray);
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         //NSLog(@"Error: %@", error);
         if (failure) {
             failure(error, 7);
             NSLog(@"hgfhjjgkjhkhjkhkhjkkhjhjk");
         }
     }]; } - (void) getCarOptionsOnSuccess:(void(^)(NSArray* thisData)) success
                                    onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
         [self.sessionManager GET:@"options/"
                       parameters:nil
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {                          NSArray *dictsArray = [responseObject allObjects];
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
- (void) getCarWithDriverDetailOnSuccess:(void(^)(NSArray* thisData)) success
                                  onFail:(void(^)(NSError* error, NSInteger statusCode)) failure
                          withCategoryID: (NSNumber*) categoryID {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:categoryID, @"category", nil];
    [self.sessionManager GET:@"hourly-cars/"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
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
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"Error: %@", error);
     }];
}

@end
