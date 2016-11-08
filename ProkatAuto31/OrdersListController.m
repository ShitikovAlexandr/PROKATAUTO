//
//  OrdersListController.m
//  ProkatAuto31
//
//  Created by Ivan Bielko on 27.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "OrdersListController.h"
#import "ServerManager.h"
#import "OrderCell.h"
#import "Order.h"
#import "SWRevealViewController.h"
#import "OrderDetailController.h"

@interface OrdersListController ()
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation OrdersListController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    self.dataArray = [NSMutableArray array];
    
    [self getOrdersFromAPI];
}

-(void) myCustomBack {
    // Some anything you need to do before leaving
    SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *const identifier = @"OrderCell";
    
    OrderCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    Order *order = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.numberLabel.text = [NSString stringWithFormat:@"№%@", order.number];
    [self manageLabelWithStatus:order.status statusLabel:cell.statusLabel];
    [self manageLabelWithPaymentStatus:order.paymentStatus statusLabel:cell.paymentStatus paid:order.paid];
    cell.carLabel.text = [NSString stringWithFormat:@"%@ %@", order.car.itemFullName, order.car.regNumber];
    NSString *daysText = [NSString stringWithFormat:@"%@", order.days];
    cell.daysLabel.text = [NSString stringWithFormat:@"%@ %@", order.days, [daysText hasSuffix:@"1"] ? @"сутки" : @"суток"];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%@ рублей", order.totalPrice];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yy"];
    NSString *fromDate = [dateFormatter stringFromDate:order.dateOfRentalStart];
    NSString *toDate = [dateFormatter stringFromDate:order.dateOfRentalEnd];
    cell.dateLabel.text = [NSString stringWithFormat:@"с %@ по %@", fromDate, toDate];
    
    if([order.penaltyStatus isEqualToString:@"none"])
        cell.penaltyLabel.hidden = TRUE;
    else
        cell.penaltyLabel.text = [NSString stringWithFormat:@"штраф %@ рублей", order.penalty];
    [self manageLabelWithPaymentStatus:order.penaltyStatus statusLabel:cell.penaltyStatusLabel paid:order.penaltyPaid];
    
    return [cell addCollectionViewCellProperty:cell];
    
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Order *order = [self.dataArray objectAtIndex:indexPath.row];
    if([order.penaltyStatus isEqualToString:@"none"])
        return CGSizeMake(self.collectionView.frame.size.width - 16, 145);
    return CGSizeMake(self.collectionView.frame.size.width - 16, 160);
}

- (void) manageLabelWithStatus: (NSString *) status
                  statusLabel: (UILabel *) label
{
    if([status isEqualToString:@"created"])
    {
        label.text = @"Новый";
        label.backgroundColor = [UIColor grayColor];
    }else if([status isEqualToString:@"rejected"])
    {
        label.text = @"Отказ";
        label.backgroundColor = [UIColor redColor];
    }else if([status isEqualToString:@"cancel"])
    {
        label.text = @"Отмена";
        label.backgroundColor = [UIColor redColor];
    }else if([status isEqualToString:@"reserve"])
    {
        label.text = @"Бронь";
        label.backgroundColor = [UIColor orangeColor];
    }else if([status isEqualToString:@"onwork"])
    {
        label.text = @"Аренда";
        label.backgroundColor = [UIColor greenColor];
    }else if([status isEqualToString:@"finished"])
    {
        label.text = @"Архив";
        label.backgroundColor = [UIColor blueColor];
    }
    else
    {
        label.text = @"Ошыбка";
        label.backgroundColor = [UIColor redColor];
    }
}

-(void) manageLabelWithPaymentStatus: (NSString *) status
                         statusLabel: (UILabel *) label
                                paid: (NSNumber *) paid
{
    if([status isEqualToString:@"empty"])
    {
        label.text = @"не оплачено";
        label.textColor = [UIColor redColor];
    }else if([status isEqualToString:@"partial"])
    {
        label.text = [NSString stringWithFormat: @"оплачено %@", paid];
        label.textColor = [UIColor orangeColor];
    }else if([status isEqualToString:@"full"])
    {
        label.text = @"оплачено";
        label.textColor = [UIColor greenColor];
    }else if([status isEqualToString:@"none"])
    {
        label.hidden = TRUE;
    }
    else
    {
        label.text = @"ошыбка";
        label.backgroundColor = [UIColor redColor];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Order *order = [self.dataArray objectAtIndex:indexPath.row];
    
    OrderDetailController *orderDitail = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailController"];
    orderDitail.order = order;
    [self.navigationController pushViewController:orderDitail animated:YES];
    
    
}


#pragma mark - API

- (void) getOrdersFromAPI {
    
    [[ServerManager sharedManager] ordersHistory:^(NSArray *thisData) {
        [self.dataArray addObjectsFromArray:thisData];
        [self.collectionView reloadData];
    } onFail:^(NSError *error) {
        NSLog(@"Error = %@", error);
    }];
    
}
@end
