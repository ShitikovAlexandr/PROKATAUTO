//
//  CarWithDriverController.m
//  ProkatAuto31
//
//  Created by MacUser on 12.09.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "CarWithDriverController.h"
#import "CarsWithDriverListController.h"
#import "SWRevealViewController.h"
#import "Category.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"


@interface CarWithDriverController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (strong, nonatomic) NSMutableArray *categoryWithDriverArray;

@property (strong, nonatomic) NSString *baseAddress;

@property (weak, nonatomic) IBOutlet UIButton *CallButton;


@end

@implementation CarWithDriverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseAddress = @"http://83.220.170.187";
    
    [self.CallButton addTarget:self action:@selector(CallAction) forControlEvents:(UIControlEventTouchDown)];
    
    self.categoryWithDriverArray = [NSMutableArray array];
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

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width - 16, 124);
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return  [self.categoryWithDriverArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
     NSString *const identifier = @"CarMainCollectionViewCell";
    
    CarMainCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
   
    Category *category = [self.categoryWithDriverArray objectAtIndex:indexPath.row];
    cell.categoryName.text = category.name;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseAddress, category.image]];
    [cell.carImageView setImageWithURL:url];
    return [cell addCollectionViewCellProperty:cell];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    Category *category =[self.categoryWithDriverArray objectAtIndex:indexPath.row];
    CarsWithDriverListController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CarsWithDriverListController"];
    vc.categoryID = category.categoryID;
        
    vc.title = category.name;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - API

- (void) getCarCategorieFromAPI {
    
    [[ServerManager sharedManager] getCarWithDriverCategoryOnSuccess:^(NSArray *thisData) {
        
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryID"
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        self.categoryWithDriverArray = (NSMutableArray*)[thisData sortedArrayUsingDescriptors:sortDescriptors];
        
        //[self.categoryWithDriverArray addObjectsFromArray:thisData];
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } completion:nil];
    } onFail:^(NSError *error, NSInteger statusCode) {
       
    }];
    
    
}

- (void) CallAction {
    NSLog(@"make call");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://+79036420187"]];
}



@end
