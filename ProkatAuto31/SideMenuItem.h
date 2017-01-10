//
//  SideMenuItem.h
//  ProkatAuto31
//
//  Created by alex on 28.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SideMenuItem : NSObject

@property (strong, nonatomic) NSNumber *itemId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *pageType;
@property (strong, nonatomic) NSString *image;

- (id) initWithServerResponse: (NSDictionary*) responseObject;


@end
