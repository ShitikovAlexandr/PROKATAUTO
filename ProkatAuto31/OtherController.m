//
//  OtherController.m
//  ProkatAuto31
//
//  Created by MacUser on 12.09.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "OtherController.h"
#import "SWRevealViewController.h"
#import "Category.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "CarMainCollectionViewCell.h"


@interface OtherController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSString *baseAddress;


@property (strong, nonatomic) NSMutableArray *categoryArray;

@end

@implementation OtherController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.baseAddress = @"http://83.220.170.187";

    self.categoryArray = [NSMutableArray array];
    [self getCarCategorieFromAPI];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
        {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseAddress, category.image]];
    [cell.carImageView setImageWithURL:url];
    return [cell addCollectionViewCellProperty:cell];

    
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width - 16, 124);
}


#pragma mark - API

- (void) getCarCategorieFromAPI {
    [[ServerManager sharedManager] getCarOtherCategoryOnSuccess:^(NSArray *thisData) {
        [self.categoryArray addObjectsFromArray:thisData];
        
        [[ServerManager sharedManager] getCarOtherCategoryWithPageOnSuccess:^(NSArray *thisData) {
            [self.categoryArray addObjectsFromArray:thisData];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } onFail:^(NSError *error, NSInteger statusCode) {
            NSLog(@"error = %@, ", error);
        }];
         } onFail:^(NSError *error, NSInteger statusCode) {
        NSLog(@"error = %@, ", error);
    }];
   // [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}


@end
