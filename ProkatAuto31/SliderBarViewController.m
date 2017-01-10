//
//  SliderBarViewController.m
//  ProkatAuto31
//
//  Created by MacUser on 13.09.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
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
#import "AboutController.h"

@interface SliderBarViewController ()
@property (weak, nonatomic) IBOutlet UILabel *clienHellow;


@property (strong, nonatomic) NSMutableArray *objectsInSlideBar;
@property (strong, nonatomic) NSArray *icons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SideMenuItem *exit;
@property (strong, nonatomic) SideMenuItem *about;


@end

@implementation SliderBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.objectsInSlideBar = [NSMutableArray array];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults valueForKey:@"tokenString"];
    
    self.about = [[SideMenuItem alloc] init];
    self.about.itemId = @70;
    self.about.image = @"ic_help_outline.png";
    self.about.title = NSLocalizedString(@"About", nil);

    self.exit = [[SideMenuItem alloc] init];
    self.exit.itemId = @66;
    self.exit.image = @"ic_exit_to_app.png";
    
    if ([token length] > 6) {
        self.clienHellow.text = [NSString stringWithFormat:@"%@ %@", [defaults valueForKey:@"lastName"],
                                 [defaults valueForKey:@"firstName"]];
        SideMenuItem *profile = [[SideMenuItem alloc] init];
        profile.itemId = @99;
        profile.image = @"ic_person.png";
        profile.title = NSLocalizedString(@"My profile", nil);
        [self.objectsInSlideBar addObject:profile];
        SideMenuItem *changePassword = [[SideMenuItem alloc] init];
        changePassword.itemId = @88;
        changePassword.image = @"ic_lock_open.png";
        changePassword.title = NSLocalizedString(@"Change password", nil);
        [self.objectsInSlideBar addObject:changePassword];
        SideMenuItem *orders = [[SideMenuItem alloc]  init];
        orders.itemId = @77;
        orders.image = @"ic_inbox.png";
        orders.title = NSLocalizedString(@"My orders", nil);
        self.exit.title = NSLocalizedString(@"Logout", nil);
        [self.objectsInSlideBar addObject:orders];
        
        
        [self.tableView reloadData];
    } else {
        self.exit.title = NSLocalizedString(@"Login", nil);
        self.clienHellow.text = NSLocalizedString(@"dear customer.", nil);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *zeroToken = @"";
        [defaults setValue:zeroToken forKey:@"tokenString"];

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
        
    } else if ([item.itemId isEqualToNumber:[NSNumber numberWithInt:99]]) {
        ProfileController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileController"];
        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileControllerNav"];
        navVC.navigationBar.barStyle = UIBarStyleBlack;
        [navVC setViewControllers:@[vc] animated:NO];
        [self presentViewController:navVC animated:YES completion:nil];
        
    } else if ([item.itemId isEqualToNumber:[NSNumber numberWithInt:88]]) {
        ChangePasswordController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordController"];
        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileControllerNav"];
        navVC.navigationBar.barStyle = UIBarStyleBlack;
        [navVC setViewControllers:@[vc] animated:NO];
        [self presentViewController:navVC animated:YES completion:nil];
    }
    else if ([item.itemId isEqualToNumber:[NSNumber numberWithInt:70]]) { //
        AboutController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutController"];
        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutControllerNav"];
        navVC.navigationBar.barStyle = UIBarStyleBlack;
        [navVC setViewControllers:@[vc] animated:NO];
        [self presentViewController:navVC animated:YES completion:nil];
    }
    else if ([item.itemId isEqualToNumber:[NSNumber numberWithInt:77]]) {
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
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *tokenString =@"";
            [defaults setValue:tokenString forKey:@"tokenString"];
            [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
            // Delete any cached URLrequests!
            NSURLCache *sharedCache = [NSURLCache sharedURLCache];
            [sharedCache removeAllCachedResponses];
            [self.tableView reloadData];
            UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NavReg"];
            vc.navigationBar.barStyle = UIBarStyleBlack;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

- (void) alertExit {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                NSLocalizedString(@"Logout", nil) message:NSLocalizedString(@"Do you want to exit?", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *exit = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", nil) style:UIAlertActionStyleDestructive
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     
                                                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                     NSString *tokenString =@"";
                                                     [defaults setValue:tokenString forKey:@"tokenString"];
                                                     [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
                                                     
                                                     // Delete any cached URLrequests!
                                                     NSURLCache *sharedCache = [NSURLCache sharedURLCache];
                                                     [sharedCache removeAllCachedResponses];
                                                     
                                                     self.exit.title = NSLocalizedString(@"Login", nil);
                                                     SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                                                     [self presentViewController:vc animated:YES completion:nil];
                                                 }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle: NSLocalizedString(@"No", nil) style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:exit];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - API

- (void) getSideMenuItems {
    
    [[ServerManager sharedManager] sideMenuOnSuccess:^(NSArray *data) {
        [self.objectsInSlideBar addObjectsFromArray:data];
        [self.objectsInSlideBar addObject:self.about];
        [self.objectsInSlideBar addObject:self.exit];
        [self.tableView reloadData];
    } onFail:^(NSError *error) {
        
    }];
}

@end
