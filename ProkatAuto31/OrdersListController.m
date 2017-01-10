//
//  OrdersListController.m
//  ProkatAuto31
//
//  Created by Ivan Bielko on 27.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "OrdersListController.h"
#import "ServerManager.h"
#import "OrderCell.h"
#import "Order.h"
#import "SWRevealViewController.h"
#import "OrderDetailController.h"
#import "StepOneWithoutDriverController.h"

@interface OrdersListController ()
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *CallButton;
@property (strong, nonatomic) NSNumberFormatter* numberFormatter;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) NSMutableArray *carsArray;
@property (assign, nonatomic) CGFloat cellSize;



@end

@implementation OrdersListController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //CallAction
    [self getCars];
    self.carsArray = [NSMutableArray array];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_phone.png"] style:UIBarButtonItemStylePlain target:self action:@selector(CallAction)];
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [self.numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.color = [UIColor blackColor];
    self.activityIndicatorView.center = self.view.center;
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];

    
    self.dataArray = [NSMutableArray array];
    
    [self getOrdersFromAPI];
}

-(void) myCustomBack {

    SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *const identifier = @"OrderCell";
    
    OrderCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.book.hidden = YES;
    cell.book.layer.cornerRadius = 3.f;
    cell.book.layer.borderWidth = 1.0f;
    cell.book.layer.borderColor = [UIColor clearColor].CGColor;
    cell.book.layer.masksToBounds = YES;

    
    Order *order = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([order.status isEqualToString:@"cancel"] || [order.status isEqualToString:@"finished"]) {
        cell.book.hidden = NO;
    }
    
    cell.numberLabel.text = [NSString stringWithFormat:@"№%@", order.number];
    [self manageLabelWithStatus:order.status statusLabel:cell.statusLabel];
    
    
    
    [self manageLabelWithPaymentStatus:order.paymentStatus statusLabel:cell.paymentStatus paid:order.paid];
    cell.carLabel.text = [NSString stringWithFormat:@"%@ %@", order.car.itemFullName, order.car.regNumber];
    NSString *daysText = [NSString stringWithFormat:@"%@", order.days];
    cell.daysLabel.text = [NSString stringWithFormat:@"%@ %@", order.days, [daysText hasSuffix:@"1"] ? NSLocalizedString(@"day", nil) : NSLocalizedString(@"days", nil)];
    
    cell.priceLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ rubles", nil), [self.numberFormatter stringFromNumber:[NSNumber numberWithInt:[order.totalPrice intValue]]]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yy"];
    NSString *fromDate = [dateFormatter stringFromDate:order.dateOfRentalStart];
    NSString *toDate = [dateFormatter stringFromDate:order.dateOfRentalEnd];
    cell.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"from %@ to %@", nil), fromDate, toDate];
    
    if([order.penaltyStatus isEqualToString:@"none"])
        cell.penaltyLabel.hidden = TRUE;
    else
        cell.penaltyLabel.text = [NSString stringWithFormat:NSLocalizedString(@"penalty %@ rubles", nil), [self.numberFormatter stringFromNumber:order.penalty]];
    [self manageLabelWithPaymentStatus:order.penaltyStatus statusLabel:cell.penaltyStatusLabel paid:order.penaltyPaid];
    
    [cell.book addTarget:self action:@selector(StepOne:event:) forControlEvents:UIControlEventTouchDown];
    
    return [cell addCollectionViewCellProperty:cell];
    
}



- (IBAction)StepOne:(id) sender event: (id) event {
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView: self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint: currentTouchPosition];
    Order *order = [self.dataArray objectAtIndex:indexPath.row];
    
    for (Car* car in self.carsArray) {
        for (id carId in car.carID ) {
            if ([carId isEqual:order.car.carID]) {
                
                StepOneWithoutDriverController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StepOneWithoutDriverController"];
                vc.car = car;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }

            
        }
        
    }
    
    
    
}


- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Order *order = [self.dataArray objectAtIndex:indexPath.row];

    if ([order.status isEqualToString:@"cancel"] || [order.status isEqualToString:@"finished"]) {
        self.cellSize = 170.f;
    } else {
        
        self.cellSize = 125.f;
    }
 
        return CGSizeMake(self.collectionView.frame.size.width - 16, self.cellSize);
    
}

- (void) manageLabelWithStatus: (NSString *) status
                    statusLabel: (UILabel *) label {
    label.layer.borderWidth = 1.f;
    
    if([status isEqualToString:@"created"])
    {
        label.text = NSLocalizedString(@"New", nil);
        
        label.textColor = [UIColor darkGrayColor];
        label.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }else if([status isEqualToString:@"rejected"])
    {
        label.text = NSLocalizedString(@"Rejected", nil);
        label.textColor = [UIColor colorWithRed:139/255.f green:0 blue:0 alpha:1];
        label.layer.borderColor = [UIColor colorWithRed:139/255 green:0 blue:0 alpha:1].CGColor;
    }else if([status isEqualToString:@"cancel"])
    {

        
        label.text = NSLocalizedString(@"Cancel", nil);
        label.textColor = [UIColor colorWithRed:139.f/255 green:0 blue:0 alpha:1];
        label.layer.borderColor = [UIColor colorWithRed:139.f/255 green:0 blue:0 alpha:1].CGColor;
    }else if([status isEqualToString:@"reserve"])
    {
        label.text = NSLocalizedString(@"Reservation", nil);
        
        label.textColor = [UIColor colorWithRed:212.f/255 green:85.f/255 blue:0 alpha:1];
        label.layer.borderColor = [UIColor colorWithRed:212.f/255 green:85.f/255 blue:0 alpha:1].CGColor;
        
    }else if([status isEqualToString:@"onwork"])
    {
        label.text = NSLocalizedString(@"Book a car", nil);
        
        label.textColor = [UIColor colorWithRed:0 green:128.f/255 blue:0 alpha:1];
        label.layer.borderColor = [UIColor colorWithRed:0 green:128.f/255 blue:0 alpha:1].CGColor;
    }else if([status isEqualToString:@"finished"])
    {
        label.text = NSLocalizedString(@"Archive", nil);
        
        label.textColor = [UIColor blueColor];
        label.layer.borderColor = [UIColor blueColor].CGColor;
        
    }
    else
    {
        label.text = NSLocalizedString(@"Error", nil);
        
        label.textColor = [UIColor colorWithRed:139/255 green:0 blue:0 alpha:1];
        label.layer.borderColor = [UIColor colorWithRed:139/255 green:0 blue:0 alpha:1].CGColor;
        
        
    }
}

- (void) manageLabelWithPaymentStatus: (NSString *) status
                          statusLabel: (UILabel *) label
                                 paid: (NSNumber *) paid {
    
    if([status isEqualToString:@"empty"])
    {
        label.text = NSLocalizedString(@"not paid", nil);
        label.textColor = [UIColor colorWithRed:139.f/255 green:0 blue:0 alpha:1];
    }else if([status isEqualToString:@"partial"])
    {
        label.text = [NSString stringWithFormat: NSLocalizedString(@"paid %@", nil), [self.numberFormatter stringFromNumber:[NSNumber numberWithInt:[paid intValue]]]];
        label.textColor = [UIColor colorWithRed:212.f/255 green:85.f/255 blue:0 alpha:1];
    }else if([status isEqualToString:@"full"])
    {
        label.text = NSLocalizedString(@"paid", nil);
        label.textColor = [UIColor colorWithRed:0 green:128.f/255 blue:0 alpha:1];
    }else if([status isEqualToString:@"none"])
    {
        label.hidden = TRUE;
    }
    else
    {
        label.text = NSLocalizedString(@"Error", nil);
        label.textColor = [UIColor colorWithRed:139.f/255 green:0 blue:0 alpha:1];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Order *order = [self.dataArray objectAtIndex:indexPath.row];
    
    OrderDetailController *orderDitail = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailController"];
    orderDitail.orderId = order.orderId;
    orderDitail.order = order;
    [self.navigationController pushViewController:orderDitail animated:YES];
    
    
}


#pragma mark - API

- (void) getOrdersFromAPI {
    
    [[ServerManager sharedManager] ordersHistory:^(NSArray *thisData) {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderId"
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *tempArray = [thisData sortedArrayUsingDescriptors:sortDescriptors];
        self.dataArray = (NSMutableArray*)[[tempArray reverseObjectEnumerator] allObjects];
        [self.activityIndicatorView stopAnimating];

        [self.collectionView reloadData];
    } onFail:^(NSError *error) {
        [self.activityIndicatorView stopAnimating];

        NSLog(@"Error = %@", error);
    }];
    
}

- (void) getCars {
    
    [[ServerManager sharedManager]getCarWithoutDriverDetailOnSuccess:^(NSArray *thisData) {
        [self.carsArray addObjectsFromArray:thisData];
        [[ServerManager sharedManager] getCarWithoutDriverDetailOnSuccess:^(NSArray *thisData) {
            [self.carsArray addObjectsFromArray:thisData];
        } onFail:^(NSError *error, NSInteger statusCode) {
            
        } withCategoryID:@3];
       
    } onFail:^(NSError *error, NSInteger statusCode) {
        
    }];
}

- (void) CallAction {
    NSLog(@"make call");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://+79036420187"]];
}
@end
