//
//  StepOneWithoutDriverController.h
//  ProkatAuto31
//
//  Created by alex on 04.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"

@interface StepOneWithoutDriverController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource,  UITextFieldDelegate, UIPickerViewDelegate>

@property (strong, nonatomic) Car *car;

@end
