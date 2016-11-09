//
//  StepFourWithoutdriverController.m
//  ProkatAuto31
//
//  Created by alex on 26.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "StepFourWithoutdriverController.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "Option.h"
#import "PaymentController.h"
#import "OrdersListController.h"

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


@end

@implementation StepFourWithoutdriverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseAddress = @"http://83.220.170.187";
    
    [self.doneButton addTarget:self action:@selector(sendNewOrder) forControlEvents:UIControlEventTouchDown];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseAddress, self.order.car.imageURL]];
    [self.carImageView setImageWithURL:url];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_phone.png"] style:UIBarButtonItemStylePlain target:self action:@selector(CallAction)];
    
    
    self.carFullName.text = [NSString stringWithFormat:@"%@ %@", self.order.car.itemFullName, self.order.car.itemTransmissionName];
    self.rentalPeriodDays.text = [NSString stringWithFormat:@"%d", self.order.rentalPeriodDays];
    NSDateFormatter *screenDate = [[NSDateFormatter alloc] init];
    [screenDate setDateFormat:@"dd.MM.yyyy"];
    NSDateFormatter *screenTime = [[NSDateFormatter alloc] init];
    [screenTime setDateFormat:@"HH:mm"];
    
    self.startRental.text = [NSString stringWithFormat:@"%@ %@", [screenDate stringFromDate:self.order.dateOfRentalStart], [screenTime stringFromDate:self.order.timeOfRentalStart]];
    self.endRental.text = [NSString stringWithFormat:@"%@ %@", [screenDate stringFromDate:self.order.dateOfRentalEnd], [screenTime stringFromDate:self.order.timeOfRentalEnd]];
    self.startPlace.text = [NSString stringWithFormat:@"%@", self.order.startPlace.locationName];
    self.endPlace.text = [NSString stringWithFormat:@"%@", self.order.endPlace.locationName];
    self.priceForDaysOnly.text = [self.order.totalPrice stringValue];
    
    NSInteger range;
    if (self.order.rentalPeriodDays  < 4) {
        range =  [self.order.car.priceRange1 integerValue];
    } else if (self.order.rentalPeriodDays >= 4 && self.order.rentalPeriodDays < 7) {
        range =  [self.order.car.priceRange2 integerValue];
    } else {
        range =  [self.order.car.priceRange3 integerValue];
        
    }
    NSString *daysText = [NSString stringWithFormat:@"%d", self.order.rentalPeriodDays];
    self.calculateRental.text = [NSString stringWithFormat:@"%d x %d %@", range, self.order.rentalPeriodDays ,[daysText hasSuffix:@"1"] ? NSLocalizedString(@"day", nil) : NSLocalizedString(@"days", nil)];
    self.deposite.text = [NSString stringWithFormat:@"%@", self.order.car.deposit];//self.order.car.deposit;
    
    
    
    NSInteger optionTotalPrice = 0;
    for (Option *opt in self.order.selectOptionArray) {
        optionTotalPrice = optionTotalPrice + [opt.optionPrice integerValue] * [opt.selectedAmount integerValue];
        NSLog(@"optionPrice - %d, %d", [opt.optionPrice integerValue], [opt.selectedAmount integerValue]);
        
    }
    self.optionPriceInt = optionTotalPrice;
    self.optionPrice.text = [NSString stringWithFormat:@"%d", optionTotalPrice];
    self.totalPrice.text = [NSString stringWithFormat:@"%d", optionTotalPrice + [self.order.totalPrice integerValue] + [self.order.car.deposit integerValue]];
    
    if ([self.optionPrice.text integerValue]<1) {
        CGRect rect = self.priceVew.frame;
        rect.size.height = self.priceVew.frame.size.height - 25.f;
        self.priceVew.frame = rect;
        [self.optionPrice removeFromSuperview];
        [self.optionPriceText removeFromSuperview];
        
    }
    
    
    NSLog(@"start %@",self.order.startDateOfRentalString);
    NSLog(@"end %@",self.order.endDateOfRentalString);

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
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    for (Option* opt in self.order.selectOptionArray) {
        NSDictionary *option = [NSDictionary dictionaryWithObjectsAndKeys:
                                opt.optionId, @"option",
                                opt.selectedAmount, @"amount",nil];
        [paramsArray addObject:option];
        [paramsDic setObject:option forKey:@"opt"];

    }
    NSLog(@"options %@", paramsDic);
    
    //[{"option": 3, "amount": 1}]
    
    [[ServerManager sharedManager] publicOrderWithCarId:[NSString stringWithFormat:@"%@", [self.order.car.carID objectAtIndex:0]]
                                               dateFrom:datefrom
                                                 dateTo:dateTo
                                         giveCarService:[self.order.startPlace.placeID stringValue]
                                          returnService:[self.order.endPlace.placeID stringValue]
                                                options:paramsArray
                                              withToken:token
                                              OnSuccess:^(NSString *resualtString) {
                                                  
                                                  [self payOrder:resualtString];
                                                  
                                              }
                                                 onFail:^(NSString *errorArray, NSString *openedOrders, NSString *detail) {
                                                     if (openedOrders) {
                                                         [self alerExistOrder:openedOrders];
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
                                @"" message:@"Для Вашего удобства Вы можете сделать предоплату или оплатить заказ полностью.\nВ сумме заказа не включен залог, его необходимо оплатить перед подписанием договора аренды.  В случае полной предоплаты мы предоставим Вам любую еденицу дополнительного оборудования бесплатно." preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *viewArray = [[[[[[[[[[[[alert view] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews];
    UILabel *alertMessage = viewArray[1];
    alertMessage.textAlignment = NSTextAlignmentLeft;
    
    
    UIAlertAction *partPay = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Сделать предоплату %d руб.", [avans integerValue] ] style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                        PaymentController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentController"];
                                                        vc.orderId = orderId;
                                                        vc.fullPrice = @"partial";
                                                        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileControllerNav"];
                                                        [navVC setViewControllers:@[vc] animated:NO];
                                                        [self presentViewController:navVC animated:YES completion:nil];
                                                        
                                                    }];
    int totlPrice =[self.priceForDaysOnly.text integerValue] + self.optionPriceInt;
    
    UIAlertAction *fullPay = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Оплатить заказ %d руб.",totlPrice ] style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                        PaymentController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentController"];
                                                        vc.orderId = orderId;
                                                        vc.fullPrice = @"full";
                                                        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileControllerNav"];
                                                        [navVC setViewControllers:@[vc] animated:NO];
                                                        [self presentViewController:navVC animated:YES completion:nil];
                                                        
                                                        
                                                    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Оплатить позже" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:partPay];
    [alert addAction:fullPay];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}

- (void) alerExistOrder: (NSString*) masege {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                @"" message:masege preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction *goToOrders = [UIAlertAction actionWithTitle:@"Перейти" style:UIAlertActionStyleDefault
                                                                                                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                                                                                                     OrdersListController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersListController"];
                                                                                                                                                     UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersNavigationController"];
                                                                                                                                                     navVC.navigationBar.barStyle = UIBarStyleBlack;
                                                                                                                                                     [navVC setViewControllers:@[vc] animated:NO];
                                                                                                                                                     [self presentViewController:navVC animated:YES completion:nil];
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
