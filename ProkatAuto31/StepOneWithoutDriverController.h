//
//  StepOneWithoutDriverController.h
//  ProkatAuto31
//
//  Created by alex on 04.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"

@interface StepOneWithoutDriverController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource,  UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) Car *car;

@end
