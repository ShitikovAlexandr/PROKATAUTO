//
//  SidePageIdController.m
//  ProkatAuto31
//
//  Created by alex on 30.10.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "SidePageIdController.h"
#import "ServerManager.h"
#import "SWRevealViewController.h"
#import "SideIdPageCell.h"

@interface SidePageIdController ()
@property (assign, nonatomic) float rowHeight;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *mainCell;


@end

@implementation SidePageIdController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableinfo.rowHeight  = UITableViewAutomaticDimension;
    //self.tableinfo.estimatedRowHeight = self.rowHeight;
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.color = [UIColor blackColor];
    self.activityIndicatorView.center = self.view.center;
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    
    [self sideItemInfoWithPageId:self.pageId];
    
    
    
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_phone.png"] style:UIBarButtonItemStylePlain target:self action:@selector(CallAction)];
    
    
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) CallAction {
    NSLog(@"make call");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://+79036420187"]];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.mainLabel.frame.size.height;
}








#pragma marck = API

- (void) sideItemInfoWithPageId: (NSNumber*) pageId {
    
    [[ServerManager sharedManager] sideMenuWithPageId:pageId
                                            OnSuccess:^(NSString* title, NSString* content) {
                                                //NSString *aux = [NSString stringWithFormat:@"<span style=\"font-family: System; font-size: 16\">%@</span>", title];
                                                
                                               title = [title stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx;}</style>",
                                                                                                          @"PingFangHK-Regular",
                                                                                                          self.mainLabel.font.pointSize]];
                                                
                                                NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithData:[title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                                                //UIFont *font=[UIFont systemFontOfSize:14];
                                               // [description addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, description.length)];
                                                [description removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, description.length)];

                                                //self.contantLable.text = [description string];
                                                self.mainLabel.attributedText = description;
                                                [self.mainLabel sizeToFit];
                                                [self.tableView reloadData];
                                                
                                        
                                                                                              
                                                NSMutableAttributedString *titlelable = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                                                [titlelable removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, titlelable.length)];
                                                self.title = content;
                                                [self.activityIndicatorView stopAnimating];

                                            }
                                               onFail:^(NSError *error) {
                                                   [self.activityIndicatorView stopAnimating];
                                               }];
}

-(void) myCustomBack {
    // Some anything you need to do before leaving
    
    if (self.goBack) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    
    

}

@end
