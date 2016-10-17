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
#import "UIImageView+AFNetworking.h"

@interface CarsWithDriverListController ()
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSString *baseAddress;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation CarsWithDriverListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    self.baseAddress = @"http://83.220.170.187";
    self.dataArray = [NSMutableArray array];
    
    Car *car1 = [[Car alloc] init];
    car1.itemFullName = @"Honda";
    car1.itemColor = @"White";
    car1.minimumPrice = @10;

    
    Car *car2 = [[Car alloc] init];
    car2.itemFullName = @"Honda";
    car2.itemColor = @"White";
    car2.minimumPrice = @1000;
    
    [self.dataArray addObject:(car1)];
    [self.dataArray addObject:(car2)];
    
    [self.collectionView reloadData];
    
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
    [cell.carImageView setImageWithURL:url];

    cell.modelLabel.text = car.itemFullName;
    cell.colorLabel.text = car.itemColor;
    
    return [cell addCollectionViewCellProperty:cell];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
//    StepOneWithoutDriverController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StepOneWithoutDriverController"];
//    [self.navigationController pushViewController:vc animated:YES];
    
    
}

@end
