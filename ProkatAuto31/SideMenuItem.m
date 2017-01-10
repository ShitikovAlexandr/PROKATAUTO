//
//  SideMenuItem.m
//  ProkatAuto31
//
//  Created by alex on 28.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "SideMenuItem.h"

@implementation SideMenuItem

- (id) initWithServerResponse: (NSDictionary*) responseObject {
    
    self = [super init];
    
    if (self) {
        self.itemId = [responseObject objectForKey:@"id"];
        self.title = [responseObject objectForKey:@"title"];
        self.pageType = [responseObject objectForKey:@"page_type"];
        
            if ([self.itemId isEqualToNumber:[NSNumber numberWithInt:1]]) {
                self.image = @"ic_content_paste.png";
                
            } else if ([self.itemId isEqualToNumber:[NSNumber numberWithInt:2]]) {
                self.image = @"ic_contacts.png";
            } else if ([self.itemId isEqualToNumber:[NSNumber numberWithInt:3]]) {
                 self.image = @"ic_info_outline.png";
                
            }
        
        
        
    }
    
    return self;
}




@end
