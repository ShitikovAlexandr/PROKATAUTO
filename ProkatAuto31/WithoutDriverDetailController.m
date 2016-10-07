//
//  WithoutDriverDetailController.m
//  ProkatAuto31
//
//  Created by MacUser on 13.09.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "WithoutDriverDetailController.h"
#import "CarWithoutDriverDetailsCell.h"

#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "Car.h"
#import "StepOneWithoutDriverController.h"



@interface WithoutDriverDetailController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSString *baseAddress;




@property (assign, nonatomic) NSInteger expandedCellIndex;




@end

@implementation WithoutDriverDetailController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES; 
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];

    //[self.navigationController.navigationItem.backBarButtonItem setTitle:@"dddd"];
    self.baseAddress = @"http://83.220.170.187";
  

    
    self.expandedCellIndex = -1;

    self.dataArray = [NSMutableArray array];
    
    [self getCarInfoFromAPI];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *const identifier = @"CarWithoutDriverDetailsCell";
    
    CarWithoutDriverDetailsCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    Car *car = [self.dataArray objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseAddress, car.imageURL]];
    [cell.mainCarImage setImageWithURL:url];
    
    cell.carName.text = [NSString stringWithFormat:@"%@ %@", car.itemFullName, car.itemTransmissionName];
    cell.transmission.text = car.itemTransmissionName;
    cell.engine.text = [NSString stringWithFormat:@"%@ л", car.itemEngine];
    cell.power.text =  [NSString stringWithFormat:@"%@ л.с.",car.itemPower];
    cell.fuel.text = car.itemFuelName;
    
    cell.deposit.text = [NSString stringWithFormat:@"%@ руб", car.deposit];
    cell.priceFrom.text = [NSString stringWithFormat:@"от %@ руб", car.minimumPrice];
    cell.priceRange1.text = [NSString stringWithFormat:@"%@ руб", car.priceRange1];
    cell.priceRange2.text = [NSString stringWithFormat:@"%@ руб", car.priceRange2];
    cell.priceRange3.text = [NSString stringWithFormat:@"%@ руб", car.priceRange3];
    
    
    [cell.InfoButton addTarget:self action:@selector(infoClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];
    if (self.expandedCellIndex == indexPath.item) {
        cell.InfoButton.selected =YES;
    } else {
        cell.InfoButton.selected =NO;
    }
    
    //[cell.rentalButton addTarget:self action:@selector(StepOne) forControlEvents:<#(UIControlEvents)#>];
    
    return [cell addCollectionViewCellProperty:cell];
    
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

- (IBAction)infoClickEvent:(id) sender event: (id) event {
   
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView: self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint: currentTouchPosition];
   // NSLog(@"Press info button at index %d", indexPath.item);
    
     
    
    if (self.expandedCellIndex == indexPath.item) {
        
        [UIView animateWithDuration:1 animations:^{
            // cell.backgroundColor = [UIColor lightGrayColor];
        }];
        self.expandedCellIndex = -1;
    } else {
        [UIView animateWithDuration:1 animations:^{
            //cell.backgroundColor = [UIColor whiteColor];
        }];
        self.expandedCellIndex = indexPath.item;
    }
    [self.collectionView reloadData];
    
}

-(void) myCustomBack {
    // Some anything you need to do before leaving
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - API

- (void) getCarInfoFromAPI {
    
   [[ServerManager sharedManager] getCarWithoutDriverDetailOnSuccess:^(NSArray *thisData) {
       [self.dataArray addObjectsFromArray:thisData];
       [self.collectionView reloadData];
   } onFail:^(NSError *error, NSInteger statusCode) {
       NSLog(@"Error = %@", error);
   } withCategoryID:self.categoryID];
    
}


@end
