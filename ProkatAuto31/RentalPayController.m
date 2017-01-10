//
//  RentalPayController.m
//  ProkatAuto31
//
//  Created by Alex on 17.11.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "RentalPayController.h"
#import "ServerManager.h"

@interface RentalPayController ()
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *rentLable;
@property (weak, nonatomic) IBOutlet UITableViewCell *mainInfoCell;


@end

@implementation RentalPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.color = [UIColor blackColor];
    self.activityIndicatorView.center = self.view.center;
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_phone.png"] style:UIBarButtonItemStylePlain target:self action:@selector(CallAction)];
    [self itemInfo];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) CallAction {
    NSLog(@"make call");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://+79036420187"]];
}


-(void) myCustomBack {
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.rentLable.frame.size.height+ 10;
}

- (void) itemInfo {
    [[ServerManager sharedManager] rentPayOnSuccess:^(NSString *urlString, NSString *title) {
        [self.activityIndicatorView stopAnimating];
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx;}</style>",
                                                                                    @"PingFangHK-Regular",
                                                                                    self.rentLable.font.pointSize]];
        NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithData:[urlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        //UIFont *font=[UIFont systemFontOfSize:14];
        // [description addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, description.length)];
        [description removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, description.length)];
        
        //self.contantLable.text = [description string];
        self.rentLable.attributedText = description;
        self.title = title;
        [self.tableView reloadData];
        [self.rentLable sizeToFit];

        
    } onFail:^(NSArray *errorArray) {
        [self.activityIndicatorView stopAnimating];

    }];

}


#pragma mark - Table view data source


@end
