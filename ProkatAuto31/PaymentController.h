//
//  PaymentController.h
//  ProkatAuto31
//
//  Created by alex on 02.11.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@interface PaymentController : UIViewController <WKNavigationDelegate, UIWebViewDelegate>

@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) NSString *fullPrice;


@end
