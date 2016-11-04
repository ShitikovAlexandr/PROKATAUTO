//
//  TransferCategoryController.h
//  ProkatAuto31
//
//  Created by Ivan Bielko on 04.11.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"

@interface TransferCategoryController : UIViewController

@property (strong, nonatomic) Category *category;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;

@end
