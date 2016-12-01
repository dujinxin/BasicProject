//
//  BasicCollectionViewController.h
//  GJieGo
//
//  Created by dujinxin on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicViewController.h"

static NSString  * const cellIdentifier   = @"Cell";
static NSString  * const headerIdentifier = @"Header";
static NSString  * const footerIdentifier = @"Footer";

@interface BasicCollectionViewController : BasicViewController<UICollectionViewDelegate,UICollectionViewDataSource>{
    UICollectionView *  _collectionView;
    NSInteger           _page;
    NSMutableArray   *  _dataArray;
}

@property (nonatomic, strong, readwrite) UICollectionView    * collectionView;
@property (nonatomic, strong, readwrite) NSMutableArray      * dataArray;
@property (nonatomic, assign, readwrite) NSInteger             page;

- (void)refresh:(NSInteger)page;
- (void)loadMore:(NSInteger)page;
- (void)endRefresh;
@end
