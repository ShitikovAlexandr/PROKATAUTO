//
//  SidePageIdController.m
//  ProkatAuto31
//
//  Created by alex on 30.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "SidePageIdController.h"
#import "ServerManager.h"
#import "SWRevealViewController.h"

@interface SidePageIdController ()
@property (weak, nonatomic) IBOutlet UILabel *contantLable;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation SidePageIdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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


#pragma marck = API

- (void) sideItemInfoWithPageId: (NSNumber*) pageId {
    
    [[ServerManager sharedManager] sideMenuWithPageId:pageId
                                            OnSuccess:^(NSString* title, NSString* content) {
                                                NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithData:[title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                                                [description removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, description.length)];

                                                self.contantLable.attributedText = description;
                                        
                                                [self.contantLable sizeToFit];
                                                
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
    SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [self presentViewController:vc animated:YES completion:nil];
    
    

}

@end
