//
//  StepOneWithoutDriverController.m
//  ProkatAuto31
//
//  Created by alex on 04.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "StepOneWithoutDriverController.h"
#import "StepOneCollectionViewCell.h"

@interface StepOneWithoutDriverController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIAlertController *alert;

@property (strong, nonatomic) StepOneCollectionViewCell *cell;

@end

@implementation StepOneWithoutDriverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width - 16, 700);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
    
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *const identifier = @"StepOneCollectionViewCell";
    
    self.cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    self.cell.supplyCarView.layer.borderColor = [UIColor grayColor].CGColor;
    self.cell.supplyCarView.layer.cornerRadius = 2.f;
    self.cell.supplyCarView.layer.borderWidth =2.f;
    
    self.cell.ReturnCarView.layer.borderColor = [UIColor grayColor].CGColor;
    self.cell.ReturnCarView.layer.cornerRadius = 2.f;
    self.cell.ReturnCarView.layer.borderWidth =2.f;

    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yyyy"];
    self.cell.dateStartTextField.text = [NSString stringWithFormat:@"%@", [df stringFromDate:[NSDate date]]];
    
     NSDateFormatter *tf = [[NSDateFormatter alloc] init];
    
    [tf setDateFormat:@"HH:mm"];
    self.cell.timeStartTextField.text = [NSString stringWithFormat:@"%@", [tf stringFromDate:[NSDate date]]];

    self.cell.timeStartTextField = [self setShadowToTextField:self.cell.timeStartTextField];
    self.cell.dateStartTextField = [self setShadowToTextField:self.cell.dateStartTextField];
    
    self.cell.DateReturnTextField = [self setShadowToTextField:self.cell.DateReturnTextField];
    self.cell.timeReturnTextField = [self setShadowToTextField:self.cell.timeReturnTextField];

    
    
    UIDatePicker *timeDatePicker = [[UIDatePicker alloc] init]; // time darePicker
    timeDatePicker.datePickerMode = UIDatePickerModeTime;
    timeDatePicker.minimumDate = [NSDate date];
    [timeDatePicker setLocale:[NSLocale systemLocale]];
    [timeDatePicker addTarget:self action:@selector(updateTextFieldTime:)
         forControlEvents:UIControlEventValueChanged];
    [self.cell.timeStartTextField setInputView:timeDatePicker];

    
  
    UIDatePicker *datePicker = [[UIDatePicker alloc] init]; // date darePicker
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.minimumDate = [NSDate date];
    [datePicker setLocale:[NSLocale systemLocale]];

    [datePicker addTarget:self action:@selector(updateTextFieldDate:)
         forControlEvents:UIControlEventValueChanged];
    [self.cell.dateStartTextField setInputView:datePicker];
    
    return self.cell;
}

- (NSString *)updateTextFieldDate:(UIDatePicker*) datePicker {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yyyy"];
    self.cell.dateStartTextField.text = [df stringFromDate: datePicker.date];
    
    self.cell.dateStartTextField.layer.shadowColor =[UIColor redColor].CGColor;

    NSLog(@"date picker LOG %@", datePicker.date);
    
    return nil;
    
}

- (NSString *)updateTextFieldTime:(UIDatePicker*) datePicker {
    
    NSLog(@"date picker LOG %@", datePicker.date);
    
    return nil;
    
}

- (UITextField*) setShadowToTextField: (UITextField*) textField {
    
    textField.layer.shadowColor = [UIColor grayColor].CGColor;
    textField.layer.shadowOffset = CGSizeMake(0.f, 1.0f);
    textField.layer.shadowRadius = 0;
    textField.layer.shadowOpacity = 1;
    textField.layer.masksToBounds = NO;
    
    return textField;
    
}




@end
