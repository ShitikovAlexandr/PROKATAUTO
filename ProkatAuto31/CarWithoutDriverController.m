//
//  CarWithoutDriverController.m
//  ProkatAuto31
//
//  Created by MacUser on 12.09.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "CarWithoutDriverController.h"
#import "SWRevealViewController.h"
#import "WithoutDriverDetailController.h"
#import "Category.h"
#import "HeaderInSectionView.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"




@interface CarWithoutDriverController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *carCategories;
@property (strong, nonatomic) NSMutableArray *transmisionCategories;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (strong, nonatomic) NSString *baseAddress;



@end

@implementation CarWithoutDriverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.baseAddress = @"http://83.220.170.187";

    self.carCategories = [NSMutableArray array];
    [self getCarCategorieFromAPI];
    
    self.transmisionCategories = [NSMutableArray arrayWithArray:[self creatinCategoriesOfTransmission]];
    
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

#pragma mark - UICollectionViewDataSource

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
     return CGSizeMake(self.collectionView.frame.size.width - 16, 124);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        HeaderInSectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        
            headerView.headerText.text = @"Коробка передач";
        
        reusableview = headerView;
        
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeZero;
    }else {
        return CGSizeMake(self.collectionView.bounds.size.width, 40);
    }
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        return [self.carCategories count];
    } else {
        return [self.transmisionCategories count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const identifier = @"CarMainCollectionViewCell";
    CarMainCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    if (indexPath.section == 0) {
        Category *category =[self.carCategories objectAtIndex:indexPath.row];
        cell.categoryName.text = category.name;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseAddress, category.image]];
        [cell.carImageView setImageWithURL:url];
        return [cell addCollectionViewCellProperty:cell];
    
    } else {
        Category *category =[self.transmisionCategories objectAtIndex:indexPath.row];
        cell.categoryName.text = category.name;
        cell.mainDescription.text = category.maimDescription;
        cell.carImageView.image = [UIImage imageNamed:category.image];
        return [cell addCollectionViewCellProperty:cell];
    }
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section ==0) {
        Category *category =[self.carCategories objectAtIndex:indexPath.row];
        WithoutDriverDetailController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WithoutDriverDetailController"];
        vc.categoryID = category.categoryID;
        vc.title = category.name;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        Category *category =[self.transmisionCategories objectAtIndex:indexPath.row];
        WithoutDriverDetailController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WithoutDriverDetailController"];
        vc.transmissionID = category.categoryID;
        vc.title = category.name;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    
    
    

}

- (NSMutableArray*) creatinCategoriesOfTransmission {
    
    Category *automaticTransmission = [[Category alloc] init];
    automaticTransmission.name = @"Авто с АКПП";
    automaticTransmission.image = @"akpp120x90.jpg";
    automaticTransmission.categoryID = @2;
    automaticTransmission.maimDescription = @"Автомобили с автоматической коробкой передач";
    
    Category *manualTransmission = [[Category alloc] init];
    manualTransmission.name = @"Авто с МКПП";
    manualTransmission.image = @"mkpp120x90.jpg";
    manualTransmission.categoryID = @1;
    manualTransmission.maimDescription = @"Автомобили с механической (ручной) коробкой передач";
    
    return [NSMutableArray arrayWithObjects:manualTransmission, automaticTransmission, nil];
    
}



#pragma mark - API

- (void) getCarCategorieFromAPI {
    
    [[ServerManager sharedManager] getCarWithoutDriverCategoryOnSuccess:^(NSArray *thisData) {
        /*
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryID"
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        self.carCategories = (NSMutableArray*)[thisData sortedArrayUsingDescriptors:sortDescriptors];
        */
        
        [self.carCategories addObjectsFromArray:thisData] ;
        
        
        
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } completion:nil];
    } onFail:^(NSError *error, NSInteger statusCode) {
    }];
    
    
}




@end
