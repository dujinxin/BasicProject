//
//  SharedOrderViewController.m
//  GJieGo
//
//  Created by liubei on 16/5/4.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "SharedOrderViewController.h"
#import "SharedOrderDetailViewController.h"
#import "ShareViewController.h"
#import "SharedOrderInMainCell.h"
#import "LBSharedOrderM.h"

@interface SharedOrderViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource> {
    
    UICollectionView *collectionView;
    UIButton *shareBtn;
    
    NSInteger page;
}

@property (nonatomic, strong) NSMutableArray<LBSharedOrderM *> *sharedOrderDataSource;

@end

@implementation SharedOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAttributs];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (_sharedOrderDataSource == nil) [collectionView.mj_header beginRefreshing];
}


#pragma mark - Getting

- (NSMutableArray *)sharedOrderDataSource {
    
    if (!_sharedOrderDataSource) {
        
        _sharedOrderDataSource = [NSMutableArray array];
    }
    return _sharedOrderDataSource;
}


#pragma mark - Init

- (void)initAttributs {
    
    self.view.backgroundColor = [UIColor clearColor];
    page = 1;
}

- (void)createUI {
    
    [self createCollectionView];
    [self createShareBtn];
}

- (void)createCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [collectionView registerClass:[SharedOrderInMainCell class]
       forCellWithReuseIdentifier:@"SharedOrderInMainCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.and.right.equalTo(self.view).with.offset(0);
    }];
    
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self updateData];
    }];
    collectionView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
    
        [self updateMoreData];
    }];
}

- (void)createShareBtn {
    
    shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareBtn.layer.contentsScale = [UIScreen mainScreen].scale;
    [shareBtn.imageView setContentMode:UIViewContentModeScaleToFill];
    [shareBtn setImage:[[UIImage imageNamed:@"release"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
              forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.and.height.equalTo(@51);
        make.right.equalTo(self.view.mas_right).with.offset(@(-25));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(@(-84));
    }];
}


#pragma mark - Update data

- (void)updateData {
    
    [collectionView.mj_footer endRefreshing];
    
    [DJXRequest requestWithBlock:kApiGetUserShows
                           param:@{@"cityId" : [NSNumber numberWithInteger:[GJGLocationManager sharedManager].cityID],
                                   @"page"   : @1}
                         success:^(id object,NSString *msg)
    {
        [collectionView.mj_header endRefreshing];
        page = 2;
        if ([object isKindOfClass:[NSArray class]]) {
            [self.sharedOrderDataSource removeAllObjects];
            [self.sharedOrderDataSource addObjectsFromArray:[LBSharedOrderM objectsWithArray:object]];
            [collectionView reloadData];
            if (((NSArray *)object).count < 20) {
                [collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(id object,NSString *msg) {
        [collectionView.mj_header endRefreshing];
        if ([msg isKindOfClass:[NSString class]]) {
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (void)updateMoreData {
    
    [DJXRequest requestWithBlock:kApiGetUserShows
                           param:@{@"cityId" : [NSNumber numberWithInteger:[GJGLocationManager sharedManager].cityID],
                                   @"page"   : [NSNumber numberWithInteger:page]}
                         success:^(id object,NSString *msg)
    {
        [collectionView.mj_footer endRefreshing];
        if ([object isKindOfClass:[NSArray class]]) {
            page ++;
            [self.sharedOrderDataSource addObjectsFromArray:[LBSharedOrderM objectsWithArray:object]];
            [collectionView reloadData];
            if (((NSArray *)object).count < 20) {
                [collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(id object,NSString *msg) {
        [collectionView.mj_footer endRefreshing];
        if ([msg isKindOfClass:[NSString class]]) {
            [MBProgressHUD showError:object toView:self.view];
        }
    }];
}


#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return self.sharedOrderDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionV
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SharedOrderInMainCell *cell = [SharedOrderInMainCell cellWithCollectionView:collectionV
                                                                   andIndexPath:indexPath];
    cell.sharedOrderType = SharedOrderCellTypeIsMain;
    cell.sharedOrder = self.sharedOrderDataSource[indexPath.row];
    return cell;
    
}

#pragma mark - Collection view flow layout delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@" selected %lu shared order. ", indexPath.row);
    SharedOrderDetailViewController *detailVC = [[SharedOrderDetailViewController alloc] init];
    detailVC.infoId = self.sharedOrderDataSource[indexPath.row].Id;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    LBSharedOrderM *shareOrder = self.sharedOrderDataSource[indexPath.row];
    
    [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201050140001
                                                    andBCID:nil
                                                  andMallID:nil
                                                  andShopID:nil
                                            andBusinessType:nil
                                                  andItemID:[NSString stringWithFormat:@"%lu", shareOrder.Id]
                                                andItemText:nil
                                                andOpUserID:[NSString stringWithFormat:@"%lu", shareOrder.userM.UserId]];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    return [SharedOrderInMainCell getEdgeInsets];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [SharedOrderInMainCell getSizeWithType:SharedOrderCellTypeIsMain];
}


#pragma mark - Click event

- (void)shareClick:(UIButton *)button {
    
    [[LoginManager shareManager] checkUserLoginState:^{
        ShareViewController *shareVC = [[ShareViewController alloc] init];
        [self.navigationController pushViewController:shareVC animated:YES];
    }];
}

@end
