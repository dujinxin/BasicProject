//
//  UserRecordListViewController.m
//  GJieGo
//
//  Created by dujinxin on 16/5/25.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "UserRecordListViewController.h"
#import "RecordEntity.h"

@interface UserRecordListViewController (){
    NSIndexPath * _indexPath;
}

@end

@implementation UserRecordListViewController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    //[super viewWillAppear:animated];
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
    if (_recordType == RecordDistributionType) {
        self.urlStr = kApiDistrubutionList;
        //height = kScreenHeight - kNavStatusHeight;
        //itemSize = CGSizeMake((kScreenWidth -40)/2,76 +184*kPercent);
    }else{
        self.urlStr = kApiCommentUserList;
        //height = kScreenHeight - kNavStatusHeight -35;
        //itemSize = CGSizeMake((kScreenWidth -40)/2,95 +184*kPercent);
    }
    
    [[UserRequest shareManager] recordDistrubutionCommentUserList:self.urlStr param:@{@"page":@(self.page)} success:^(id object,NSString *msg) {
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
    
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.view.backgroundColor = JXF1f1f1Color;

    CGFloat height;
    CGSize itemSize;
    if (_recordType == RecordDistributionType) {
        height = kScreenHeight - kNavStatusHeight;
        itemSize = CGSizeMake((kScreenWidth -40)/2,76 +184*kPercent);
    }else{
        height = kScreenHeight - kNavStatusHeight -35;
        itemSize = CGSizeMake((kScreenWidth -40)/2,76 +32 +184*kPercent);
    }
    
    UICollectionViewFlowLayout * flowLayout= [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 10.0;
    flowLayout.minimumInteritemSpacing = 10.0;
    flowLayout.itemSize = itemSize;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);

    [_collectionView removeFromSuperview];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, height) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = JXF1f1f1Color;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[RecordViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:_collectionView];
    [_collectionView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refresh:self.page];
    }]];

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecordViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.type = _recordType;
    cell.isEditStyle = _isEditStyle;
    cell.block = ^(NSIndexPath *indexPath){
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"您确定要删除此条晒单记录吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * pictureAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"删除");
            RecordEntity * entity = _dataArray[indexPath.item];
            [DJXRequest requestWithBlock:kApiDistrubutionDelete param:@{@"infoId":entity.Id} success:^(id object,NSString *msg) {
                [self showNoticeMessage:object];
                [_dataArray removeObjectAtIndex:indexPath.item];
                [self reloadData];
            } failure:^(id object,NSString *msg) {
                [self showNoticeMessage:msg];
            }];
        }];
        [alertVC addAction:pictureAction];
        [alertVC addAction:cancelAction];

        [pictureAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
        [cancelAction setValue:JXTextColor forKey:@"_titleTextColor"];
        
        [self presentViewController:alertVC animated:YES completion:^{}];
    };
    RecordEntity * entity = _dataArray[indexPath.item];
    [cell setRecordCellInfo:entity indexPath:indexPath];
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    RecordEntity * entity = _dataArray[indexPath.item];
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    SharedOrderDetailViewController *detailVC = [[SharedOrderDetailViewController alloc] init];
//    detailVC.infoId = entity.Id.integerValue;
//    [self.navigationController pushViewController:detailVC animated:YES];
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
#pragma mark - RefreshAndLoadMore
- (void)refresh:(NSInteger)page{
    [super refresh:page];
    [[UserRequest shareManager] recordDistrubutionCommentUserList:self.urlStr param:@{@"page":@(self.page)} success:^(id object,NSString *msg) {
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
    [[UserRequest shareManager] recordDistrubutionCommentUserList:self.urlStr param:@{@"page":@(self.page)} success:^(id object,NSString *msg) {
        [self endRefresh];
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_collectionView reloadData];
        
    } failure:^(id object,NSString *msg) {
        [self endRefresh];
    }];
}
- (void)endRefresh{
    [_collectionView.mj_header endRefreshing];
    [_collectionView.mj_footer endRefreshing];
}
#pragma mark - Basic
- (void)reloadData{
    [_collectionView reloadData];
}
@end
