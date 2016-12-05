//
//  CollectionListViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/29.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "CollectionListViewController.h"


#import "CollectionViewCell.h"
#import "JXSelectView.h"
#import "CollectionDropView.h"

@interface CollectionListViewController ()<CollectionDropViewDelegate,CollectionDropViewDataSource>{
    CollectionDropView   *  _dropListView;
    NSArray              *  _sortArray;
    NSMutableArray       *  _categoryAarry;
    NSString             *  _categoryType;
}

@end

@implementation CollectionListViewController

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

    _categoryType = @"";
    _sortType = SortDistanceType;
    _sortArray = @[@"离我最近",@"收藏最多"];
    self.urlStr = kApiShopCollectionList;
    
    [[UserRequest shareManager] shopCollectionCategory:kApiShopCollectionCategory param:nil success:^(id object,NSString *msg) {
        //
        _categoryAarry = [NSMutableArray arrayWithArray:(NSArray *)object];
        CategoryEntity * entity = _categoryAarry.firstObject;
        _categoryType = entity.DicID;
        if (!_categoryType) {
            [self showNoticeMessage:@"分类筛选id没有获取到"];
            return ;
        }
        [[UserRequest shareManager] shopCollectionList:self.urlStr param:@{@"Cp":@(self.page),@"Ot":@(self.sortType),@"Type":_categoryType} success:^(id object,NSString *msg) {
            //
            [_dataArray addObjectsFromArray:(NSArray *)object];
            [_collectionView reloadData];
            if (_dataArray.count >=10){
                MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [self loadMore:self.page];
                }];
                _collectionView.mj_footer = footer;
            }
        } failure:^(id object,NSString *msg) {
            //
        }];
    } failure:^(id object,NSString *msg) {
        //
    }];

}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.navigationItem.title = @"收藏的店铺";
    
    
    _dropListView = [[CollectionDropView alloc]initWithFrame:CGRectMake(0, kNavStatusHeight, kScreenWidth, 44) delegate:self buttonTitles:@[@"分类",@"离我最近"]];
    _dropListView.animation = DropListAnimationOptionChange;
    [self.view addSubview:_dropListView];
    
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [_collectionView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dropListView.bottom);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    [_collectionView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refresh:self.page];
    }]];
}
#pragma mark - JXDropListViewDelegate
-(void)dropListView:(CollectionDropView *)dropListView didSelectTab:(UIButton *)button index:(NSInteger)index{
    switch (index) {
        case 0:
            break;
        case 1:{
            
        }
            break;

    }
}
-(void)dropListView:(CollectionDropView *)dropListView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (dropListView.selectTab == 0) {
        CategoryEntity * entity = _categoryAarry[indexPath.row];
        _categoryType = entity.DicID;
        for (UIView * view in dropListView.topBarView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton * btn = (UIButton *)view;
                [btn setTitleColor:JX999999Color forState:UIControlStateNormal];
                [btn setImage:JXImageNamed(@"tab_cbb_down_default") forState:UIControlStateNormal];
                [btn setSelected:NO];
                
                if (btn.tag == kTopBarItemTag && dropListView.selectItem >=0){
                    [btn setTitle:entity.DicName forState:UIControlStateNormal];
                    CGFloat titleWidth = btn.currentTitle.length * 15 +2.5;
                    CGFloat imageWidth = 15 +2.5;
                    btn.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
                    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
                }
            }
        }
    }else if (dropListView.selectTab == 1){
        _sortType = (SortType)(indexPath.row +1);
    }
    [self refresh:self.page];
}

#pragma mark - JXDropListViewDataSource
- (DropListStyle)dropListView:(CollectionDropView *)dropListView styleForItemIndex:(NSInteger)index{
    if (index == 0) {
        return DropListCollection;
    }else{
        return DropListTable;
    }
}
-(NSInteger)dropListView:(CollectionDropView *)dropListView numberOfRowsInFirstView:(UIView *)view inSection:(NSInteger)section{
    if (dropListView.selectTab == 0) {
        return _categoryAarry.count;
    }else if (dropListView.selectTab == 1){
        return _sortArray.count;
    }
    return 0;
}

-(NSString *)dropListView:(CollectionDropView *)dropListView contentForRow:(NSInteger)row section:(NSInteger)section inView:(UIView *)view{
    if (dropListView.selectTab == 0) {
        CategoryEntity * entity = _categoryAarry[row];
        return entity.DicName;
    }else if (dropListView.selectTab == 1){
        return _sortArray[row];
    }
    return nil;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    CollectionEntity * entity = _dataArray[indexPath.item];
    [cell setCollectionCellInfo:entity indexPath:indexPath];
    return cell;
}
#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CollectionEntity * entity = _dataArray[indexPath.item];
//    if ([entity.TypeKey isEqualToString:@"supermarket"]) {//超市    ②③
//        GeneralMarketController *controller = [[GeneralMarketController alloc] init];
//        //        controller.title = item.ShopName;
//        controller.shopId = entity.ShopID;
//        [self.navigationController pushViewController:controller animated:YES];
//    }
}
#pragma mark - RefreshAndLoadMore
- (void)refresh:(NSInteger)page{
    [super refresh:page];
    [[UserRequest shareManager] shopCollectionList:kApiShopCollectionList param:@{@"Cp":@(self.page),@"Ot":@(self.sortType),@"Type":_categoryType} success:^(id object,NSString *msg) {
        [self endRefresh];
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_collectionView reloadData];
        
    } failure:^(id object,NSString *msg) {
        [self endRefresh];
    }];
    
}
- (void)loadMore:(NSInteger)page{
    [super loadMore:page];
    [[UserRequest shareManager] shopCollectionList:kApiShopCollectionList param:@{@"Cp":@(self.page),@"Ot":@(self.sortType),@"Type":_categoryType} success:^(id object,NSString *msg) {
        [self endRefresh];
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_collectionView reloadData];
        
    } failure:^(id object,NSString *msg) {
        [self endRefresh];
    }];
}
@end
