//
//  User.h
//  ProkatAuto31
//
//  Created by alex on 22.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
// user data
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *dateJoined;
@property (strong, nonatomic) NSString *dateCreated;
@property (strong, nonatomic) NSString *dateModified;

@property (assign, nonatomic) BOOL isActive;
@property (assign, nonatomic) BOOL isActivated;
@property (assign, nonatomic) BOOL isBlacklis;
@property (assign, nonatomic) BOOL isPhoneValidated;
@property (assign, nonatomic) BOOL isPartner;
@property (assign, nonatomic) BOOL blacklistAccess;
@property (assign, nonatomic) BOOL isStaff;

// profile data
@property (strong, nonatomic) NSString *yearOfExp;
@property (strong, nonatomic) NSString *created;
@property (strong, nonatomic) NSString *modified;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *fatherName;
@property (strong, nonatomic) NSString *addPhone;

@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *dateOfBirth;
@property (strong, nonatomic) NSString *cardNumber;
@property (strong, nonatomic) NSString *gender;

@property (strong, nonatomic) NSString *passportSeries;
@property (strong, nonatomic) NSString *passportNumber;
@property (strong, nonatomic) NSString *passportIssueDate;
@property (strong, nonatomic) NSString *passportIssueDepartment;
@property (strong, nonatomic) NSString *passportIssue;

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *faktAddress;
@property (strong, nonatomic) NSString *licenseSeries;
@property (strong, nonatomic) NSString *licenseNumber;
@property (strong, nonatomic) NSString *licenseIssueDate;
@property (strong, nonatomic) NSString *licenseIssueDepartment;
@property (strong, nonatomic) NSString *licenseIssue;


- (id) initWithServerResponse: (NSDictionary*) responseObject;














@end
