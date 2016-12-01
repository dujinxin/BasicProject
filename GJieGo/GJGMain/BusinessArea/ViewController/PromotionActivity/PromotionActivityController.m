//
//  PromotionActivityController.m
//  GJieGo
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 品牌活动 新品到店 ---

#import "PromotionActivityController.h"
#import "GJGSelectorBar.h"
#import "PromotionActivityCollectionCell.h"
#import "PromotionDetailController.h"
#import "HotPushMallModel.h"
#import "RunTypeMallModel.h"
#import "SGDateUtil.h"

@interface PromotionActivityController ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    UIView *statusBackView;
    NSMutableArray *collectionArray;
    
    NSInteger selectViewHeight;     //分类选择框高度
    NSInteger once;
    NSInteger page;
    
    NSMutableArray *classArray;     //选择分类数组
    NSInteger classId;              //分类id
}
@property (nonatomic, strong)GJGSelectorBar *topSelectView;
@property (nonatomic, strong)UICollectionView *brandCollectionView;
@end

@implementation PromotionActivityController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundColor:COLOR(254, 227, 48, 1)];
    [self.navigationController.navigationBar addSubview:statusBackView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [statusBackView removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated{
    if (once == 0)      [self.brandCollectionView.mj_header beginRefreshing];
    once ++;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    
    once = 0;
    page = 1;
    if (self.sourceArray.count > 0) {
        classId = [self.sourceArray[0][@"DicID"] integerValue];
    }
    
    collectionArray = [NSMutableArray array];
    classArray = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *nilArray = @[];
    
    if (_sourceArray.count > 0) {
        for (int i = 0; i < self.sourceArray.count; i++) {
            RunTypeMallItem *item = [[RunTypeMallItem alloc] initWithDic:self.sourceArray[i]];
            [classArray addObject:item.DicName];
        }
    }
    
    self.topSelectView = [GJGSelectorBar selectorBarWithClassificaitons:classArray types:nilArray selectedBlock:^(NSString *classification, NSString *distance) {
        NSLog(@"selected %@ %@", classification, distance);
        for (NSDictionary *dic in _sourceArray) {
            if ([classification isEqualToString:dic[@"DicName"]]) {
                classId = [dic[@"DicID"] integerValue];
                [_brandCollectionView.mj_header beginRefreshing];
            }
        }
        
    }];
    
    self.topSelectView.classificationLabel.text = @"分类";
    self.topSelectView.rightIndicImgView.hidden = YES;
    [self.view addSubview:self.topSelectView];
    
    self.sourceArray.count > 0 ? (selectViewHeight = 44) : (selectViewHeight = 0);
    [self.topSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(0);
        make.top.equalTo(64);
        make.width.equalTo(ScreenWidth);
        make.height.equalTo(selectViewHeight);
    }];
    [self creatCollectionUI];
    
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (velocity.y != 0) {
        [self.topSelectView hiddenSelectView];
    }
    
}

- (void)creatCollectionUI{
    NSInteger h = 0;
    selectViewHeight == 44 ? (h = 5) : (h = 0);
    self.brandCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, (64 + h + selectViewHeight), ScreenWidth, (ScreenHeight - 64 - selectViewHeight - h)) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.brandCollectionView.dataSource = self;
    self.brandCollectionView.delegate = self;
    self.brandCollectionView.backgroundColor = GJGRGB16Color(0xf1f1f1);
    [self.view addSubview:self.brandCollectionView];
    [self.brandCollectionView registerClass:[PromotionActivityCollectionCell class] forCellWithReuseIdentifier:@"PromotionActivityCollectionCell"];
    self.brandCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self updateData];
    }];
    self.brandCollectionView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        
        [self updateMoreData];
    }];
}

#pragma loadData
- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *requestStr = kGet_HotPushShop;
    if ([self.vcClass isEqualToString:@"shop"]) {
        requestStr = kGet_HotPushShop;
        [param addEntriesFromDictionary:@{@"shopId":_shopId, @"hType":_hType, @"Cp":[NSString stringWithFormat:@"%ld", (long)page]}];
    }else{
        requestStr = kGet_HotPushMall;
        [param addEntriesFromDictionary:@{@"Mid":self.mId, @"iType":[NSString stringWithFormat:@"%ld", classId], @"HType":self.hType, @"Cp":[NSString stringWithFormat:@"%ld", page]}];
    }
    [request requestPostTypeWithUrl:kGJGRequestUrl(requestStr) parameters:param requestblock:^(id responseobject, NSError *error) {
        NSLog(@"responseobject  --  %@", responseobject);
        if ([responseobject[@"status"] integerValue] == 0) {
            if (page == 1) {
                collectionArray == nil ? (collectionArray = [NSMutableArray array]) : ([collectionArray removeAllObjects]);
                [_brandCollectionView.mj_header endRefreshing];
            }else{
                if ([responseobject[@"data"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:responseobject[@"data"]];
                    if (array.count < 20) {
                        [_brandCollectionView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [_brandCollectionView.mj_footer endRefreshing];
                    }
                }else{
                    [_brandCollectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            HotPushMallModel * hotModel = [[HotPushMallModel alloc] initWithDic:responseobject];
            if (hotModel.Data.count > 0) {
                for (int i = 0; i < hotModel.Data.count; i++) {
                    [collectionArray addObject:hotModel.Data[i]];
                }
            }
            [self.brandCollectionView reloadData];
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
    }];
}
#pragma mark - Update data

- (void)updateData {
    
    page = 1;
    [self loadData];

}

- (void)updateMoreData {
    
    page++;
    [self loadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return collectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"PromotionActivityCollectionCell";
    PromotionActivityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell sizeToFit];
    HotPushMallItem *item = [[HotPushMallItem alloc] initWithDic:collectionArray[indexPath.item]];
    [cell.tradeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%dW_1o", item.Images, (int)(ScreenWidth * 0.45)]] placeholderImage:[UIImage imageNamed:@"default_portrait_less"]];
    cell.ViewCountLabel.text = [NSString stringWithFormat:@"%ld", (long)item.ViewCount];
    cell.titleLabel.text = item.Name;
    cell.praiseLabel.text = [NSString stringWithFormat:@"%ld", (long)item.LikeNum];
    cell.timeLabel.text = [SGDateUtil getDateDayFromTimeStamp:[NSString stringWithFormat:@"%lf", [item.createDate doubleValue]]];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 3;
    cell.layer.masksToBounds = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HotPushMallItem * item = [[HotPushMallItem alloc] initWithDic:collectionArray[indexPath.row]];
#pragma mark -- 数据埋点
    
        [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201020070001
                                                        andBCID:self.bcId
                                                      andMallID:self.mId
                                                      andShopID:self.shopId
                                                    andItemType:self.hType
                                                andBusinessType:item.TypeKey
                                                      andItemID:[NSString stringWithFormat:@"%ld", (long)item.ID]
                                                    andItemText:nil
                                                    andOpUserID:[UserDBManager shareManager].UserID];
    
    PromotionDetailController *controller = [[PromotionDetailController alloc] init];
    controller.title = @"详情";
    controller.infoId = [NSString stringWithFormat:@"%ld", (long)item.ID];
    controller.bcId = self.bcId;
    controller.shopId = self.shopId;
    controller.mId = self.mId;
    controller.typeKey = item.TypeKey;
    controller.hType = self.hType;
    [self.navigationController pushViewController:controller animated:YES];
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(ScreenWidth * 0.45, (ScreenWidth * 0.7 - 10));//(ScreenWidth / 4 - 4 , ScreenWidth / 4 - 4);//
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5 , (ScreenWidth - ScreenWidth*2*0.45)/3, 5, (ScreenWidth - ScreenWidth*2*0.45)/3);
}
//定义每个UICollectionView 纵向的间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 10*(ScreenWidth/750);
//}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return (ScreenWidth - ScreenWidth*2*0.45)/3;
}
#pragma mark --UICollectionViewDelegate
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
