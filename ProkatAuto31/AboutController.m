//
//  AboutController.m
//  ProkatAuto31
//
//  Created by alex on 08.12.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import "AboutController.h"
#import "SWRevealViewController.h"

@interface AboutController ()
@property (weak, nonatomic) IBOutlet UILabel *mainInfoLable;
@property (weak, nonatomic) IBOutlet UIView *viewVersion;
@property (weak, nonatomic) IBOutlet UILabel *appVersion;
@property (weak, nonatomic) IBOutlet UIButton *Button;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;

@end

@implementation AboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBack)];
    
    self.title = NSLocalizedString(@"About", nil);
    self.Button.layer.cornerRadius = 4.f;
    [self.mainInfoLable sizeToFit];
    CGRect rect = CGRectMake(self.mainInfoLable.frame.origin.x,
                              self.mainInfoLable.frame.origin.y + self.mainInfoLable.frame.size.height +10.f,
                              self.viewVersion.frame.size.width,
                              self.viewVersion.frame.size.height);
    
    self.viewVersion.frame = rect;
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.appVersion.text = version;
    
    [self.Button addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchDown];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) myCustomBack {
    
    SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void) sendEmail {
    
    NSString *stringURL = @"mailto:Prokatauto31@mail.ru";
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}


@end
