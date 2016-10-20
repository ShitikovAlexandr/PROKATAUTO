//
//  RCTextField.m
//  ProkatAuto31
//
//  Created by alex on 19.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "RCTextField.h"

@implementation RCTextField

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        NSLog(@"initWithCoder");
        [self setBorderStyle:UITextBorderStyleNone];
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.f, 1.0f);
        self.layer.shadowRadius = 0;
        self.layer.shadowOpacity = 1;
        self.layer.masksToBounds = NO;
    }
    
    return self;
}

-(void)starEditeffect: (UITextField*) textField {
    
    [UIView transitionWithView:textField duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
textField.layer.shadowColor = [UIColor redColor].CGColor;
    } completion:^(BOOL finished) {
    }];
    //textField.layer.shadowColor = [UIColor redColor].CGColor;
    
}

- (void)EndEditeffect: (UITextField*) textField {
    
    textField.layer.shadowColor = [UIColor grayColor].CGColor;
    
}

@end
