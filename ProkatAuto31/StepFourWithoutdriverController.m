//
//  StepFourWithoutdriverController.m
//  ProkatAuto31
//
//  Created by alex on 26.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "StepFourWithoutdriverController.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "Option.h"
#import "PaymentController.h"
#import "OrdersListController.h"
#import "OrderDetailController.h"
#import "SWRevealViewController.h"

@interface StepFourWithoutdriverController ()
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *carFullName;
@property (weak, nonatomic) IBOutlet UILabel *rentalPeriodDays;
@property (weak, nonatomic) IBOutlet UILabel *startRental;
@property (weak, nonatomic) IBOutlet UILabel *endRental;
@property (weak, nonatomic) IBOutlet UILabel *startPlace;
@property (weak, nonatomic) IBOutlet UILabel *endPlace;
@property (weak, nonatomic) IBOutlet UILabel *calculateRental;
@property (weak, nonatomic) IBOutlet UILabel *deposite;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *optionPrice;
@property (weak, nonatomic) IBOutlet UIView *priceVew;
@property (weak, nonatomic) IBOutlet UILabel *priceForDaysOnly;
@property (weak, nonatomic) IBOutlet UILabel *optionPriceText;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) NSString *baseAddress;
@property (assign, nonatomic) NSInteger optionPriceInt;
@property (strong, nonatomic) NSNumberFormatter* numberFormatter;



@end

@implementation StepFourWithoutdriverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self styleRCButton:self.doneButton];
    
    self.baseAddress = @"http://prokatauto31.ru";
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [self.numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];

    
    [self.doneButton addTarget:self action:@selector(sendNewOrder) forControlEvents:UIControlEventTouchDown];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseAddress, self.order.car.imageURL]];
    [self.carImageView setImageWithURL:url];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_phone.png"] style:UIBarButtonItemStylePlain target:self action:@selector(CallAction)];
    
    
    self.carFullName.text = [NSString stringWithFormat:@"%@ %@", self.order.car.itemFullName, self.order.car.itemTransmissionName];
    NSString *daysText = [NSString stringWithFormat:@"%ld", (long)self.order.rentalPeriodDays];

    self.rentalPeriodDays.text = [NSString stringWithFormat:@"%ld %@", (long)self.order.rentalPeriodDays, [daysText hasSuffix:@"1"] ? NSLocalizedString(@"day", nil) : NSLocalizedString(@"days", nil)];
    NSDateFormatter *screenDate = [[NSDateFormatter alloc] init];
    [screenDate setDateFormat:@"dd.MM.yyyy"];
    NSDateFormatter *screenTime = [[NSDateFormatter alloc] init];
    [screenTime setDateFormat:@"HH:mm"];
    //self.order.rentalPeriodDays+=1;//

    self.startRental.text = [NSString stringWithFormat:@"%@ %@", [screenDate stringFromDate:self.order.dateOfRentalStart], [screenTime stringFromDate:self.order.timeOfRentalStart]];
    self.endRental.text = [NSString stringWithFormat:@"%@ %@", [screenDate stringFromDate:self.order.dateOfRentalEnd], [screenTime stringFromDate:self.order.timeOfRentalEnd]];
    self.startPlace.text = [NSString stringWithFormat:@"%@", self.order.startPlace.locationName];
    self.endPlace.text = [NSString stringWithFormat:@"%@", self.order.endPlace.locationName];
    self.priceForDaysOnly.text =  [NSString stringWithFormat:@"%@",[self.numberFormatter stringFromNumber:self.order.totalPrice]];   //[self.order.totalPrice stringValue];
    NSNumber *range;
    if (self.order.rentalPeriodDays  < 4) {
        range =  self.order.car.priceRange1;
    } else if (self.order.rentalPeriodDays >= 4 && self.order.rentalPeriodDays < 7) {
        range =  self.order.car.priceRange2;
    } else {
        range =  self.order.car.priceRange3;
        
    }
    self.calculateRental.text = [NSString stringWithFormat:@"%@ x %ld %@", [self.numberFormatter stringFromNumber:range], (long)self.order.rentalPeriodDays ,[daysText hasSuffix:@"1"] ? NSLocalizedString(@"day", nil) : NSLocalizedString(@"days", nil)];
    self.deposite.text = [NSString stringWithFormat:@"%@", [self.numberFormatter stringFromNumber:self.order.car.deposit]];//self.order.car.deposit;
    
    
    
    NSInteger optionTotalPrice = 0;
    for (Option *opt in self.order.selectOptionArray) {
        optionTotalPrice = optionTotalPrice + [opt.optionPrice integerValue] * [opt.selectedAmount integerValue];
        
    }
    self.optionPriceInt = optionTotalPrice;
    self.optionPrice.text = [NSString stringWithFormat:@"%ld", (long)optionTotalPrice];
    NSInteger totalOptionPrice = optionTotalPrice + [self.order.totalPrice integerValue] + [self.order.car.deposit integerValue];
    self.totalPrice.text = [NSString stringWithFormat:@"%@", [self.numberFormatter stringFromNumber:[NSNumber numberWithUnsignedInteger:totalOptionPrice]]];
    
    if ([self.optionPrice.text integerValue]<1) {
        CGRect rect = self.priceVew.frame;
        rect.size.height = self.priceVew.frame.size.height - 25.f;
        self.priceVew.frame = rect;
        [self.optionPrice removeFromSuperview];
        [self.optionPriceText removeFromSuperview];
        
    }
}

- (void) CallAction {
    NSLog(@"make call");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://+79036420187"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) sendNewOrder {
    
    NSDateFormatter *screenDate = [[NSDateFormatter alloc] init];
    [screenDate setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *screenTime = [[NSDateFormatter alloc] init];
    [screenTime setDateFormat:@"HH:mm"];
    NSString *datefrom = [NSString stringWithFormat:@"%@T%@", [screenDate stringFromDate:self.order.dateOfRentalStart], [screenTime stringFromDate:self.order.timeOfRentalStart]];
    
    NSString *dateTo = [NSString stringWithFormat:@"%@T%@", [screenDate stringFromDate:self.order.dateOfRentalEnd], [screenTime stringFromDate:self.order.timeOfRentalEnd]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults valueForKey:@"tokenString"];
    NSMutableArray *paramsArray = [NSMutableArray array];
    NSMutableSet *paramsSet = [NSMutableSet set];
    for (Option* opt in self.order.selectOptionArray) {
        NSDictionary *option = [NSDictionary dictionaryWithObjectsAndKeys:
                                opt.optionId, @"option",
                                opt.selectedAmount, @"amount",nil];
        [paramsArray addObject:option];
        
        [paramsSet addObject:option];
        

    }
    NSError *error=nil;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:paramsArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
      
    [[ServerManager sharedManager] publicOrderWithCarId:[NSString stringWithFormat:@"%@", [self.order.car.carID objectAtIndex:0]]
                                               dateFrom:datefrom
                                                 dateTo:dateTo
                                         giveCarService:[self.order.startPlace.placeID stringValue]
                                          returnService:[self.order.endPlace.placeID stringValue]
                                                options:jsonString
                                              withToken:token
                                              OnSuccess:^(NSString *resualtString,NSString *resultId) {
                                                  
                                                  [self payOrder:resualtString];
                                                  
                                              }
                                                 onFail:^(NSString *errorArray, NSString *openedOrders, NSString *detail) {
                                                     if (openedOrders) {
                                                         [self alerExistOrderOrderID:openedOrders];
                                                     } else {
                                                         [self errorActionWithMasegr:errorArray];
                                                     }
                                                 }];
     
    
}

- (void) myCustomBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) payOrder: (NSString*) orderId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *avans =  [defaults valueForKey:@"minimal_payment"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                @"" message:NSLocalizedString(@"For your convenience You can make an advance payment or pay the full order.\nDeposit isn\'t included to the order price, it has to be included before you sign a rental contract.\nIn case of fully advance payment we will give You any unit of additional equipment for free.", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *viewArray = [[[[[[[[[[[[alert view] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews];
    UILabel *alertMessage = viewArray[1];
    alertMessage.textAlignment = NSTextAlignmentLeft;
    
    
    UIAlertAction *partPay = [UIAlertAction actionWithTitle:[NSString stringWithFormat: NSLocalizedString(@"Make a prepay %@ rubles", nil), [self.numberFormatter stringFromNumber:avans]] style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                        PaymentController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentController"];
                                                        vc.orderId = orderId;
                                                        vc.fullPrice = @"partial";
                                                        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileControllerNav"];
                                                        [navVC setViewControllers:@[vc] animated:NO];
                                                        [self presentViewController:navVC animated:YES completion:nil];
                                                        
                                                    }];
    long totlPrice =[self.order.totalPrice intValue] + self.optionPriceInt;
    
    UIAlertAction *fullPay = [UIAlertAction actionWithTitle:[NSString stringWithFormat: NSLocalizedString(@"Pay order %@ rubles", nil),[self.numberFormatter stringFromNumber:[NSNumber numberWithUnsignedInteger:totlPrice]] ] style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                        PaymentController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentController"];
                                                        vc.orderId = orderId;
                                                        vc.fullPrice = @"full";
                                                        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileControllerNav"];
                                                        [navVC setViewControllers:@[vc] animated:NO];
                                                        [self presentViewController:navVC animated:YES completion:nil];
                                                        
                                                        
                                                    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle: NSLocalizedString(@"Pay later", nil) style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:partPay];
    [alert addAction:fullPay];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) styleRCButton: (UIButton*) button {
    button.layer.cornerRadius = 3.f;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor clearColor].CGColor;
    button.layer.masksToBounds = YES;
}

- (void) alerExistOrderOrderID:(NSString*) orderId {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                @"" message:NSLocalizedString(@"The order is already issued to pay you need to go to the order screen", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Pay later", nil) style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction *goToOrders = [UIAlertAction actionWithTitle:NSLocalizedString(@"Go", nil) style:UIAlertActionStyleDefault
                                                                                                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                                                                                                     
                                                                                                                                                    UINavigationController *ordersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersListController"];
                                                                                                                                                    UINavigationController *navVCB = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersNavigationController"];
                                                                                                                                                    navVCB.navigationBar.barStyle = UIBarStyleBlack;
                                                                                                                                                    [navVCB setViewControllers:@[ordersVC] animated:NO];
                                                                                                                                                    OrderDetailController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailController"];
                                                                                                                                                    vc.orderId = orderId;
                                                                                                                                                    vc.backController = navVCB;
                                                                                                                                                    UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersNavigationController"];
                                                                                                                                                    navVC.navigationBar.barStyle = UIBarStyleBlack;
                                                                                                                                                    [navVC setViewControllers:@[vc] animated:NO];
                                                                                                                                                    [self presentViewController:navVC animated:NO completion:nil];

                                                                                                                                                 }];
    
    [alert addAction:cancel];
    [alert addAction:goToOrders];
    [self presentViewController:alert animated:YES completion:nil];

    
}

- (void) errorActionWithMasegr: (NSString*) masege {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                @"" message:masege preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];


}


@end
