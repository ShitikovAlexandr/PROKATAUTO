//
//  OrdersListController.m
//  ProkatAuto31
//
//  Created by Ivan Bielko on 27.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "OrdersListController.h"

@interface OrdersListController ()
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation OrdersListController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    self.dataArray = [NSMutableArray array];
    
    //[self getCarInfoFromAPI];
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
    
//    NSString *const identifier = @"CarWithDriverCell";
//    
//    CarWithDriverCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    
//    CarWithDriver *car = [self.dataArray objectAtIndex:indexPath.row];
//    
//    NSURL *url = [NSURL URLWithString:car.imageURL];
//    [cell.carImageView setImageWithURL:url];
//    
//    cell.modelLabel.text = car.name;
//    cell.descriptionLabel.attributedText = [self.descriptionsArray objectAtIndex:indexPath.row];
//    
//    [cell.orderButton addTarget:self action:@selector(OrderCar:event:) forControlEvents:UIControlEventTouchUpInside];
    
//    return [cell addCollectionViewCellProperty:cell];
    return NULL;
    
}

@end
