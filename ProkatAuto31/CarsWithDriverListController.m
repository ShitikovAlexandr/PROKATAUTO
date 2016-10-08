//
//  CarsWithDriverListController.m
//  ProkatAuto31
//
//  Created by Ivan Bielko on 08.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "CarsWithDriverListController.h"
#import "CarWithDriverCell.h"
#import "Car.h"

@interface CarsWithDriverListController ()
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSString *baseAddress;
@end

@implementation CarsWithDriverListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    self.baseAddress = @"http://83.220.170.187";
    self.dataArray = [NSMutableArray array];
    
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
    
    NSString *const identifier = @"CarWithDriverCell";
    
    CarWithDriverCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    Car *car = [self.dataArray objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseAddress, car.imageURL]];
//    [cell.carImageView setImageWithURL:url];
//    
//    cell.carName.text = [NSString stringWithFormat:@"%@ %@", car.itemFullName, car.itemTransmissionName];
//    cell.transmission.text = car.itemTransmissionName;
//    cell.engine.text = [NSString stringWithFormat:@"%@ л", car.itemEngine];
//    cell.power.text =  [NSString stringWithFormat:@"%@ л.с.",car.itemPower];
//    cell.fuel.text = car.itemFuelName;
//    
//    cell.deposit.text = [NSString stringWithFormat:@"%@ руб", car.deposit];
//    cell.priceFrom.text = [NSString stringWithFormat:@"от %@ руб", car.minimumPrice];
//    cell.priceRange1.text = [NSString stringWithFormat:@"%@ руб", car.priceRange1];
//    cell.priceRange2.text = [NSString stringWithFormat:@"%@ руб", car.priceRange2];
//    cell.priceRange3.text = [NSString stringWithFormat:@"%@ руб", car.priceRange3];
    
//    return [cell addCollectionViewCellProperty:cell];
    return NULL;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    StepOneWithoutDriverController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StepOneWithoutDriverController"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.expandedCellIndex == indexPath.item) {
        
        return CGSizeMake(self.collectionView.frame.size.width - 16, 490);
        
    }
    return CGSizeMake(self.collectionView.frame.size.width - 16, 270);
}

@end
