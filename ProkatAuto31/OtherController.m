//
//  OtherController.m
//  ProkatAuto31
//
//  Created by MacUser on 12.09.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "OtherController.h"
#import "SWRevealViewController.h"
#import "Category.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "CarMainCollectionViewCell.h"
#import "CarsWithDriverListController.h"
#import "TransferCategoryController.h"
#import "RentalPayController.h"


@interface OtherController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSString *baseAddress;
@property (strong, nonatomic) NSNumber *transferId;


@property (strong, nonatomic) NSMutableArray *categoryArray;

@property (weak, nonatomic) IBOutlet UIButton *CallButton;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;


@end

@implementation OtherController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.color = [UIColor blackColor];
    self.activityIndicatorView.center = self.view.center;
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];

    self.baseAddress = @"http://prokatauto31.ru";
    
    [self.CallButton addTarget:self action:@selector(CallAction) forControlEvents:(UIControlEventTouchDown)];

    self.categoryArray = [NSMutableArray array];
    [self getCarCategorieFromAPI];
    
    SWRevealViewController *revealViewController = self.revealViewController;

    if ( revealViewController )
        {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
        }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return  [self.categoryArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *const identifier = @"OtherCollectionViewCell";
    
     CarMainCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    Category *category = [self.categoryArray objectAtIndex:indexPath.row];
    cell.categoryName.text = category.name;
    NSURL *url;
    if([category.image hasPrefix:@"http"])
        url = [NSURL URLWithString:category.image];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseAddress, category.image]];
    [cell.carImageView setImageWithURL:url];
    return [cell addCollectionViewCellProperty:cell];

    
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width - 16, 124);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    Category *category =[self.categoryArray objectAtIndex:indexPath.row];
    if([category.categoryID isEqual:self.transferId])
    {
        TransferCategoryController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TransferOrderController"];
        vc.category = category;
        
        vc.title = category.name;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([category.categoryID intValue] == 15) {
        
        RentalPayController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RentalPayController"];
        [self.navigationController pushViewController:vc animated:YES];

    }
    
    else
    {
        CarsWithDriverListController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CarsWithDriverListController"];
        vc.categoryID = category.categoryID;
    
        vc.title = category.name;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark - API

- (void) getCarCategorieFromAPI {
    [[ServerManager sharedManager] getTransferCategoryInfo:^(Category *category, NSString* content)
     {
         [self.categoryArray addObject:category];
         self.transferId = category.categoryID;
         [[ServerManager sharedManager] getCarOtherCategoryOnSuccess:^(NSArray *thisData) {
             [self.categoryArray addObjectsFromArray:thisData];
             [[ServerManager sharedManager] getCarOtherCategoryWithPageOnSuccess:^(NSArray *thisData) {
                 [self.categoryArray addObjectsFromArray:thisData];
                 [self.activityIndicatorView stopAnimating];
                 [self.collectionView reloadData];
             } onFail:^(NSError *error, NSInteger statusCode) {
             }];
         } onFail:^(NSError *error, NSInteger statusCode) {
             [self.activityIndicatorView stopAnimating];
         }];
     } onFail:^(NSError *error) {
         [self.activityIndicatorView stopAnimating];
     }];
}

- (void) CallAction {
    NSLog(@"make call");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://+79036420187"]];
}

@end
