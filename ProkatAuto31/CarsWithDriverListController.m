//
//  CarsWithDriverListController.m
//  ProkatAuto31
//
//  Created by Ivan Bielko on 08.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "CarsWithDriverListController.h"
#import "CarWithDriverCell.h"
#import "UIImageView+AFNetworking.h"
#import "ServerManager.h"
#import "CarWithDriver.h"
#import "OrderCarWithDriverController.h"

@interface CarsWithDriverListController ()
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *descriptionsArray;
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
    self.descriptionsArray = [NSMutableArray array];
    
    [self getCarInfoFromAPI];
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
    
    CarWithDriver *car = [self.dataArray objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseAddress, car.imageURL]];
    [cell.carImageView setImageWithURL:url];

    cell.modelLabel.text = car.name;
    cell.descriptionLabel.attributedText = [self.descriptionsArray objectAtIndex:indexPath.row];

    [cell.descriptionLabel sizeToFit];
    
    [cell.orderButton addTarget:self action:@selector(OrderCar:event:) forControlEvents:UIControlEventTouchUpInside];
    
    return [cell addCollectionViewCellProperty:cell];
    
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CarWithDriver *car = [self.dataArray objectAtIndex:indexPath.row];
    
    NSAttributedString *desctiption = [[NSAttributedString alloc] initWithData:[car.carDescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    [self.descriptionsArray addObject:desctiption];
    
    CGRect descriptionRect = [desctiption boundingRectWithSize:CGSizeMake(self.collectionView.frame.size.width - 185, 0)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                        context:nil];
    CGFloat height = descriptionRect.size.height + 70;
    return CGSizeMake(self.collectionView.frame.size.width - 16, height < 150 ? 150 : height);
}

- (IBAction)OrderCar:(id) sender event: (id) event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView: self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint: currentTouchPosition];
    
    OrderCarWithDriverController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderCarWithDriverController"];
    vc.title = @"Оформить заказ";
    vc.car = [self.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - API

- (void) getCarInfoFromAPI {
    
    [[ServerManager sharedManager] getCarWithDriverDetailOnSuccess:^(NSArray *thisData) {
        [self.dataArray addObjectsFromArray:thisData];
        [self.collectionView reloadData];
    } onFail:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Error = %@", error);
    } withCategoryID:self.categoryID];
    
}

@end
