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
    
    self.title = @"Список заказов";
    
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
    cell.carLabel.text = [NSString stringWithFormat:@"%@ %@", order.car.itemFullName, order.car.regNumber];
    NSString *daysText = [NSString stringWithFormat:@"%@", order.days];
    cell.daysLabel.text = [NSString stringWithFormat:@"%@ %@", order.days, [daysText hasSuffix:@"1"] ? @"сутки" : @"суток"];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%@ рублей", order.totalPrice];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yy"];
    NSString *fromDate = [dateFormatter stringFromDate:order.dateOfRentalStart];
    NSString *toDate = [dateFormatter stringFromDate:order.dateOfRentalEnd];
    cell.dateLabel.text = [NSString stringWithFormat:@"с %@ по %@", fromDate, toDate];
    
    return [cell addCollectionViewCellProperty:cell];
    
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width - 16, 145);
}

-(void) manageLabelWithStatus: (NSString *) status
                  statusLabel: (UILabel *) label
{
    if([status isEqualToString:@"created"])
    {
        label.text = @"Новый";
        label.textColor = [UIColor blackColor];
    }else if([status isEqualToString:@"cancel"])
    {
        label.text = @"Отмена";
        label.textColor = [UIColor redColor];
    }
    else
    {
        label.text = @"Ошыбка";
        label.textColor = [UIColor redColor];
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
