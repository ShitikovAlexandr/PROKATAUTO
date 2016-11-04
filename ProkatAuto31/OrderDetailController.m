//
//  OrderDetailController.m
//  ProkatAuto31
//
//  Created by alex on 03.11.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "OrderDetailController.h"

@interface OrderDetailController ()


@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"№%@",self.order.number];
    [self setRCStyleOfView:self.mainInfoView];
    [self setRCStyleOfView:self.rentalCarView];
    [self setRCStyleOfView:self.startPlaceView];
    [self setRCStyleOfView:self.endPlaceView];
    
    self.carModel.text = self.order.car.itemFullName;
    self.timeDay.text = [NSString stringWithFormat:@"%@ суток", self.order.days];
    
    NSDateFormatter *dF = [[NSDateFormatter alloc] init];
    [dF setDateFormat:@"dd.MM.yyyy"];
    self.rentalDatePeriod.text = [NSString stringWithFormat:@"с %@ по %@", [dF stringFromDate:self.order.dateOfRentalStart], [dF stringFromDate:self.order.dateOfRentalEnd]];
    self.totalPrice.text = [NSString stringWithFormat:@"%@ рублей", self.order.totalPrice];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setRCStyleOfView: (UIView*) view {
    view.layer.cornerRadius = 2.f;
    view.layer.borderWidth = 0.5f;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(2.f, 2.0f);
    view.layer.shadowRadius = 2.0f;
    view.layer.shadowOpacity = 2.0f;
    view.layer.masksToBounds = NO;
}

- (void) myCustomBack {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
