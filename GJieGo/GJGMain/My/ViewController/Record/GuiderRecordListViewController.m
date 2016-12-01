//
//  GuiderRecordListViewController.m
//  GJieGo
//
//  Created by dujinxin on 16/5/25.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "GuiderRecordListViewController.h"
#import "RecordGuiderCell.h"
#import "GuiderViewFlowLayout.h"
//#import "JZAlbumViewController.h"

@interface GuiderRecordListViewController ()<WaterFlowLayoutDelegate,UIGuiderViewCellDelegate>{
    NSDateFormatter * dateFormatter;
    NSString        * dateString;
}

@end

@implementation GuiderRecordListViewController

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
    self.urlStr = kApiCommentGuiderList;
    
    [[UserRequest shareManager] recordCommentGuiderList:self.urlStr param:@{@"page":@(self.page)} success:^(id object,NSString *msg) {
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
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//2016-07-08 16:44:37
    //[dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss aaa"];//2016-07-08 04:44:37 下午
    
    NSDate * date = [NSDate date];
    //dateString = [dateFormatter stringFromDate:date];
    dateString = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];

}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.view.backgroundColor = JXF1f1f1Color;
    
    GuiderViewFlowLayout * flowLayout = [[GuiderViewFlowLayout alloc ]init];
    flowLayout.delegate = self;
    flowLayout.columnCount = 1;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    flowLayout.minimumLineSpacing = 10.0;//行间距(最小值)
    flowLayout.minimumInteritemSpacing = 10.0;//item间距(最小值)
    flowLayout.itemSize = CGSizeMake((kScreenWidth -40)/2,76 +184*kPercent);//item的大小
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);//设置section的边距,默认(0,0,0,0)


    [_collectionView removeFromSuperview];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = JXF1f1f1Color;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[RecordGuiderCell class] forCellWithReuseIdentifier:cellIdentifier];

    [self.view addSubview:_collectionView];
    [_collectionView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refresh:self.page];
    }]];
    
    
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    
    
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecordGuiderCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    RecordGuiderEntity * entity = _dataArray[indexPath.item];
    [cell setRecordCellInfo:entity dateFormatter:dateFormatter dateString:dateString indexPath:indexPath];
    return cell;
}
#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RecordGuiderEntity * entity = _dataArray[indexPath.item];
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    ShopGuideDetailViewController *detailVC = [[ShopGuideDetailViewController alloc] init];
//    detailVC.infoid = entity.InfoId.integerValue;
//    detailVC.statisticChat = ID_0201080180004;
//    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)guiderViewCell:(RecordGuiderCell *)recordGuiderCell indexPath:(NSIndexPath *)indexPath index:(NSInteger)index{
//    RecordGuiderEntity * entity = _dataArray[indexPath.item];
//    NSArray * imageArray = [entity.Images componentsSeparatedByString:@","];
//    JZAlbumViewController *imgVC = [[JZAlbumViewController alloc] init];
//    imgVC.currentIndex = index;
//    imgVC.imgArr = imageArray;
//    [self presentViewController:imgVC animated:YES completion:nil];
}

- (CGFloat)waterFlow:(GuiderViewFlowLayout *)waterFlow itemWidth:(CGFloat)itemW cellIndexPath:(NSIndexPath *)indexPath{
    RecordGuiderEntity * entity = _dataArray[indexPath.item];
    CGFloat topHeight = 60;
    CGFloat centerHeight = 0;
    CGFloat bottomHeight = 29.5;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 7;
    //paragraphStyle.paragraphSpacing = 6;
    
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle};
    CGRect rect = [entity.Content boundingRectWithSize:CGSizeMake(kScreenWidth -30, 1000) options:option attributes:attributes context:nil];
    
    CGFloat imageHeight = 0;
    if ([entity.Images hasPrefix:@"http"]) {
        imageHeight = 110 *kPercent +10;
    }
    centerHeight = imageHeight + rect.size.height +10 *2;
    return centerHeight + topHeight +bottomHeight ;
}
#pragma mark - RefreshAndLoadMore
- (void)refresh:(NSInteger)page{
    [super refresh:page];
    [[UserRequest shareManager] recordCommentGuiderList:self.urlStr param:@{@"page":@(self.page)} success:^(id object,NSString *msg) {
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
    [[UserRequest shareManager] recordCommentGuiderList:self.urlStr param:@{@"page":@(self.page)} success:^(id object,NSString *msg) {
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
@end
