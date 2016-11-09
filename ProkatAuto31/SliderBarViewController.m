//
//  SliderBarViewController.m
//  ProkatAuto31
//
//  Created by MacUser on 13.09.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "SliderBarViewController.h"
#import "Category.h"
#import "ServerManager.h"
#import "SideMenuItem.h"
#import "AuthorizationController.h"
#import "CarWithoutDriverController.h"
#import "SidePageIdController.h"
#import "SWRevealViewController.h"
#import "ProfileController.h"
#import "ChangePasswordController.h"
#import "PaymentController.h"

@interface SliderBarViewController ()
@property (weak, nonatomic) IBOutlet UILabel *clienHellow;


@property (strong, nonatomic) NSMutableArray *objectsInSlideBar;
@property (strong, nonatomic) NSArray *icons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SideMenuItem *exit;

@property (weak, nonatomic) IBOutlet UIButton *testPay;

@end

@implementation SliderBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.testPay addTarget:self action:@selector(paymentScreen) forControlEvents:UIControlEventTouchDown];
    
    self.objectsInSlideBar = [NSMutableArray array];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults valueForKey:@"tokenString"];
    
    self.exit = [[SideMenuItem alloc] init];
    self.exit.itemId = @66;
    self.exit.image = @"ic_exit_to_app.png";
    
    if ([token length] > 6) {
        self.clienHellow.text = [NSString stringWithFormat:@"%@ %@", [defaults valueForKey:@"lastName"],
                                 [defaults valueForKey:@"firstName"]];
        SideMenuItem *profile = [[SideMenuItem alloc] init];
        profile.itemId = @99;
        profile.image = @"ic_person.png";
        profile.title = @"Мой профиль";
        [self.objectsInSlideBar addObject:profile];
        SideMenuItem *changePassword = [[SideMenuItem alloc] init];
        changePassword.itemId = @88;
        changePassword.title = @"Сменить пароль";
        changePassword.image = @"ic_lock_open.png";
        [self.objectsInSlideBar addObject:changePassword];
        SideMenuItem *orders = [[SideMenuItem alloc]  init];
        orders.itemId = @77;
        orders.title = @"Мои заказы";
        orders.image = @"ic_inbox.png";
        [self.objectsInSlideBar addObject:orders];
        self.exit.title = @"Выход";
        [self.tableView reloadData];
    } else {
        self.exit.title = @"Вход";
        self.clienHellow.text = @"уважаемый Клиент.";
    }
    
    
    
    
    
    [self getSideMenuItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.objectsInSlideBar count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifierCell = @"Cell";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifierCell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
       
    }
    SideMenuItem *item = [self.objectsInSlideBar objectAtIndex:indexPath.row];
    cell.textLabel.minimumScaleFactor = 0.4f;
    cell.textLabel.text = [NSString stringWithFormat:@"%@", item.title];
    cell.imageView.image = [UIImage imageNamed:item.image];
    return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    SideMenuItem *item = [self.objectsInSlideBar objectAtIndex:indexPath.row];
    
    if ([item.itemId integerValue] < 30) {
        //NavSideId
        ;
        
        SidePageIdController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SidePageIdController"];
        vc.pageId = item.itemId;
        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NavSideId"];
        navVC.navigationBar.barStyle = UIBarStyleBlack;
        [navVC setViewControllers:@[vc] animated:NO];
        [self presentViewController:navVC animated:YES completion:nil];
        NSLog(@"go to controller with id page = %@", item.itemId);
        
    } else if ([item.itemId isEqualToNumber:[NSNumber numberWithInt:99]]) {
        ProfileController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileController"];
        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileControllerNav"];
        navVC.navigationBar.barStyle = UIBarStyleBlack;
        [navVC setViewControllers:@[vc] animated:NO];
        [self presentViewController:navVC animated:YES completion:nil];
        NSLog(@"go to profile");
        
    } else if ([item.itemId isEqualToNumber:[NSNumber numberWithInt:88]]) {
        ChangePasswordController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordController"];
        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileControllerNav"];
        navVC.navigationBar.barStyle = UIBarStyleBlack;
        [navVC setViewControllers:@[vc] animated:NO];
        [self presentViewController:navVC animated:YES completion:nil];
        NSLog(@"go to change password ----->>>>");
    } else if ([item.itemId isEqualToNumber:[NSNumber numberWithInt:77]]) {
        UINavigationController *ordersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersListController"];
        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersNavigationController"];
        navVC.navigationBar.barStyle = UIBarStyleBlack;
        [navVC setViewControllers:@[ordersVC] animated:NO];
        [self presentViewController:navVC animated:YES completion:nil];
    } else if ([item.itemId isEqualToNumber:[NSNumber numberWithInt:66]]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token =  [defaults valueForKey:@"tokenString"];

               if ([token length] > 6) {
                   [self alertExit];
        } else {
            [self.tableView reloadData];
            UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NavReg"];
            vc.navigationBar.barStyle = UIBarStyleBlack;
            [self presentViewController:vc animated:YES completion:nil];
        }
        NSLog(@"you press Exit/Enter");
    }
}

- (void) alertExit {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                  @"Выход" message:@"Вы действительно хотите выйти?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *exit = [UIAlertAction actionWithTitle:@"Да" style:UIAlertActionStyleDestructive
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      
                                                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                      NSString *tokenString = @"";
                                                      [defaults setValue:tokenString forKey:@"tokenString"];
                                                      self.exit.title = @"Вход";
                                                      SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                                                      [self presentViewController:vc animated:YES completion:nil];

                                                                                                      }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Нет" style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:exit];
    [alert addAction:cancel];

    [self presentViewController:alert animated:YES completion:nil];


    
}

#pragma mark - API

- (void) getSideMenuItems {
    
    [[ServerManager sharedManager] sideMenuOnSuccess:^(NSArray *data) {
        NSLog(@"objects in side menu array %d", [data count] );
        [self.objectsInSlideBar addObjectsFromArray:data];
        [self.objectsInSlideBar addObject:self.exit];
        [self.tableView reloadData];
    } onFail:^(NSError *error) {
        NSLog(@"Что то пошло не так");
        
    }];
}

// testMethod
- (void) paymentScreen {
    
    PaymentController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentController"];
    UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileControllerNav"];
    [navVC setViewControllers:@[vc] animated:NO];
    [self presentViewController:navVC animated:YES completion:nil];

    
    
}

@end
