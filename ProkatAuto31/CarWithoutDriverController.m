//
//  CarWithoutDriverController.m
//  ProkatAuto31
//
//  Created by MacUser on 12.09.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "CarWithoutDriverController.h"
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
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UIButton *CallButton;


@end

@implementation CarWithoutDriverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }

    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.color = [UIColor blackColor];
    self.activityIndicatorView.center = self.view.center;
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    [self.CallButton addTarget:self action:@selector(CallAction) forControlEvents:(UIControlEventTouchDown)];
       
    self.baseAddress = @"http://prokatauto31.ru";

    self.carCategories = [NSMutableArray array];
    [self getCarCategorieFromAPI];
    
    self.transmisionCategories = [NSMutableArray arrayWithArray:[self creatinCategoriesOfTransmission]];
    
    
    
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
        
            headerView.headerText.text = NSLocalizedString(@"Transmission", nil);
        
        reusableview = headerView;
        
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeZero;
    }else {
        return CGSizeMake(self.collectionView.bounds.size.width, 50);
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
        cell.mainDescription.text = @"";
        CGRect frame = cell.categoryName.frame;
        frame.origin.y= 36.f;
        frame.origin.x= cell.categoryName.frame.origin.x;
        cell.categoryName.frame = frame;
        
        
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
    automaticTransmission.name = NSLocalizedString(@"Car with AT", nil);
    automaticTransmission.image = @"akpp120x90.jpg";
    automaticTransmission.categoryID = @2;
    automaticTransmission.maimDescription = NSLocalizedString(@"Cars with automatic transmission", nil);
    
    Category *manualTransmission = [[Category alloc] init];
    manualTransmission.name = NSLocalizedString(@"Car with MT", nil);
    manualTransmission.image = @"mkpp120x90.jpg";
    manualTransmission.categoryID = @1;
    manualTransmission.maimDescription = NSLocalizedString(@"Vehicles with manual gearbox", nil);
    
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
        [self.activityIndicatorView stopAnimating];
        [self.collectionView reloadData];
        /*
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } completion:nil];
        */
    } onFail:^(NSError *error, NSInteger statusCode) {
        [self.activityIndicatorView stopAnimating];

        
    }];
    
    
}

- (void) CallAction {
    NSLog(@"make call");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://+79036420187"]];
}




@end
