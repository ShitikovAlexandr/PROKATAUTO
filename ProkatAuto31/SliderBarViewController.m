//
//  SliderBarViewController.m
//  ProkatAuto31
//
//  Created by MacUser on 13.09.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "SliderBarViewController.h"
#import "Category.h"

@interface SliderBarViewController ()

@property (strong, nonatomic) NSArray *objectsInSlideBar;
@property (strong, nonatomic) NSArray *icons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SliderBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.objectsInSlideBar = [NSArray arrayWithObjects:@"Мой профиль", @"Мои заказы",
                              @"Статус", @"Где заказать", @"Условия аренды",
                              @"О компании", @"Соц. сети",@"Оферта", @"Выход", nil];
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.objectsInSlideBar objectAtIndex:indexPath.row]];
    return cell;

}


@end
