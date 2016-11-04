//
//  PaymentController.m
//  ProkatAuto31
//
//  Created by alex on 02.11.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "PaymentController.h"
#import "SWRevealViewController.h"
#import "ServerManager.h"



@interface PaymentController ()

@property (weak, nonatomic) IBOutlet UIView *webConteiner;

@end

@implementation PaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orderId = @"436";
    self.fullPrice = @"1600";
    
    self.title = @"Оплата";
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    [self payOrder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) myCustomBack {
    SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) addWebViewWithURL: (NSString*) urlString {
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    WKWebView *wkWebV = [[WKWebView alloc] initWithFrame:self.webConteiner.frame configuration:wkWebConfig];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    [wkWebV loadRequest:nsrequest];
    [self.view addSubview:wkWebV];

}

#pragma mark - API

- (void) payOrder {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults valueForKey:@"tokenString"];

    [[ServerManager sharedManager] preparePaymentWithOrderId:self.orderId
                                                   AndMethod:@"full"
                                                   AndtToken:token
                                                   OnSuccess:^(NSString *urlString) {
                                                       
                                                       [self addWebViewWithURL:urlString];
                                                       
                                                   }
                                                      onFail:^(NSArray *errorArray) {
                                                          
                                                          if ([errorArray count] > 0) {
                                                              NSString* newString = [[errorArray objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                                                              [self errorAlertInput:[NSString stringWithFormat:@"%@",newString]];
                                                          }
                                                      }];
}

- (void) errorAlertInput: (NSString*) errorText {
    
    UIAlertController *alert = nil;
    alert = [UIAlertController alertControllerWithTitle:
             errorText message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                                                         [self presentViewController:vc animated:YES completion:nil];
                                                         
                                                         
                                                     }];
    
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}





@end
