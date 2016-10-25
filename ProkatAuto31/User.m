//
//  User.m
//  ProkatAuto31
//
//  Created by alex on 22.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "User.h"

@implementation User


- (id) initWithServerResponse: (NSDictionary*) responseObject {
    
    self = [super init];
    
    if (self) {
        //user
        /*
        self.isActive = (BOOL)[responseObject objectForKey:@"is_active"];
        self.isActivated = (BOOL)[responseObject objectForKey:@"is_activated"];
        self.isBlacklis = (BOOL)[responseObject objectForKey:@"is_blacklist"];
        self.isPhoneValidated = (BOOL)[responseObject objectForKey:@"is_phone_validated"];
        self.isPartner = (BOOL)[responseObject objectForKey:@"is_partner"];
        self.blacklistAccess = (BOOL)[responseObject objectForKey:@"blacklist_access"];
        self.isStaff = (BOOL)[responseObject objectForKey:@"is_staff"];
         */

        self.userId = [responseObject objectForKey:@"id"];
        self.phone = [responseObject objectForKey:@"phone"];
        self.dateJoined = [responseObject objectForKey:@"date_joined"];
        self.dateCreated = [responseObject objectForKey:@"created"];
        self.dateJoined = [responseObject objectForKey:@"modified"];
        
        //profile
        self.yearOfExp = [[responseObject objectForKey:@"profile"] objectForKey:@"year_of_exp"];
        self.created = [[responseObject objectForKey:@"profile"] objectForKey:@"created"];
        self.modified = [[responseObject objectForKey:@"profile"] objectForKey:@"modified"];
        self.status = [[responseObject objectForKey:@"profile"] objectForKey:@"status"];
        self.firstName = [[responseObject objectForKey:@"profile"] objectForKey:@"first_name"];
        self.lastName = [[responseObject objectForKey:@"profile"] objectForKey:@"last_name"];
        self.fatherName = [[responseObject objectForKey:@"profile"] objectForKey:@"father_name"];
        self.addPhone = [[responseObject objectForKey:@"profile"] objectForKey:@"add_phone"];
        self.city = [[responseObject objectForKey:@"profile"] objectForKey:@"city"];
        self.email = [[responseObject objectForKey:@"profile"] objectForKey:@"email"];
        self.dateOfBirth = [[responseObject objectForKey:@"profile"] objectForKey:@"date_of_birth"];
        self.cardNumber = [[responseObject objectForKey:@"profile"] objectForKey:@"card_number"];
        
        self.gender = [[responseObject objectForKey:@"profile"] objectForKey:@"gender"];
        self.passportSeries = [[responseObject objectForKey:@"profile"] objectForKey:@"passport_series"];
        self.passportNumber = [[responseObject objectForKey:@"profile"] objectForKey:@"passport_number"];
        self.passportIssueDate = [[responseObject objectForKey:@"profile"] objectForKey:@"passport_issue_date"];
        self.passportIssueDepartment = [[responseObject objectForKey:@"profile"] objectForKey:@"passport_issue_department"];
        self.passportIssue = [[responseObject objectForKey:@"profile"] objectForKey:@"passport_issue"];
        self.address = [[responseObject objectForKey:@"profile"] objectForKey:@"address"];
        
        self.faktAddress = [[responseObject objectForKey:@"profile"] objectForKey:@"fakt_address"];
        self.licenseSeries = [[responseObject objectForKey:@"profile"] objectForKey:@"license_series"];
        self.licenseNumber = [[responseObject objectForKey:@"profile"] objectForKey:@"license_number"];
        self.licenseIssueDate = [[responseObject objectForKey:@"profile"] objectForKey:@"license_issue_date"];
        self.licenseIssueDepartment = [[responseObject objectForKey:@"profile"] objectForKey:@"license_issue_department"];
        self.licenseIssue = [[responseObject objectForKey:@"profile"] objectForKey:@"license_issue"];



        
        
        
        
        
        
        
    }
    
    return self;
}


@end
