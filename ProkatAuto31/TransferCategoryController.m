//
//  TransferCategoryController.m
//  ProkatAuto31
//
//  Created by Ivan Bielko on 04.11.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import "TransferCategoryController.h"
#import "UIImageView+AFNetworking.h"
#import "TransferOrderController.h"

@implementation TransferCategoryController : UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    self.titleLabel.text = self.category.name;
    
    NSURL *url = [NSURL URLWithString:self.category.image];
    [self.imageView setImageWithURL:url];
    self.imageView.frame = CGRectMake(15, 15, 100, 100);
    
    NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithData:[self.category.maimDescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    CGRect descriptionRect = [description boundingRectWithSize:CGSizeMake(self.scrollView.frame.size.width - 135, 0)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
    self.descriptionLabel.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.origin.y, descriptionRect.size.width, descriptionRect.size.height);

    self.descriptionLabel.attributedText = description;
    
    self.orderButton.frame = CGRectMake(self.scrollView.frame.size.width - 130, self.descriptionLabel.bounds.size.height + 30, self.orderButton.bounds.size.width, self.orderButton.bounds.size.height);
    [self styleRCButton:self.orderButton];
    [self.orderButton addTarget:self action:@selector(orderButtonPressed:event:) forControlEvents:UIControlEventTouchUpInside];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.orderButton.frame.origin.y + self.orderButton.frame.size.height + 10);
}

-(void) myCustomBack {
    // Some anything you need to do before leaving
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) styleRCButton: (UIButton*) button {
    
    button.layer.cornerRadius = 3.f;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.masksToBounds = YES;
}

- (IBAction)orderButtonPressed:(id) sender event: (id) event {
    TransferOrderController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TransferOrderController"];
    vc.category = self.category;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
