//
//  GeneralMarketController.m
//  GJieGo
//
//  Created by apple on 16/5/5.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 超市 ---

#import "GeneralMarketController.h"
#import "ShopingCenterDetailController.h"
#import "ShopGuideDetailViewController.h"
#import "BrandCouponController.h"
#import "CouponListController.h"
#import "BusinessInfoController.h"
#import "PromotionActivityController.h"
#import "FreshFoodCollectionController.h"
#import "MenuViewController.h"
#import "MapOfMainViewController.h"
#import "WifiFreePriceController.h"

#import "GJGTopView.h"
#import "GJGSubTopView.h"
#import "GJGActivityClassView.h"
#import "GJGBrandClassView.h"
#import "ShopGuideTableViewCell.h"
#import "GJGSelectorBar.h"

#import "MallHomeInfoModel.h"
#import "RunTypeMallModel.h"
#import "PublicModel.h"

#define topViewHeight 187
//#define subViewHeight 75
//#define activityClassHeight 86
//#define businessClassViewHeight 198

@interface GeneralMarketController ()<UITableViewDelegate, UITableViewDataSource, GJGTopViewDelegate, GJGActivityClassDelegate, BrandClassViewDelegate>{
    UIView *statusBackView;
    NSArray *sourceArray;
    NSMutableArray *arr2;
    NSMutableArray *guideArray;
    NSMutableArray *goodsClassArray;
    
    MallHomeInfoModel *_mallHomeInfoModel;
//    MallHomeInfoItem *_mallHomeInfoItem;
    ShopHomeInfoItem *_shopHomeInfoItem;
    
//    NSInteger subViewHeight;
    NSInteger activityClassHeight;
    
    NSInteger businessClassViewHeight;
    NSInteger page;
    
    GJGSelectorBar *topSelectView;
    NSString *order;
    
    UIView *_tabTopView;        //tableView-header
    UIButton *stowButton;
    
}
@property (nonatomic, strong)BaseTableView *shopCenterTableView;
@property (nonatomic, strong)GJGActivityClassView * activityClassView;
@property (nonatomic, strong)GJGBrandClassView *brandClassView;
@property (nonatomic, strong)GJGTopView *topView;
@end

@implementation GeneralMarketController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundColor:COLOR(254, 227, 48, 1)];
    [self.navigationController.navigationBar addSubview:statusBackView];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [statusBackView removeFromSuperview];
}
- (void)viewDidAppear:(BOOL)animated{
    [self viewWillLayoutSubviews];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    
    arr2 = [NSMutableArray array];
    sourceArray = [NSMutableArray array];
    guideArray = [NSMutableArray array];
    goodsClassArray = [NSMutableArray array];
    
//    subViewHeight = 86;
    activityClassHeight = 0;
    businessClassViewHeight = 0;
    page = 1;
    order = @"1";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self creatTableView];
    [self creatUI];
    [self loadDataMessage];
}

//
- (void)loadDataMessage{
    /*首页店铺展示*/
    NSMutableDictionary *paramHome = [NSMutableDictionary dictionary];
    [paramHome addEntriesFromDictionary:@{@"ShopId":_shopId}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_ShopHomeInfo) parameters:paramHome requestblock:^(id responseobject, NSError *error) {
        if ([responseobject[@"status"] integerValue] == 0) {
            _mallHomeInfoModel = [[MallHomeInfoModel alloc] initWithDic:responseobject];
            _shopHomeInfoItem = [[ShopHomeInfoItem alloc] initWithDic:_mallHomeInfoModel.Data];
            self.title = _shopHomeInfoItem.ShopName;
            [_topView removeAllSubviews];
            _topView.shopHomeInfoItem = _shopHomeInfoItem;
            stowButton.selected = !_shopHomeInfoItem.IsCollected;
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
        _shopCenterTableView.tableHeaderView = _tabTopView;
    }];
    
    /*新品到店*/
    NSMutableDictionary *paramMallFunc = [NSMutableDictionary dictionary];
    [paramMallFunc addEntriesFromDictionary:@{@"shopid":_shopId}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_RunTypeShop) parameters:paramMallFunc requestblock:^(id responseobject, NSError *error) {
        NSLog(@"新品到店 - %@", responseobject);
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
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
        _shopCenterTableView.tableHeaderView = _tabTopView;
    }];
    /*获取商品分类*/
    NSMutableDictionary *paramShopClass = [NSMutableDictionary dictionary];
    [paramShopClass addEntriesFromDictionary:@{@"shopid":_shopId}];  
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_PPTypeShop) parameters:paramShopClass requestblock:^(id responseobject, NSError *error) {
        NSLog(@"商品分类 - %@", responseobject);
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
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
        _shopCenterTableView.tableHeaderView = _tabTopView;
    }];
    
    [self loadPublishDataMessage];
}

#pragma mark - 最新发布信息
- (void)loadPublishDataMessage{

    NSMutableDictionary *paramRunType = [NSMutableDictionary dictionary];
    [paramRunType addEntriesFromDictionary:@{@"ShopId":_shopId, @"page":[NSString stringWithFormat:@"%ld",page], @"order":order}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_PromotionsShop) parameters:paramRunType requestblock:^(id responseobject, NSError *error) {
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
                    
                }else{
                }
                
            }
            
          [_shopCenterTableView reloadData];  
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
//        [topSelectView setHidden:NO];
    }];
}

#pragma mark - Update data

- (void)updateData {
    
        page = 1;
    
        [self loadDataMessage];
//        [_shopCenterTableView.mj_header endRefreshing];
}

- (void)updateMoreData {
    
        page++;
        [self loadPublishDataMessage];
//        [_shopCenterTableView.mj_footer endRefreshing];
}
#pragma mark - 设置约束
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [_topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_tabTopView);
        make.top.equalTo(_tabTopView);
        make.trailing.equalTo(_tabTopView);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, topViewHeight));
    }];
    
    [_activityClassView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.top.equalTo(_topView.bottom);
        make.size.equalTo(CGSizeMake(ScreenWidth, activityClassHeight));
    }];
    [_brandClassView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.top.equalTo(_activityClassView.bottom).offset(10);
        make.size.equalTo(CGSizeMake(ScreenWidth, businessClassViewHeight));
    }];
    [topSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_tabTopView);
        make.top.equalTo(_brandClassView.bottom);
        make.size.equalTo(CGSizeMake(ScreenWidth, 40));
    }];
    _tabTopView.frame = CGRectMake(0, 0, ScreenWidth, topViewHeight + activityClassHeight + businessClassViewHeight + 40);
}

#pragma  mark - creatUI
- (void)creatUI{
    /*
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 80, 50)];
    UIImage *shareImage = [UIImage imageNamed:@"title_btn_share"];
    UIImage *stowImage = [UIImage imageNamed:@"title_focus_default"];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom tag:0 title:nil titleSize:0 frame:CGRectMake(rightView.frame.size.width - shareImage.size.width - 30, 13, shareImage.size.width, shareImage.size.height) Image:shareImage target:self action:@selector(didClickShareButton:)];
    stowButton = [UIButton buttonWithType:UIButtonTypeCustom tag:_shopHomeInfoItem.IsCollected title:nil titleSize:0 frame:CGRectMake(shareButton.frame.origin.x + shareButton.frame.size.width + 16, shareButton.frame.origin.y, stowImage.size.width, stowImage.size.height) Image:stowImage target:self action:@selector(didClickStowButton:)];
    [stowButton setImage:[UIImage imageNamed:@"title_focus_selected"] forState:UIControlStateSelected];
    */
    UIImage *shareImage = [UIImage imageNamed:@"title_btn_share"];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom tag:0 title:nil titleSize:0 frame:CGRectMake(0, 0, shareImage.size.width + 10, shareImage.size.height + 15) Image:shareImage target:self action:@selector(didClickShareButton:)];
    
    UIImage *stowImage = [UIImage imageNamed:@"title_focus_default"];
    UIImage *selectedStowImage = [UIImage imageNamed:@"title_focus_selected"];
    stowButton = [UIButton buttonWithType:UIButtonTypeCustom tag:_shopHomeInfoItem.IsCollected title:nil titleSize:0 frame:CGRectMake(shareButton.frame.origin.x + shareButton.frame.size.width, shareButton.frame.origin.y, stowImage.size.width + 10, stowImage.size.height + 18) Image:stowImage target:self action:@selector(didClickStowButton:)];
    [stowButton setImage:selectedStowImage forState:UIControlStateSelected];
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    UIBarButtonItem *stowItem = [[UIBarButtonItem alloc] initWithCustomView:stowButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:stowItem, shareItem, nil];
    
    _tabTopView = [[UIView alloc] initWithFrame:CGRectZero];
    _tabTopView.backgroundColor = [UIColor whiteColor];
    self.shopCenterTableView.tableHeaderView = _tabTopView;
    
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
                    [self loadPublishDataMessage];
                }
            }
        }];
        topSelectView.classificationLabel.text = @"分类";
        topSelectView.rightIndicImgView.hidden = YES;
//        [topSelectView setHidden:YES];
    }
    [_tabTopView addSubview:topSelectView];
    
    /*首页店铺展示*/
    _topView = [[GJGTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topViewHeight) Height:topViewHeight imageName:_shopHomeInfoItem.ShopImage name:_shopHomeInfoItem.ShopName subName:_shopHomeInfoItem.ShopAddress distance:[self changeDistanceClass:_shopHomeInfoItem.Distance]];
    _topView.delegate = self;
    [_tabTopView addSubview:_topView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapTopView:)];
    [_topView addGestureRecognizer:tap];
    
    /*新品到店*/
    _activityClassView = [[GJGActivityClassView alloc] initWithFrame:CGRectZero];
    _activityClassView.activityDelegate = self;
    _activityClassView.clipsToBounds = YES;
    [_tabTopView addSubview:_activityClassView];
    
    /*获取商品分类*/
    _brandClassView = [[GJGBrandClassView alloc] initWithFrame:CGRectZero];
    [_tabTopView addSubview:_brandClassView];
    _brandClassView.clipsToBounds = YES;
    _brandClassView.backgroundColor = [UIColor whiteColor];
    _brandClassView.delegate = self; 
}

- (void)creatTableView{
    self.shopCenterTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    self.shopCenterTableView.delegate = self;
    self.shopCenterTableView.dataSource = self;
    self.shopCenterTableView.backgroundColor = GJGRGB16Color(0xf1f1f1);
    self.shopCenterTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.shopCenterTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopGuideTableViewCell class])
                                                         bundle:nil]
                   forCellReuseIdentifier:@"ShopGuideTableViewCell"];
    self.shopCenterTableView.rowHeight = UITableViewAutomaticDimension;
    self.shopCenterTableView.estimatedRowHeight = 44.f;
    [self.view addSubview:self.shopCenterTableView];
    self.shopCenterTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self updateData];
    }];
    self.shopCenterTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        
        [self updateMoreData];
    }];
}
#pragma mark - topViewTap - Action
- (void)TapTopView:(UITapGestureRecognizer *)tap{
    ShopingCenterDetailController *controller = [[ShopingCenterDetailController alloc] init];
    controller.title = @"";//[NSString stringWithFormat:@"%@详情", _shopHomeInfoItem.ShopName];
    controller.shopId = _shopId;
    controller.vcClass = @"shop";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 自运营分类如：新品到店
- (void)didClickActivityButton:(UIButton *)button{

    RunTypeMallItem *item = [[RunTypeMallItem alloc] initWithDic:arr2[button.tag - 2500]];
    NSString *menuStr = @"rtmenu_runtypeitem25、rtmenu_runtypeitem22、rtmenu_runtypeitem11";
    NSArray *menuArray = [menuStr componentsSeparatedByString:@"、"];    //电子菜单
    NSString * dicKey = [item.DicKey componentsSeparatedByString:@"_"][0];
    if ([dicKey isEqualToString:@"rtshopshow"]) {
        /*电子菜单*/
        MenuViewController *controller = [[MenuViewController alloc] init];
        controller.title = button.titleLabel.text;
        controller.shopId = _shopId;
        if ([menuArray containsObject:item.DicKey]) {
            //电子菜单
            controller.url = kGet_Menu;
            controller.type = @"menu";
        }else{
            //店铺环境
            controller.url = kGet_ShopShow;
            controller.type = @"shop";
        }
        [self.navigationController pushViewController:controller animated:YES];
        
        /*店铺环境*/
        //        ShopEnviromentController *controller = [[ShopEnviromentController alloc] init];
        //        controller.title = button.titleLabel.text;
        //        [self.navigationController pushViewController:controller animated:YES];
    } else if([dicKey isEqualToString:@"rtbrandcoupon"]){
        /*品牌优惠券*/
        BrandCouponController *controller = [[BrandCouponController alloc] init];
        controller.title = button.titleLabel.text;
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if ([dicKey isEqualToString:@"rtcoupon"]){
        /*优惠券列表*/
        CouponListController *controller = [[CouponListController alloc] init];
        controller.title = button.titleLabel.text;
        controller.shopId = _shopId;
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([dicKey isEqualToString:@"rtbookticket"]){
        //预定取票------webView
    } else if ([dicKey isEqualToString:@"rtnotice"]){
        /*入场须知*/
        BusinessInfoController *controller = [[BusinessInfoController alloc] init];
        controller.title = button.titleLabel.text;
        controller.viewRequest = kGet_ShopProperty;
        NSDictionary *dic = @{@"ShopId":_shopId, @"Pt":@"5"};
        controller.requestDic = dic;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        /*新品到店*/
        PromotionActivityController *controller = [[PromotionActivityController alloc] init];
        controller.title = button.titleLabel.text;
        controller.shopId = _shopId;
        controller.hType = [NSString stringWithFormat:@"%ld", item.DicID];
        controller.sourceArray = arr2;
        controller.vcClass = @"shop";
        controller.bcId = self.bcId;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - 商品分类 -    熟食生鲜 等
- (void)clickBrandClassButton:(UIButton *)button{
    
    RunTypeMallItem *item = [[RunTypeMallItem alloc] initWithDic:sourceArray[button.tag - 1000]];
    FreshFoodCollectionController *controller = [[FreshFoodCollectionController alloc] init];
    controller.title = button.titleLabel.text;
    controller.shopId = _shopId;
    controller.type = item.DicName;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma  mark - share
- (void)didClickShareButton:(UIButton *)button{
    
    __block NSString *infoId = [NSString stringWithFormat:@"%ld", _shopHomeInfoItem.ShopID];
    [[LoginManager shareManager] checkUserLoginState:^{
        [[LBRequestManager sharedManager] getSharedInfoWithInfoId:_shopHomeInfoItem.ShopID
                                                         infoType:GJGShareInfoTypeIsShopHome
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
                                                                   shareType:UserShopHomeShareType
                                                         presentedController:self
                                                                     success:^(id object, UserShareSns sns)
                  {
                      NSLog(@"分享成功.");
                      [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201010020007
                                                                      andBCID:self.bcId
                                                                    andMallID:nil
                                                                    andShopID:[NSString stringWithFormat:@"%ld", _shopHomeInfoItem.ShopID]
                                                                  andItemType:self.dicID
                                                              andBusinessType:self.TypeKey
                                                                    andItemID:nil
                                                                  andItemText:self.dicName
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

#pragma mark - stowButton - action
- (void)didClickStowButton:(UIButton *)button{
    
    [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201010030006
                                                    andBCID:self.bcId
                                                  andMallID:nil
                                                  andShopID:[NSString stringWithFormat:@"%ld", _shopHomeInfoItem.ShopID]
                                            andBusinessType:self.TypeKey
                                                  andItemID:nil
                                                andItemText:self.dicName
                                                andOpUserID:[UserDBManager shareManager].UserID];
    
    [[LoginManager shareManager] checkUserLoginState:^{
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param addEntriesFromDictionary:@{
                                          @"ShopID":_shopId,
                                          @"Coc":[NSString stringWithFormat:@"%d",(int)!_shopHomeInfoItem.IsCollected]
                                          }];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_CollectShop)
                             parameters:param
                           requestblock:^(id responseobject, NSError *error)
         {
             [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
             if ([responseobject[@"status"] integerValue] == 0) {
                 button.selected = _shopHomeInfoItem.IsCollected;
                 _shopHomeInfoItem.IsCollected = !_shopHomeInfoItem.IsCollected;
             }else{
                 [[UIApplication sharedApplication].keyWindow makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
             }
         }];
    }];
    
}

#pragma mark - clickMap
- (void)clickMapButtonAction:(UIButton *)button{
    
    MapOfMainViewController *mapVC = [[MapOfMainViewController alloc] init];
    mapVC.shopName = _shopHomeInfoItem.ShopName;
    mapVC.shopAddress = _shopHomeInfoItem.ShopAddress;
    mapVC.shopLocation = [[CLLocation alloc] initWithLatitude:_shopHomeInfoItem.Latitude longitude:_shopHomeInfoItem.Longitude];
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark -table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
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
//                    [self loadPublishDataMessage];
//                }
//            }
//        }];
//        topSelectView.classificationLabel.text = @"分类";
//        [topSelectView setHidden:YES];
//    }
//    return topSelectView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return guideArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopGuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopGuideTableViewCell"];
    cell.type = ShopGuideCellTypeIsInBusinessArea;
    
    cell.guideInfo = guideArray[indexPath.row];
    //    [cell setSomeOne:5];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LBGuideInfoM * model = guideArray[indexPath.row];
    
    [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201030100009
                                                    andBCID:self.bcId
                                                  andMallID:nil
                                                  andShopID:self.shopId
                                            andBusinessType:self.TypeKey
                                                  andItemID:[NSString stringWithFormat:@"%ld", model.InfoId]
                                                andItemText:self.dicName
                                                andOpUserID:[NSString stringWithFormat:@"%ld", model.guider.UserId]];
    
    ShopGuideDetailViewController *controller = [[ShopGuideDetailViewController alloc] init];
    controller.infoid = model.InfoId;
    controller.statisticLike = ID_0201030110011;
    controller.statisticSendMsg = ID_0201030130010;
    controller.statisticShare = ID_0201030120012;
    [self.navigationController pushViewController:controller animated:YES];

}

@end
