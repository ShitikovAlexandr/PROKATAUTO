//
//  RCPickerView.m
//  ProkatAuto31
//
//  Created by alex on 11.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "RCPickerView.h"

@interface RCPickerView ()
@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) UITextField *textField;
@end

@implementation RCPickerView

- (instancetype) initWithShadowAndTextField: (UITextField*) textField {
    self = [super init];
    
    if (self) {
        self.textField = textField;
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.f, -3.0f);
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 3;
        self.layer.masksToBounds = NO;
       
        
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [self.toolBar setTintColor:[UIColor grayColor]];
        [self.toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        //[self addSubview:toolBar];
        [textField setInputAccessoryView:self.toolBar];
        [textField setInputView:self];
        //self.textField.layer.shadowColor =[UIColor redColor].CGColor;
        
        
    }
    
    return self;
    
}

- (void) doneButtonPressed:(id)sender  {
    
    //self.textField.layer.shadowColor =[UIColor grayColor].CGColor;
    [self.textField resignFirstResponder];
}






@end
