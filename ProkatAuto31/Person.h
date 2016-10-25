//
//  Person.h
//  ProkatAuto31
//
//  Created by alex on 20.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (strong, nonatomic) NSString *surname;//
@property (strong, nonatomic) NSString *name;//
@property (strong, nonatomic) NSString *middleName;//
@property (strong, nonatomic) NSString *email;//
@property (strong, nonatomic) NSString *countryCode;//
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSDate *dateOfBirth;//

@property (strong, nonatomic) NSString *passportSeries;//
@property (strong, nonatomic) NSString *passportNumber;//
@property (strong, nonatomic) NSDate *dateOfPassport;//

@property (strong, nonatomic) NSString *driverLicense;//
@property (strong, nonatomic) NSString *driverLicenseNumber;//
@property (strong, nonatomic) NSDate *drivelLicenseDate;//
@property (strong, nonatomic) NSString *Password;




@end
