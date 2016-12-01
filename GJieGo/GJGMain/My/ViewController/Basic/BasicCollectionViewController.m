//
//  BasicCollectionViewController.m
//  GJieGo
//
//  Created by dujinxin on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicCollectionViewController.h"

@interface BasicCollectionViewController ()

@end

@implementation BasicCollectionViewController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad{
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)dealloc{
    
}
- (void)loadView{
    [super loadView];
    _page = 1;
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 10.0;
    flowLayout.minimumInteritemSpacing = 10.0;
    flowLayout.itemSize = CGSizeMake(kScreenWidth,130);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = JXF1f1f1Color;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:_collectionView];
    
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.and.bottom.equalTo(self.view);
    }];

}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}
//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    NSString *reuseIdentifier;
//    if ([kind isEqualToString: UICollectionElementKindSectionHeader ]){
//        reuseIdentifier = headerIdentifier;
//    }else{
//        reuseIdentifier = footerIdentifier;
//    }
//
//    UICollectionReusableView *headView =  [collectionView dequeueReusableSupplementaryViewOfKind :UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
//
//    }
//    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
//
//    }
//    return headView;
//}
#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击：%ld",(long)indexPath.item);
}
#pragma mark - RefreshAndLoadMore
- (void)refresh:(NSInteger)page{
    _page = 1;
}
- (void)loadMore:(NSInteger)page{
    _page ++;
}
- (void)endRefresh{
    [_collectionView.mj_header endRefreshing];
    [_collectionView.mj_footer endRefreshing];
}

@end
