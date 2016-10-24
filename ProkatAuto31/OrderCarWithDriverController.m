//
//  OrderCarWithDriverController.m
//  ProkatAuto31
//
//  Created by Ivan Bielko on 22.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "OrderCarWithDriverController.h"
#import "UIImageView+AFNetworking.h"

@interface OrderCarWithDriverController ()
@property (strong, nonatomic) NSString *baseAddress;
@end

@implementation OrderCarWithDriverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    self.baseAddress = @"http://83.220.170.187";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseAddress, _car.imageURL]];
    [_carImageView setImageWithURL:url];
    
    _titleLabel.text = _car.name;
    _descriptionLabel.attributedText = [[NSAttributedString alloc] initWithData:[_car.carDescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    [_descriptionLabel sizeToFit];
}

-(void) myCustomBack {
    // Some anything you need to do before leaving
    [self.navigationController popViewControllerAnimated:YES];
}

@end
