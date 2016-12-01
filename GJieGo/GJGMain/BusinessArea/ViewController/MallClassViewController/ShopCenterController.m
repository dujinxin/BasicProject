//
//  ShopCenterController.m
//  GJieGo
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 购物中心 和 百货商场 ---

#import "ShopCenterController.h"
#import "ShopingCenterDetailController.h"
#import "PromotionActivityController.h"     //品牌活动，新品到店
#import "BrandCouponController.h"           //品牌优惠券
#import "WifiFreePriceController.h"         //免费wifi
#import "GirlClothesListController.h"       //女装
#import "ShopGuideDetailViewController.h"   //最新发布
#import "MapOfMainViewController.h"         //地图

#import "GJGSelectorBar.h"
#import "GJGTopView.h"
#import "GJGSubTopView.h"
#import "GJGActivityClassView.h"
#import "GJGBusinessClassView.h"
#import "GJGBrandClassView.h"
#import "ShopGuideTableViewCell.h"

#import "MallHomeInfoModel.h"
#import "RunTypeMallModel.h"

#import "LBGuideInfoM.h"

#define topViewHeight 187


@interface ShopCenterController ()<UITableViewDelegate, UITableViewDataSource, GJGTopViewDelegate ,BrandClassViewDelegate, GJGActivityClassDelegate, GJGSubTopViewDelegate>{
    UIView *statusBackView;
    NSMutableArray *sourceArray;
    NSMutableArray *goodsClassArray;
    NSArray *arr1;
    NSArray *arr2;
    NSMutableArray *guideArray;
    
    UIView *_tabTopView;
    GJGTopView *_topView;
    GJGSubTopView *_subView;
    GJGActivityClassView * _activityClassView;
    GJGBrandClassView *_brandClassView;
    
    NSInteger businessClassViewHeight;      //男装、女装。。。
    NSInteger activityClassHeight;          //获取商场运营分类【新品到店、店长推荐】
    NSInteger subViewHeight;
    
    MallHomeInfoModel *_mallHomeInfoModel;
    MallHomeInfoItem *_mallHomeInfoItem;
    
    NSInteger page;
    NSInteger once;
    NSString * order;       //分类
    GJGSelectorBar * topSelectView;
    
}
@property (nonatomic, strong)BaseTableView *shopCenterTableView;

@end

@implementation ShopCenterController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = _mallHomeInfoItem.MallName;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundColor:COLOR(254, 227, 48, 1)];
    [self.navigationController.navigationBar addSubview:statusBackView];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [statusBackView removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated{
    if(once == 0)  [self.shopCenterTableView.mj_header beginRefreshing];
    once ++;
    [_shopCenterTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    businessClassViewHeight = 0;
    activityClassHeight = 0;
    subViewHeight = 0;
    once = 1;
    page = 1;
    order = @"1";
    
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    
    arr1 = [NSMutableArray array];
    arr2 = [NSMutableArray array];
    sourceArray = [NSMutableArray array];
    goodsClassArray = [NSMutableArray array];
    guideArray = [NSMutableArray array];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self creatTableView];
    [self creatUI];
    if (self.type == 1) {
        [self gainData];
    }else{
        [self gainOtherData];
    }
    
}

#pragma mark - 电器卖场 家具卖场 家具城 

- (void)gainOtherData{
    /*首页商场展示*/
    NSMutableDictionary *paramHome = [NSMutableDictionary dictionary];
    [paramHome addEntriesFromDictionary:@{@"Mid":_mId}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_MallHomeInfo) parameters:paramHome requestblock:^(id responseobject, NSError *error) {
        if ([responseobject[@"status"] integerValue] == 0) {
            _mallHomeInfoModel = [[MallHomeInfoModel alloc] initWithDic:responseobject];
            _mallHomeInfoItem = [[MallHomeInfoItem alloc] initWithDic:_mallHomeInfoModel.Data];
            self.title = _mallHomeInfoItem.MallName;
            [_topView removeAllSubviews];
            _topView.mallHomeInfoItem = _mallHomeInfoItem;
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
        _shopCenterTableView.tableHeaderView = _tabTopView;
    }];
    
    /*新品到店*/
    NSMutableDictionary *paramRunType = [NSMutableDictionary dictionary];
    [paramRunType addEntriesFromDictionary:@{@"Mid":_mId}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_RunTypeMall) parameters:paramRunType requestblock:^(id responseobject, NSError *error) {
        if ([responseobject[@"status"] integerValue] == 0) {
            RunTypeMallModel *runTypeMallModel2 = [[RunTypeMallModel alloc] initWithDic:responseobject];
            
            if (runTypeMallModel2.Data.count > 0) {
                arr2 = runTypeMallModel2.Data;
                if (ScreenWidth < 375) {
                    activityClassHeight = 86;
                }else{
                    if (ScreenWidth > 375) {
                        activityClassHeight = 106;
                    }else{
                        activityClassHeight = 96;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_activityClassView removeAllSubviews];
                    _activityClassView.sourceArray = runTypeMallModel2.Data;
                });
            }
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
        _shopCenterTableView.tableHeaderView = _tabTopView;
    }];
    
    /*获取商品分类*/
    NSMutableDictionary *paramShopClass = [NSMutableDictionary dictionary];
    [paramShopClass addEntriesFromDictionary:@{@"Mid":_mId}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_ProductTypeMall) parameters:paramShopClass requestblock:^(id responseobject, NSError *error) {
        if ([responseobject[@"status"] integerValue] == 0) {
            
            RunTypeMallModel *runTypeMallModel = [[RunTypeMallModel alloc] initWithDic:responseobject];
            if (runTypeMallModel.Data.count > 0) {
                sourceArray = runTypeMallModel.Data;
                [goodsClassArray removeAllObjects];
                for (NSDictionary *dic in sourceArray) {
                    if (![dic[@"DicName"] isEqualToString:@"全部"]) {
                        [goodsClassArray addObject:dic];
                    }
                }
                
                if (ScreenWidth < 375) {
//                    businessClassViewHeight = 140;
                    if (goodsClassArray.count < 11) {
                        businessClassViewHeight = 140;
                    }else{
                        businessClassViewHeight = 150;
                    }
                }else{
                    if (ScreenWidth > 375) {
                        if (goodsClassArray.count < 11) {
                            businessClassViewHeight = 190;
                        }else{
                            businessClassViewHeight = 200;
                        }
                    }else{
                        if (goodsClassArray.count < 11) {
                            businessClassViewHeight = 170;
                        }else{
                            businessClassViewHeight = 180;
                        }
                    }
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_brandClassView removeAllSubviews];
                    _brandClassView.sourceArray = goodsClassArray;
                });
                NSLog(@"%@", sourceArray);
            }
        }else{
           [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
        _shopCenterTableView.tableHeaderView = _tabTopView;
    }];
    
    [self loadMoreData];
}

- (void)gainData{
    /*首页商场展示*/
    NSMutableDictionary *paramHome = [NSMutableDictionary dictionary];
    [paramHome addEntriesFromDictionary:@{@"Mid":_mId}];
        [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_MallHomeInfo) parameters:paramHome requestblock:^(id responseobject, NSError *error) {
            if ([responseobject[@"status"] integerValue] == 0) {
                _mallHomeInfoModel = [[MallHomeInfoModel alloc] initWithDic:responseobject];
                _mallHomeInfoItem = [[MallHomeInfoItem alloc] initWithDic:_mallHomeInfoModel.Data];
                self.title = _mallHomeInfoItem.MallName;
                [_topView removeAllSubviews];
                _topView.mallHomeInfoItem = _mallHomeInfoItem;
            }else{
                [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
            }
        }];
    
    /*免费WiFi*/
    NSMutableDictionary *paramMallFunc = [NSMutableDictionary dictionary];
    [paramMallFunc addEntriesFromDictionary:@{@"Mid":_mId}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_MallFunc) parameters:paramMallFunc requestblock:^(id responseobject, NSError *error) {NSLog(@"mall-wifi =  %@", responseobject);
        if ([responseobject[@"status"] integerValue] == 0) {
            RunTypeMallModel *runTypeMallModel = [[RunTypeMallModel alloc] initWithDic:responseobject];
            
            if (runTypeMallModel.Data.count > 0) {
                arr1 = runTypeMallModel.Data;
                
                if (ScreenWidth < 375) {
                    subViewHeight = 85;
                }else{
                    if (ScreenWidth > 375) {
                        subViewHeight = 95;
                    }else{
                        subViewHeight = 95;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_subView removeAllSubviews];
                    _subView.sourceArray = runTypeMallModel.Data;
                });
            }
        }else{
            NSLog(@"数据返回----------失败");
        }
        _shopCenterTableView.tableHeaderView = _tabTopView;
    }];

    /*新品到店*/
    NSMutableDictionary *paramRunType = [NSMutableDictionary dictionary];
    [paramRunType addEntriesFromDictionary:@{@"Mid":_mId}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_RunTypeMall) parameters:paramRunType requestblock:^(id responseobject, NSError *error) {
        if ([responseobject[@"status"] integerValue] == 0) {
            RunTypeMallModel *runTypeMallModel2 = [[RunTypeMallModel alloc] initWithDic:responseobject];
            
            if (runTypeMallModel2.Data.count > 0) {
                arr2 = runTypeMallModel2.Data;
                if (ScreenWidth < 375) {
                    activityClassHeight = 86;
                }else{
                    if (ScreenWidth > 375) {
                        activityClassHeight = 106;
                    }else{
                        activityClassHeight = 96;
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_activityClassView removeAllSubviews];
                    _activityClassView.sourceArray = runTypeMallModel2.Data;
                });
            }else{
                
            }
        }else{
            NSLog(@"数据返回----------失败");
        }
        _shopCenterTableView.tableHeaderView = _tabTopView;
    }];
    
    /*获取商品分类*/
    NSMutableDictionary *paramShopClass = [NSMutableDictionary dictionary];
    [paramShopClass addEntriesFromDictionary:@{@"Mid":_mId}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_ProductTypeMall) parameters:paramShopClass requestblock:^(id responseobject, NSError *error) {
        if ([responseobject[@"status"] integerValue] == 0) {
            
            RunTypeMallModel *runTypeMallModel = [[RunTypeMallModel alloc] initWithDic:responseobject];
            if (runTypeMallModel.Data.count > 0) {
                sourceArray = runTypeMallModel.Data;
                [goodsClassArray removeAllObjects];
                for (NSDictionary *dic in sourceArray) {
                    if (![dic[@"DicName"] isEqualToString:@"全部"]) {
                        [goodsClassArray addObject:dic];
                    }
                }
                if (ScreenWidth < 375) {
//                    businessClassViewHeight = 140;
                    if (goodsClassArray.count < 11) {
                        businessClassViewHeight = 140;
                    }else{
                        businessClassViewHeight = 150;
                    }
                }else{
                    if (ScreenWidth > 375) {
                        if (goodsClassArray.count < 11) {
                            businessClassViewHeight = 180;
                        }else{
                            businessClassViewHeight = 190;
                        }
                    }else{
                        if (goodsClassArray.count < 11) {
                            businessClassViewHeight = 160;
                        }else{
                            businessClassViewHeight = 170;
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_brandClassView removeAllSubviews];
                    _brandClassView.sourceArray = goodsClassArray;
                });
                NSLog(@"%@", sourceArray);
            }else{
                
            }
        }else{
            NSLog(@"数据返回----------失败");
        }
        _shopCenterTableView.tableHeaderView = _tabTopView;
    }];
    
    [self loadMoreData];
}

- (void)loadMoreData{
    //加载最新发布信息
    NSMutableDictionary *paramRunType = [NSMutableDictionary dictionary];
    [paramRunType addEntriesFromDictionary:@{@"mallId":_mId, @"page":[NSString stringWithFormat:@"%ld",(long)page], @"order":order}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_promotionsMall) parameters:paramRunType requestblock:^(id responseobject, NSError *error) {
//        [topSelectView setHidden:NO];
        NSLog(@"%@%@%@", self.title, @"----最新发布信息----", responseobject);
        if ([responseobject[@"status"] integerValue] == 0) {
            
            if (page == 1) {
                
                [_shopCenterTableView.mj_header endRefreshing];
            }else{
                if ([responseobject[@"data"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:responseobject[@"data"]];
                    if (array.count < 10) {
                        [_shopCenterTableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [_shopCenterTableView.mj_footer endRefreshing];
                    }
                }else{
                    [_shopCenterTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            if ([responseobject[@"data"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:responseobject[@"data"]];
                if ( page == 1) {
                    guideArray == nil ? (guideArray = [NSMutableArray array]) : ([guideArray removeAllObjects]);
                }
                if (array.count > 0) {
                    for (int i = 0; i < array.count; i ++) {
                        LBGuideInfoM * model = [[LBGuideInfoM alloc] initWithDict:array[i]];
                        [guideArray addObject:model];
                    }
                }
            }
            [_shopCenterTableView reloadData];
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
        [topSelectView setHidden:NO];
    }];
}

#pragma mark - 选择分类刷新 Update data
- (void)updatePublishData{
    page = 1;
    [self loadMoreData];
}
#pragma mark - 下拉刷新
- (void)updateData {
    
    page = 1;
    
    if (self.type == 1) {
        [self gainData];
    }else{
        [self gainOtherData];
    }
}

- (void)updateMoreData {
    
    page++;
    [self loadMoreData];
}


- (void)creatUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 50, 50)];//rightView.backgroundColor = [UIColor whiteColor];
    UIImage *shareImage = [UIImage imageNamed:@"title_btn_share"];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom tag:0 title:nil titleSize:0 frame:CGRectMake(15, 0, 50, 50) Image:shareImage target:self action:@selector(didClickShareButton:)];
    [rightView addSubview:shareButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    _tabTopView = [[UIView alloc] initWithFrame:CGRectZero];
    _tabTopView.backgroundColor = [UIColor whiteColor];
    _shopCenterTableView.tableHeaderView = _tabTopView;

    /*商场首页信息*/
    _topView = [[GJGTopView alloc] initWithFrame:CGRectZero];
    _topView.delegate = self;
    [_tabTopView addSubview:_topView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToShopDetail)];
    [_topView addGestureRecognizer:tap];
    
    if (topSelectView == nil) {
        NSArray *classArray = @[@{@"DicName":@"最新发布", @"DicID":@"1"},
                                @{@"DicName":@"点赞最多", @"DicID":@"3"},
                                @{@"DicName":@"评论最多", @"DicID":@"4"}];
        NSArray *array = @[@"最新发布", @"点赞最多", @"评论最多"];
        NSArray *nilArray = @[];
        topSelectView = [GJGSelectorBar selectorBarWithClassificaitons:array types:nilArray selectedBlock:^(NSString *classification, NSString *distance) {
            NSLog(@"selected %@ %@", classification, distance);
            for (NSDictionary *dic in classArray) {
                if ([classification isEqualToString:dic[@"DicName"]]) {
                    order = dic[@"DicID"];
                    [self updatePublishData];
                }
            }
        }];
        topSelectView.classificationLabel.text = @"分类";
        topSelectView.rightIndicImgView.hidden = YES;
        topSelectView.backgroundColor = [UIColor whiteColor];
        [topSelectView setHidden:YES];
    }
    [_tabTopView addSubview:topSelectView];
    
    /*获取商场功能【WiFi】*/
    _subView = [[GJGSubTopView alloc] initWithFrame:CGRectZero];
    [_tabTopView addSubview:_subView];
    _subView.clipsToBounds = YES;
    _subView.delegate = self;
    
    /*获取商场运营分类【新品到店、店长推荐】*/
    _activityClassView = [[GJGActivityClassView alloc] initWithFrame:CGRectZero];
    [_tabTopView addSubview:_activityClassView];
    _activityClassView.clipsToBounds = YES;
    _activityClassView.activityDelegate = self;

    /*获取商场商品分类【男装、女装】*/
    _brandClassView = [[GJGBrandClassView alloc] initWithFrame:CGRectZero];
    [_tabTopView addSubview:_brandClassView];
    _brandClassView.clipsToBounds = YES;
    _brandClassView.delegate = self;
}

#pragma mark - 重新布局
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [_topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_tabTopView);
        make.top.equalTo(_tabTopView);
        make.trailing.equalTo(_tabTopView);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, topViewHeight));
    }];

    [_subView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_topView);
        make.top.equalTo(_topView.bottom);
        make.size.equalTo(CGSizeMake(ScreenWidth, subViewHeight));
    }];
    [_activityClassView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.top.equalTo(_subView.bottom);
        make.size.equalTo(CGSizeMake(ScreenWidth, activityClassHeight));
    }];
    [_brandClassView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.top.equalTo(_activityClassView.bottom).offset(10);
        make.size.equalTo(CGSizeMake(ScreenWidth, businessClassViewHeight));
    }];
    [topSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_topView);
        make.top.equalTo(_brandClassView.bottom);
        make.size.equalTo(CGSizeMake(ScreenWidth, 40));
    }];
    _tabTopView.frame = CGRectMake(0, 0, ScreenWidth, topViewHeight + subViewHeight + activityClassHeight + businessClassViewHeight + 50);
}

#pragma creatTableView
- (void)creatTableView{
    _shopCenterTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    _shopCenterTableView.delegate = self;
    _shopCenterTableView.dataSource = self;
    _shopCenterTableView.backgroundColor = GJGRGB16Color(0xf1f1f1);
    _shopCenterTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_shopCenterTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopGuideTableViewCell class])
                                                     bundle:nil]
               forCellReuseIdentifier:@"ShopGuideTableViewCell"];
    _shopCenterTableView.rowHeight = UITableViewAutomaticDimension;
    _shopCenterTableView.estimatedRowHeight = 44.f;
    [self.view addSubview:_shopCenterTableView];
    self.shopCenterTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self updateData];
    }];
    self.shopCenterTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        
        [self updateMoreData];
    }];
}

#pragma mark - clickMap
- (void)clickMapButtonAction:(UIButton *)button{
    MapOfMainViewController *mapVC = [[MapOfMainViewController alloc] init];
    mapVC.shopName = _mallHomeInfoItem.MallName;
    mapVC.shopAddress = _mallHomeInfoItem.MallAddress;
    mapVC.shopLocation = [[CLLocation alloc] initWithLatitude:_mallHomeInfoItem.Latitude longitude:_mallHomeInfoItem.Longitude];
    
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark - topViewTap - Action
- (void)tapToShopDetail{
    ShopingCenterDetailController *controller = [[ShopingCenterDetailController alloc] init];
    controller.mallId = _mId;
    controller.vcClass = @"mall";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 商品分类 - 男装，女装等
- (void)clickBrandClassButton:(UIButton *)button{
    NSLog(@"%@",button.titleLabel.text);
    GirlClothesListController *controller = [[GirlClothesListController alloc] init];
    controller.title = button.titleLabel.text;
    RunTypeMallItem *item = [[RunTypeMallItem alloc] initWithDic:goodsClassArray[button.tag - 1000]];
    controller.mId = [NSString stringWithFormat:@"%lu", item.MallID];
    controller.type = [NSString stringWithFormat:@"%ld", item.DicID];
    controller.bcId = self.bcId;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - wifi - action
- (void)clickSubTopButtonAction:(UIButton *)button{
    RunTypeMallItem * item = [[RunTypeMallItem alloc] initWithDic:arr1[button.tag - 2000]];
    if([item.DicKey isEqualToString:@"wifi"]){
        WifiFreePriceController *controller = [[WifiFreePriceController alloc] init];
        controller.shopId = @"";
        controller.mallId = _mId;
        controller.Type = @"2";
        controller.title = button.titleLabel.text;
        [self.navigationController pushViewController:controller animated:YES];
    }else{

    }
}

#pragma mark - 自运营分类如：新品到店
- (void)didClickActivityButton:(UIButton *)button{
    RunTypeMallItem *item = [[RunTypeMallItem alloc] initWithDic:arr2[button.tag - 2500]];
    NSString * dicKey = [item.DicKey componentsSeparatedByString:@"_"][0];
    if([dicKey isEqualToString:@"rtbrandcoupon"]){
        
        /*品牌优惠券*/
        BrandCouponController *controller = [[BrandCouponController alloc] init];
        controller.title = button.titleLabel.text;
        controller.sourceArray = sourceArray;
        controller.mId = _mId;
        controller.type = [NSString stringWithFormat:@"%ld", item.DicID];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        
        /*新品到店*/
        PromotionActivityController *controller = [[PromotionActivityController alloc] init];
        controller.title = button.titleLabel.text;
        controller.mId = _mId;
        controller.hType = [NSString stringWithFormat:@"%ld", item.DicID];
        controller.sourceArray = sourceArray;
        controller.vcClass = @"mall";
        controller.bcId = self.bcId;
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark - shar
- (void)didClickShareButton:(UIButton *)button{
    
    __block NSString *infoId = [NSString stringWithFormat:@"%ld", _mallHomeInfoItem.MallID];
    [[LoginManager shareManager] checkUserLoginState:^{
        [[LBRequestManager sharedManager] getSharedInfoWithInfoId:_mallHomeInfoItem.MallID
                                                         infoType:GJGShareInfoTypeIsMallHome
                                                           result:^(id responseobject, NSError *error)
         {
             if (!error) {
                 GJGShareInfo *shareInfo = responseobject;
                 [[ShareManager shareManager] showCustomShareViewWithContent:shareInfo.Content
                                                                       title:shareInfo.Title
                                                                    imageUrl:shareInfo.Images
                                                                         url:shareInfo.Url
                                                                 description:@""
                                                                      infoId:infoId
                                                                   shareType:UserSuperMarketShareType
                                                         presentedController:self
                                                                     success:^(id object, UserShareSns sns)
                  {  // 分享成功, 触发数据埋点
                      [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201010050004
                                                                      andBCID:self.bcId
                                                                    andMallID:_mId
                                                                    andShopID:nil
                                                              andBusinessType:self.typeKey
                                                                    andItemID:nil
                                                                  andItemText:nil
                                                                  andOpUserID:[UserDBManager shareManager].UserID];
                  } failure:^(id object, UserShareSns sns) {
                      NSLog(@"分享失败.");
                  }];
//                 [[ShareManager shareManager] showCustomShareViewWithContent:shareInfo.Content
//                                                                       title:shareInfo.Title
//                                                                    imageUrl:shareInfo.Images
//                                                                         url:shareInfo.Url
//                                                                 description:@""
//                                                         presentedController:self
//                                                                     success:^(id object, UserShareSns sns)
//                  {
//                      [request requestPostTypeWithUrl:kGJGRequestUrl(kApiShareSuccess) parameters:@{@"InfoId":infoId, @"infoType":@"10", @"ShareTo":[NSString stringWithFormat:@"%ld", (long)sns]} requestblock:^(id responseobject, NSError *error) {
//                          [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
//                      }];
//                  } failure:^(id object, UserShareSns sns){
//
//                  }];
             }
         }];
    }];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    NSLog(@"---------%f", translation.y);
    if (translation.y > 0) {
        
        [topSelectView hiddenSelectView];
    }else if(translation.y < 0){
        [topSelectView hiddenSelectView];
    }
}

#pragma mark - table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//     return 40;
//    
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    if (topSelectView == nil) {
//        NSArray *classArray = @[@{@"DicName":@"最新发布", @"DicID":@"1"},
//                                @{@"DicName":@"点赞最多", @"DicID":@"3"},
//                                @{@"DicName":@"评论最多", @"DicID":@"4"}];
//        NSArray *array = @[@"最新发布", @"点赞最多", @"评论最多"];
//        NSArray *nilArray = @[];
//        topSelectView = [GJGSelectorBar selectorBarWithClassificaitons:array types:nilArray selectedBlock:^(NSString *classification, NSString *distance) {
//            NSLog(@"selected %@ %@", classification, distance);
//            for (NSDictionary *dic in classArray) {
//                if ([classification isEqualToString:dic[@"DicName"]]) {
//                    order = dic[@"DicID"];
//                    [self updatePublishData];
//                }
//            }
//        }];
//        topSelectView.classificationLabel.text = @"分类";
//        [topSelectView setHidden:YES];
//    }
//    return topSelectView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return guideArray.count ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        ShopGuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopGuideTableViewCell"];
        cell.type = ShopGuideCellTypeIsInBusinessArea;
        cell.guideInfo = guideArray[indexPath.row];
    NSLog(@"----========------%@", guideArray[indexPath.row]);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    LBGuideInfoM * model = guideArray[indexPath.row];
    
    [[GJGStatisticManager sharedManager] statisticByEventID:@"0201030100005"
                                                    andBCID:self.bcId
                                                  andMallID:self.mId
                                                  andShopID:nil
                                            andBusinessType:self.typeKey
                                                  andItemID:[NSString stringWithFormat:@"%ld", model.InfoId]
                                                andItemText:nil
                                                andOpUserID:[NSString stringWithFormat:@"%ld", model.guider.UserId]];

    ShopGuideDetailViewController *controller = [[ShopGuideDetailViewController alloc] init];
    controller.infoid = model.InfoId;
    controller.statisticLike = ID_0201030110007;
    controller.statisticSendMsg = ID_0201030130006;
    controller.statisticShare = ID_0201030120008;
    [self.navigationController pushViewController:controller animated:YES];
}



@end
