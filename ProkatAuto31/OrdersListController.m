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
    [self.navigationController popViewControllerAnimated:YES];
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
//    cell.descriptionLabel.attributedText = [self.descriptionsArray objectAtIndex:indexPath.row];
//    
//    [cell.orderButton addTarget:self action:@selector(OrderCar:event:) forControlEvents:UIControlEventTouchUpInside];
    
    return [cell addCollectionViewCellProperty:cell];
    
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
