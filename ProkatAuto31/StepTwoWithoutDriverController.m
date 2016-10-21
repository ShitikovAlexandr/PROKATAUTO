//
//  StepTwoWithoutDriverController.m
//  ProkatAuto31
//
//  Created by alex on 12.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "StepTwoWithoutDriverController.h"
#import "StepTwoMainCell.h"
#import "StepTwoOptionsCell.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "Option.h"
#import "ButtonCell.h"
#import "RegistrationController.h"




@interface StepTwoWithoutDriverController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *optionsArray;
@property (strong, nonatomic) NSString *baseAddress;
@property (strong, nonatomic) UIAlertController *alert;



@end

@implementation StepTwoWithoutDriverController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseAddress = @"http://83.220.170.187";

    
    self.optionsArray = [NSMutableArray array];
    
    [self getCarOptionsFromAPI];
    
    
    // Do any additional setup after loading the view.
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else {
         return [self.optionsArray count]+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString* identifier = @"StepTwoMainCell";
        StepTwoMainCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
        cell.carName.text = [NSString stringWithFormat:@"%@ %@ %@", self.order.car.itemFullName, self.order.car.itemEngine, self.order.car.itemTransmissionName];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseAddress, self.order.car.imageURL]];
        [cell.carImage setImageWithURL:url];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
        
        NSDateFormatter *screenDate = [[NSDateFormatter alloc] init];
        [screenDate setDateFormat:@"dd.MM.yyyy"];

        NSDate *startRental = [df dateFromString:self.order.startDateOfRentalString];
        NSDate *endRental = [df dateFromString:self.order.endDateOfRentalString];
        NSLog(@"Date of start rental %@", startRental);
        NSLog(@"Date of end rental %@", endRental);
        
        cell.rentalStartDate.text = [screenDate stringFromDate:startRental];
        cell.rentalEndDate.text = [screenDate stringFromDate:endRental];
        
        
        NSLog(@"rentalPeriod %f", [endRental timeIntervalSinceDate:startRental]);
        NSInteger rentalPeriod = (NSInteger)([endRental timeIntervalSinceDate:startRental]/60/60);
        NSInteger rentalPeriodDay = (NSInteger)rentalPeriod/24;
        if (rentalPeriod % 24 > 0) {
            rentalPeriodDay = rentalPeriodDay+1;
        }
        NSInteger range;
        NSInteger dayPrice;
        if (rentalPeriodDay < 4) {
             range =  [self.order.car.priceRange1 integerValue];
        } else if (rentalPeriodDay >= 4 && rentalPeriodDay < 7) {
             range =  [self.order.car.priceRange2 integerValue];
        } else {
             range =  [self.order.car.priceRange3 integerValue];

        }
        dayPrice = rentalPeriodDay * range;
        
        NSLog(@"dayPrice________ is %d", dayPrice);
        self.order.totalPrice = [NSNumber numberWithInteger:dayPrice];
        cell.rentalPrice.text = [NSString stringWithFormat:@"%@", self.order.totalPrice];
        cell.rentalPriceCalculation.text = [NSString stringWithFormat:@"%ld x %ld суток", (long)range, (long)rentalPeriodDay];
        
        
        
        
        cell.rentalDayPeriod.text = [NSString stringWithFormat:@"%d суток", rentalPeriodDay];
        NSLog(@"rental period in hower %d", rentalPeriod);
        NSLog(@"rental period rentalPeriodDay %d", rentalPeriodDay);
        
        cell.placeStart.text = self.order.startPlace.name;
        cell.placeend.text = self.order.endPlace.name;
        
        


        return cell;
        
    } else {
        
        if (indexPath.row == [self.optionsArray count]) {
            ButtonCell *cell =[self.tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
            
            [cell.buttonNext addTarget:self action:@selector(registerOrLoginAlert) forControlEvents:UIControlEventTouchDown];
            
            return cell;
        } else {
        
        static NSString* identifier = @"StepTwoOptionsCell";
        StepTwoOptionsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
        
        Option *option = [self.optionsArray objectAtIndex:indexPath.row];
        cell.nameOption.text = [NSString stringWithFormat:@"%@",option.optionName]; //option.optionName;
        cell.priceOption.text = [NSString stringWithFormat:@"%@", option.optionPrice];
            
            if ([option.optionAvaliableAmount intValue] >1) {
                NSLog(@"option name %@", option.optionAvaliableAmount);
                [cell.optionCount setUserInteractionEnabled:YES];
                cell.optionCount.layer.borderColor = [UIColor grayColor].CGColor;
                cell.optionCount.layer.cornerRadius = 6.f;
                cell.optionCount.layer.borderWidth = 1.f;
                
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectOptionCount:)];
                [tapGestureRecognizer setNumberOfTapsRequired:1];
                [cell.optionCount addGestureRecognizer:tapGestureRecognizer];
            }
            
        return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 430;
    } else {
        if (indexPath.row == [self.optionsArray count]) {
            return 45;
        } else {
        return 35;
        }
    }
    
}

#pragma mark - UIAlertController



- (void) selectOptionCount: (UITapGestureRecognizer *) gesture  {
    CGPoint touchPoint=[gesture locationInView:self.tableView];
     NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    Option *option = [self.optionsArray objectAtIndex:indexPath.row];
    
    self.alert = nil;
    self.alert = [UIAlertController alertControllerWithTitle:
                  @"Количество" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    for (int i = 0; i < [option.optionAvaliableAmount integerValue]; i++) {
        
        NSString *value = [NSString stringWithFormat:@"%d",i+1];
        NSLog(@"value is _______ %@", value);
        
        UIAlertAction *point = [UIAlertAction actionWithTitle:value style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }];
                [self.alert addAction:point];
        
    }
    [self presentViewController:self.alert animated:YES completion:nil];
}



- (void) registerOrLoginAlert {
    
    self.alert = nil;
    self.alert = [UIAlertController alertControllerWithTitle:
                  @"Вход" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *LogIn = [UIAlertAction actionWithTitle:@"Войти" style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     
                                                 }];
    
    
    UIAlertAction *registration = [UIAlertAction actionWithTitle:@"Регистрация" style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      
                                                      RegistrationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationController"];
                                                      
                                                      vc.title = @"Регистрация";
                                                      [self.navigationController pushViewController:vc animated:YES];
                                                      
                                                      
                                                  }];
    
    UIAlertAction *forgetPassword = [UIAlertAction actionWithTitle:@"Забыли пароль?" style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];

    
    [self.alert addAction:LogIn];
    [self.alert addAction:registration];
    [self.alert addAction:forgetPassword];
    
    [self presentViewController:self.alert animated:YES completion:nil];

    
    
}



#pragma mark - API

- (void) getCarOptionsFromAPI {
    
    [[ServerManager sharedManager] getCarOptionsOnSuccess:^(NSArray *thisData) {
        [self.optionsArray addObjectsFromArray:thisData];
        [self.tableView reloadData];
    } onFail:^(NSError *error, NSInteger statusCode) {
        //
    }];
    
}


@end
