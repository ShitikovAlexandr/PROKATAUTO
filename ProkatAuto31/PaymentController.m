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
@property (strong, nonatomic) WKWebView *wkWebV;

@end

@implementation PaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.orderId = @"436";
    //self.fullPrice = @"1600";
    
    self.title = @"Оплата";
    
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



/*! @abstract Decides whether to allow or cancel a navigation after its
 response is known.
 @param webView The web view invoking the delegate method.
 @param navigationResponse Descriptive information about the navigation
 response.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationResponsePolicy.
 @discussion If you do not implement this method, the web view will allow the response, if the web view can show it.
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
}

/*! @abstract Invoked when a main frame navigation starts.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

/*! @abstract Invoked when a server redirect is received for the main
 frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

/*! @abstract Invoked when an error occurs while starting to load data for
 the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

/*! @abstract Invoked when content starts arriving for the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

/*! @abstract Invoked when a main frame navigation completes.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
}

/*! @abstract Invoked when an error occurs during a committed main frame
 navigation.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

/*! @abstract Invoked when the web view needs to respond to an authentication challenge.
 @param webView The web view that received the authentication challenge.
 @param challenge The authentication challenge.
 @param completionHandler The completion handler you must invoke to respond to the challenge. The
 disposition argument is one of the constants of the enumerated type
 NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
 the credential argument is the credential to use, or nil to indicate continuing without a
 credential.
 @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
    NSURLCredential * credential = [[NSURLCredential alloc] initWithTrust:[challenge protectionSpace].serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}





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
