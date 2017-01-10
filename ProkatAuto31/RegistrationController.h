//
//  RegistrationController.h
//  ProkatAuto31
//
//  Created by alex on 18.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegistrationController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) id nextController;

@end
