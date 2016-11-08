//
//  OrderDetailController.m
//  ProkatAuto31
//
//  Created by alex on 03.11.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "OrderDetailController.h"
#import "OrderDetailMainCell.h"
#import "OrderDitailOptionsCell.h"
#import "ServerManager.h"
#import "OrderDetail.h"
#import "PaymentController.h"
#import "OrdersListController.h"

@interface OrderDetailController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *optionsArray;
@property (strong, nonatomic) NSMutableArray *placeArray;

@property (strong, nonatomic) NSString *dailyAmount;
@property (strong, nonatomic) NSString *totalAmount;
@property (strong, nonatomic) NSString *amount;

@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;


@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.optionsArray = [NSMutableArray array];
    self.placeArray = [NSMutableArray array];
    
    [self getDetail];
    
    self.title = [NSString stringWithFormat:@"Заказ № %@",self.order.number];

    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"]
                                                                             style:UIBarButtonItemStylePlain target:self
                                                                            action:@selector(myCustomBack)];
    
    [self.payButton addTarget:self action:@selector(payOrder) forControlEvents:UIControlEventTouchDown];
    [self.cancelButton addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchDown];
    
    if (![self.order.status isEqualToString:@"created"]) {
        [self.buttonsView removeFromSuperview];
    }

    
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSString *const identifier = @"OrderDetailMainCell";
        OrderDetailMainCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.carModel.text = self.order.car.itemFullName;
        NSString *daysText = [NSString stringWithFormat:@"%@", self.order.days];
        cell.timeDay.text = [NSString stringWithFormat:@"%@ %@", self.order.days, [daysText hasSuffix:@"1"] ? NSLocalizedString(@"day", nil) : NSLocalizedString(@"days", nil)];
        
        [self manageLabelWithStatus:self.order.status statusLabel:cell.orderStatus];
        [self manageLabelWithPaymentStatus:self.order.paymentStatus statusLabel:cell.statusPay paid:self.order.paid];
        
        cell.mathCountRental.text = [NSString stringWithFormat:NSLocalizedString(@"%ld rubles/day х %@", nil), (long)[self.dailyAmount integerValue], self.order.days];
        cell.mathCountTotal.text = [NSString stringWithFormat:@"%ld", (long)[self.amount integerValue]];
        
        
        NSDateFormatter *dF = [[NSDateFormatter alloc] init];
        [dF setDateFormat:@"dd.MM.yyyy"];
        cell.rentalDatePeriod.text = [NSString stringWithFormat:NSLocalizedString(@"from %@ to %@", nil), [dF stringFromDate:self.order.dateOfRentalStart], [dF stringFromDate:self.order.dateOfRentalEnd]];
        cell.totalPrice.text = [NSString stringWithFormat:NSLocalizedString(@"%d rubles", nil), [self.order.totalPrice integerValue]];
        
        for (Place* place in self.placeArray) {
            if ([place.serviceType isEqualToString:@"1"]) {
                cell.starrtPlace.text = place.name;
                if ([place.price isEqualToString:@"0.00"]) {
                    cell.priceStartPlace.text = NSLocalizedString(@"free", nil);
                } else {
                    cell.priceStartPlace.text = [NSString stringWithFormat:@"%ld",(long)[place.price integerValue]];
                }
            } else {
                cell.endPlace.text = place.name;
                if ([place.price isEqualToString:@"0.00"]) {
                    cell.endPlacePrice.text = NSLocalizedString(@"free", nil);
                } else {
                    cell.endPlacePrice.text = [NSString stringWithFormat:@"%ld",(long)[place.price integerValue]];
                }

            }
            
            
        }

        return cell;
    } else {
        
        OrderDitailOptionsCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"OrderDitailOptionsCell" forIndexPath:indexPath];
        NSLog(@"create OrderDetailMainCell");

        for (int i =0; i< [self.optionsArray count]; i++) {
            
            OrderDetail* opt = [self.optionsArray objectAtIndex:i];
            NSLog(@"opt price %@", opt.price);
            CGRect textNameframe = cell.optionName.frame;
            textNameframe.origin.x = 8.f;
            textNameframe.origin.y = 30+1*25*i;
            UILabel* optionName = [[UILabel alloc] initWithFrame: textNameframe];
            optionName.font = cell.optionName.font;
            optionName.textColor = cell.optionName.textColor;
            optionName.textAlignment = cell.optionName.textAlignment;
            optionName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            if ([opt.amount integerValue] > 1) {
                optionName.text = [NSString stringWithFormat:@"%@ x %ld", opt.name, (long)[opt.amount integerValue]];
            } else {
                optionName.text = opt.name;
            }
            [cell.optionView addSubview:optionName];
            
            CGRect textPriceframe = cell.optionTotalPrice.frame;
            textPriceframe.origin.x = (self.view.frame.size.width - 95.f);
            textPriceframe.origin.y = 30+1*25*i;
            UILabel* optionPrice = [[UILabel alloc] initWithFrame: textPriceframe];
            optionPrice.font = cell.optionTotalPrice.font;
            optionPrice.textColor = cell.optionTotalPrice.textColor;
            optionPrice.textAlignment = cell.optionTotalPrice.textAlignment;
            
            if ([opt.price isEqualToString:@"0.00"]) {
                optionPrice.text = NSLocalizedString(@"free", nil);
            } else {
                optionPrice.text = [NSString stringWithFormat:@"%d",[opt.price integerValue]*[opt.amount integerValue]];
            }
            [cell.optionView addSubview:optionPrice];

        }

        return cell;

    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if ([self.optionsArray count] > 0) {
        return 2;
    } else {
        return 1;
    }
    
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(self.collectionView.frame.size.width - 4, 305.f);

    } else {
        NSLog(@"size second section");
        return CGSizeMake(self.collectionView.frame.size.width - 4, 38 +[self.optionsArray count]*25);

    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) manageLabelWithStatus: (NSString *) status
                   statusLabel: (UILabel *) label {
    
    if([status isEqualToString:@"created"])
    {
        label.text = NSLocalizedString(@"New", nil);
        
        label.textColor = [UIColor grayColor];
        label.layer.borderColor = [UIColor grayColor].CGColor;
    }else if([status isEqualToString:@"rejected"])
    {
        label.text = NSLocalizedString(@"Rejected", nil);
        label.textColor = [UIColor redColor];
        label.layer.borderColor = [UIColor redColor].CGColor;
    }else if([status isEqualToString:@"cancel"])
    {
        label.text = NSLocalizedString(@"Cancel", nil);
        label.textColor = [UIColor redColor];
        label.layer.borderColor = [UIColor redColor].CGColor;
    }else if([status isEqualToString:@"reserve"])
    {
        label.text = NSLocalizedString(@"Reservation", nil);
        
        label.textColor = [UIColor orangeColor];
        label.layer.borderColor = [UIColor orangeColor].CGColor;
        
    }else if([status isEqualToString:@"onwork"])
    {
        label.text = NSLocalizedString(@"Book a car", nil);
        label.backgroundColor = [UIColor greenColor];
        
        label.textColor = [UIColor greenColor];
        label.layer.borderColor = [UIColor greenColor].CGColor;
    }else if([status isEqualToString:@"finished"])
    {
        label.text = NSLocalizedString(@"Archive", nil);
        
        label.textColor = [UIColor blueColor];
        label.layer.borderColor = [UIColor blueColor].CGColor;

    }
    else
    {
        label.text = NSLocalizedString(@"Error", nil);
        
        label.textColor = [UIColor redColor];
        label.layer.borderColor = [UIColor redColor].CGColor;

        
    }
}

- (void) manageLabelWithPaymentStatus: (NSString *) status
                         statusLabel: (UILabel *) label
                                paid: (NSNumber *) paid {
    
    if([status isEqualToString:@"empty"])
    {
        label.text = NSLocalizedString(@"not paid", nil);
        label.textColor = [UIColor redColor];
    }else if([status isEqualToString:@"partial"])
    {
        label.text = [NSString stringWithFormat: NSLocalizedString(@"paid %@", nil), paid];
        label.textColor = [UIColor orangeColor];
    }else if([status isEqualToString:@"full"])
    {
        label.text = NSLocalizedString(@"paid", nil);
        label.textColor = [UIColor greenColor];
    }else if([status isEqualToString:@"none"])
    {
        label.hidden = TRUE;
    }
    else
    {
        label.text = NSLocalizedString(@"Error", nil);
        label.backgroundColor = [UIColor redColor];
    }
}


- (void) myCustomBack {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) payOrder {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *avans =  [defaults valueForKey:@"minimal_payment"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                @"" message:NSLocalizedString(@"For your convenience You can make an advance payment or pay the full order.\nDeposit isn\'t included to the order price, it has to be included before you sign a rental contract.\nIn case of fully advance payment we will give You any unit of additional equipment for free.", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *viewArray = [[[[[[[[[[[[alert view] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews];
    UILabel *alertMessage = viewArray[1];
    alertMessage.textAlignment = NSTextAlignmentLeft;
    
    
    UIAlertAction *partPay = [UIAlertAction actionWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Make a prepay %d rubles", nil), [avans integerValue] ] style:UIAlertActionStyleDestructive
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     
                                                     PaymentController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentController"];
                                                     vc.orderId = [self.order.orderId stringValue];
                                                     vc.fullPrice = @"partial";
                                                     UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileControllerNav"];
                                                     [navVC setViewControllers:@[vc] animated:NO];
                                                     [self presentViewController:navVC animated:YES completion:nil];
                                                     
                                                 }];
    
    UIAlertAction *fullPay = [UIAlertAction actionWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Pay order %d rubles", nil), [self.totalAmount integerValue] ] style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                        PaymentController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentController"];
                                                        vc.orderId = [self.order.orderId stringValue];
                                                        vc.fullPrice = @"full";
                                                        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileControllerNav"];
                                                        [navVC setViewControllers:@[vc] animated:NO];
                                                        [self presentViewController:navVC animated:YES completion:nil];

                                                        
                                                    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Pay later", nil) style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:partPay];
    [alert addAction:fullPay];

    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    

    
}

- (void) deleteOrder {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                @"" message:NSLocalizedString(@"Do you want to cancel the order?", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                       NSString *token =  [defaults valueForKey:@"tokenString"];

                                                       [[ServerManager sharedManager] deleteOrdrWithPK:[self.order.orderId stringValue]
                                                                                         andAccesToken:token
                                                                                             OnSuccess:^(NSString *responce) {
                                                                                                 OrdersListController *ordersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersListController"];
                                                                                                 UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersNavigationController"];
                                                                                                 [navVC setViewControllers:@[ordersVC] animated:NO];
                                                                                                 [self presentViewController:navVC animated:YES completion:nil];
                                                                                             }
                                                                                                onFail:^(NSError *error) {
                                                                                                    OrdersListController *ordersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersListController"];
                                                                                                    UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersNavigationController"];
                                                                                                    [navVC setViewControllers:@[ordersVC] animated:NO];
                                                                                                    [self presentViewController:navVC animated:YES completion:nil];

                                                                                                }];

                                                   
                                                   }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel
                    
                                                   handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancel];
    [alert addAction:delete];
    [self presentViewController:alert animated:YES completion:nil];

    
    
    
    
}

#pragma mark - API

- (void) getDetail {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults valueForKey:@"tokenString"];
    
    [[ServerManager sharedManager] orderDitailOptionsWithToken:token
                                                    andOrderId:self.order.orderId
                                                     OnSuccess:^(NSArray *optionArray, NSArray *placeArray, NSString *dailyAmount, NSString *totalAmount, NSString *amount) {
                                                         
                                                         self.dailyAmount = dailyAmount;
                                                         self.totalAmount = totalAmount;
                                                         self.amount = amount;
                                                         
                                                         if ([optionArray count]> 0) {
                                                             [self.optionsArray addObjectsFromArray:optionArray];
                                                             NSLog(@"option array count %d", [self.optionsArray count]);
                                                         }
                                                         
                                                         [self.placeArray addObjectsFromArray:placeArray];
                                                         [self.collectionView reloadData];
                                                         
                                                     }
                                                        onFail:^(NSArray *errorArray) {
                                                            
                                                        }];
    
}


@end
