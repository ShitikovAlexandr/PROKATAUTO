//
//  Category.m
//  ProkatAuto31
//
//  Created by MacUser on 15.09.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "Category.h"

@implementation Category

- (id) initWithServerResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    
    if (self) {
        self.name =[responseObject objectForKey:@"name"];
        if(self.name == NULL) {
            self.name =[responseObject objectForKey:@"title"];
        }

        self.image = [responseObject objectForKey:@"image"];
        
        self.slug = [responseObject objectForKey:@"slug"];
        
        self.categoryID = [responseObject objectForKey:@"id"];
        self.maimDescription = [responseObject objectForKey:@"content"];
    }
    
    
    
    return self;
}



@end
