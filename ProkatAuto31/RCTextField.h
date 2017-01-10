//
//  RCTextField.h
//  ProkatAuto31
//
//  Created by alex on 19.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCTextField : UITextField

@property (strong, nonatomic) UILabel *lable;

- (void)starEditeffect: (UITextField*) textField;
- (void)EndEditeffect: (UITextField*) textField;

@end
