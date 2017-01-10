//
//  PaymentController.m
//  ProkatAuto31
//
//  Created by alex on 02.11.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "PaymentController.h"
#import "SWRevealViewController.h"
#import "ServerManager.h"
#import "OrdersListController.h"
#import "OrderDetailController.h"



@interface PaymentController ()

@property (weak, nonatomic) IBOutlet UIView *webConteiner;
@property (strong, nonatomic) WKWebView *wkWebV;
@property (strong, nonatomic) NSString *baseAddress;


@end

@implementation PaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseAddress = @"http://prokatauto31.ru";

    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
     NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    self.wkWebV = [[WKWebView alloc] initWithFrame:self.webConteiner.frame configuration:wkWebConfig];
    self.wkWebV.navigationDelegate = self;
    self.wkWebV.UIDelegate = self;
    [self.view addSubview:self.wkWebV];

    
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
   
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
   // wkWebV.UIDelegate = self;
    //self.wkWebV.navigationDelegate = self;
    [self.wkWebV loadRequest:nsrequest];
    [self.view addSubview:self.wkWebV];

}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSString *urlString = [NSString stringWithFormat:@"%@",webView.URL];
    NSString *newStringURL;
    if ([urlString rangeOfString:self.baseAddress].location !=NSNotFound) {
         [self.wkWebV removeFromSuperview];
               if ([urlString  rangeOfString:@"error"].location !=NSNotFound) {
            newStringURL = [urlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/api/v1/public/", self.baseAddress] withString:@""];
            
        } else if ([urlString  rangeOfString:@"success"].location !=NSNotFound) {
            newStringURL = [urlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/api/v1/public/", self.baseAddress] withString:@""];
        }
        [self paymentSuccessWithAccesTocenWithURLString:newStringURL];
       
    }
    
    
    
}

// http://83.220.170.187/api/v1/public/payments/payment-success/05e9086c-1a97-42d1-b5ff-485496b6c7e8/?orderId=624b4c50-2d3c-4123-b9b0-8bd8198e0072

// http://83.220.170.187/api/v1/public/payments/payment-error/de25eefa-c256-4e84-ba6a-d9c648d92f44/?orderId=0bf2bc12-3605-4110-841a-bc5acae7f12d


#pragma mark - API

- (void) payOrder {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults valueForKey:@"tokenString"];

    [[ServerManager sharedManager] preparePaymentWithOrderId:self.orderId
                                                   AndMethod:self.fullPrice
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


- (void) paymentSuccessWithAccesTocenWithURLString: (NSString*) urlString {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults valueForKey:@"tokenString"];

    
    [[ServerManager sharedManager] paymentSuccessWithAccesTocen:token andURL:urlString OnSuccess:^(NSString *urlString) {
        
        UINavigationController *ordersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersListController"];
        UINavigationController *navVCB = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersNavigationController"];
        navVCB.navigationBar.barStyle = UIBarStyleBlack;
        [navVCB setViewControllers:@[ordersVC] animated:NO];
        OrderDetailController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailController"];
        vc.orderId = self.orderId;
        vc.backController = navVCB;
        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersNavigationController"];
        navVC.navigationBar.barStyle = UIBarStyleBlack;
        [navVC setViewControllers:@[vc] animated:NO];
        [self presentViewController:navVC animated:NO completion:nil];

        
    } onFail:^(NSArray *errorArray) {
        
        UINavigationController *ordersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersListController"];
        UINavigationController *navVCB = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersNavigationController"];
        navVCB.navigationBar.barStyle = UIBarStyleBlack;
        [navVCB setViewControllers:@[ordersVC] animated:YES];
        OrderDetailController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailController"];
        vc.orderId = self.orderId;
        vc.backController = navVCB;
        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersNavigationController"];
        navVC.navigationBar.barStyle = UIBarStyleBlack;
        [navVC setViewControllers:@[vc] animated:NO];
        [self presentViewController:navVC animated:YES completion:nil];

        
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
