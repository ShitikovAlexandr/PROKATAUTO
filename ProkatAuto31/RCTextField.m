//
//  RCTextField.m
//  ProkatAuto31
//
//  Created by alex on 19.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "RCTextField.h"

@implementation RCTextField



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
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
    self.lable = [[UILabel alloc] initWithFrame:CGRectMake(0, -2, textField.layer.bounds.size.width, textField.layer.bounds.size.height/4)];
    self.lable.text = textField.placeholder;
    self.lable.textColor = [UIColor redColor];
    self.lable.font = [self.lable.font fontWithSize:1.f];
    [self addSubview:self.lable];

    
    
    
    [UIView transitionWithView:textField
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                        self.lable.font = [self.lable.font fontWithSize:10.f];
                        
                        
                        textField.layer.shadowColor = [UIColor redColor].CGColor;
                        textField.layer.shadowOffset = CGSizeMake(0.f, 2.0f);

                        
                        
    } completion:^(BOOL finished) {
    }];
    
}

- (void)EndEditeffect: (UITextField*) textField {
    [self.lable removeFromSuperview];
    
    textField.layer.shadowColor = [UIColor grayColor].CGColor;
    textField.layer.shadowOffset = CGSizeMake(0.f, 1.0f);
}

@end
