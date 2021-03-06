//
//  WithoutDriverDetailController.m
//  ProkatAuto31
//
//  Created by MacUser on 13.09.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
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

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) NSNumberFormatter* numberFormatter;






@end

@implementation WithoutDriverDetailController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [self.numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];

  
    self.navigationItem.hidesBackButton = YES; 
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_phone.png"] style:UIBarButtonItemStylePlain target:self action:@selector(CallAction)];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.color = [UIColor blackColor];
    self.activityIndicatorView.center = self.view.center;
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];

    
    
    self.baseAddress = @"http://prokatauto31.ru";
    self.expandedCellIndex = -1;
    self.dataArray = [NSMutableArray array];
    
    if (self.categoryID !=NULL) {
        [self getCarInfoFromAPI];
    } else {
        [self getCarInfoWithTransmissionFromAPI];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) CallAction {
    NSLog(@"make call");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://+79036420187"]];
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
    
    cell.carName.text = [NSString stringWithFormat:@"%@", car.itemFullName];
    cell.transmission.text = car.itemTransmissionName;
    cell.engine.text = [NSString stringWithFormat:NSLocalizedString(@"%@ ltr.", nil), car.itemEngine];
    cell.power.text =  [NSString stringWithFormat:NSLocalizedString(@"%@ HP", nil), car.itemPower];
    cell.fuel.text = car.itemFuelName;
    
    cell.deposit.text = [NSString stringWithFormat:@"%@", [self.numberFormatter stringFromNumber:car.deposit]];
    cell.priceFrom.text = [NSString stringWithFormat:NSLocalizedString(@"from %@ rubles", nil), [self.numberFormatter stringFromNumber:car.minimumPrice]]; //car.minimumPrice
    cell.priceRange1.text = [NSString stringWithFormat:@"%@", [self.numberFormatter stringFromNumber:car.priceRange1]];
    cell.priceRange2.text = [NSString stringWithFormat:@"%@", [self.numberFormatter stringFromNumber:car.priceRange2]];
    cell.priceRange3.text = [NSString stringWithFormat:@"%@", [self.numberFormatter stringFromNumber:car.priceRange3]];

    NSString* str = @"";
    for (NSString* color in car.itemColor) {
        
         str = [NSString stringWithFormat:@"%@ %@", color, str];
    }
    cell.color.text = str;
    
    [cell.InfoButton addTarget:self action:@selector(infoClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];
    if (self.expandedCellIndex == indexPath.item) {
        cell.InfoButton.selected =YES;
        [cell.InfoButton setTitle:NSLocalizedString(@"Hide specifications", nil) forState:UIControlStateNormal];
    } else {
        cell.InfoButton.selected =NO;
        [cell.InfoButton setTitle:NSLocalizedString(@"Show specifications", nil) forState:UIControlStateNormal];

    }
    
    [cell.rentalButton addTarget:self action:@selector(StepOne:event:) forControlEvents:UIControlEventTouchUpInside];
    
    return [cell addCollectionViewCellProperty:cell];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
   
    
   }

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.expandedCellIndex == indexPath.item) {
        return CGSizeMake(self.collectionView.frame.size.width - 16, 520);
      
    }
    return CGSizeMake(self.collectionView.frame.size.width - 16, 397);
}

- (IBAction)infoClickEvent:(id) sender event: (id) event {
   
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView: self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint: currentTouchPosition];
    
    

    
    if (self.expandedCellIndex == indexPath.item) {
        
        [UIView animateWithDuration:1 animations:^{
        
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

- (IBAction)StepOne:(id) sender event: (id) event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView: self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint: currentTouchPosition];
    
    StepOneWithoutDriverController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StepOneWithoutDriverController"];
    vc.car = [self.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];

    
}

-(void) myCustomBack {
    
  
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - API

- (void) getCarInfoFromAPI {
    
   [[ServerManager sharedManager] getCarWithoutDriverDetailOnSuccess:^(NSArray *thisData) {
       [self.dataArray addObjectsFromArray:thisData];
       [self.activityIndicatorView stopAnimating];

       [self.collectionView reloadData];
   } onFail:^(NSError *error, NSInteger statusCode) {
       [self.activityIndicatorView stopAnimating];

   } withCategoryID:self.categoryID];
    
}

- (void) getCarInfoWithTransmissionFromAPI {
    
    [[ServerManager sharedManager] getCarWithoutDriverDetailWithTransmissionOnSuccess:^(NSArray *thisData) {
        [self.dataArray addObjectsFromArray:thisData];
        [self.activityIndicatorView stopAnimating];

        [self.collectionView reloadData];
    } onFail:^(NSError *error, NSInteger statusCode) {
        [self.activityIndicatorView stopAnimating];

    } withCategoryID:self.transmissionID];
}



@end
