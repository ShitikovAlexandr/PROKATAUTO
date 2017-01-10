//
//  WithoutDriverDetailController.h
//  ProkatAuto31
//
//  Created by MacUser on 13.09.16.
//  Copyright © 2016 ALEXEY SHATSKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithoutDriverDetailController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (assign, nonatomic) NSNumber *categoryID;
@property (assign, nonatomic) NSNumber *transmissionID;


@end
