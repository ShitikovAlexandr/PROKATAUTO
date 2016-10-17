//
//  CarsWithDriverListController.h
//  ProkatAuto31
//
//  Created by Ivan Bielko on 08.10.16.
//  Copyright © 2016 Asta.Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarsWithDriverListController: UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (assign, nonatomic) NSNumber *categoryID;

@end
