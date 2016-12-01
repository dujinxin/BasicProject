
//
//  MarketClassController.m
//  GJieGo
//
//  Created by apple on 16/5/5.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 电器卖场 家具卖场 家具城 ---

#import "MarketClassController.h"
#import "ShopingCenterDetailController.h"
#import "ShopGuideDetailViewController.h"
#import "PromotionActivityController.h"
#import "BrandCouponController.h"
#import "MapOfMainViewController.h"
#import "GJGTopView.h"
#import "GJGSubTopView.h"
#import "GJGActivityClassView.h"
#import "GJGBrandClassView.h"
#import "ShopGuideTableViewCell.h"

#import "RunTypeMallModel.h"
#import "MallHomeInfoModel.h"
#import "GirlClothesListController.h"


#define topViewHeight 187
//#define subViewHeight 75
//#define activityClassHeight 86
//#define businessClassViewHeight 198

@interface MarketClassController ()<UITableViewDelegate, UITableViewDataSource, GJGTopViewDelegate, GJGActivityClassDelegate, UIActionSheetDelegate, BrandClassViewDelegate>{
    UIView *statusBackView;
    NSMutableArray *sourceArray;
    NSMutableArray *arr2;
    NSMutableArray *arr1;
    NSMutableArray *guideArray;
    
    NSInteger subViewHeight;
    NSInteger activityClassHeight;
    NSInteger businessClassViewHeight;
    
    MallHomeInfoModel *_mallHomeInfoModel;
    MallHomeInfoItem *_mallHomeInfoItem;
    
    NSInteger page;
    NSInteger once;
}
@property (nonatomic, strong)BaseTableView *shopCenterTableView;
@end

@implementation MarketClassController
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GJGRGB16Color(0xf1f1f1);
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    
    arr2 = [NSMutableArray array];
    guideArray = [NSMutableArray array];
    sourceArray = [NSMutableArray array];
    
    subViewHeight = 75;
    activityClassHeight = 86;
    businessClassViewHeight = 198;
    
    page = 1;
    once = 0;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self creatTableView];
    [self addDataSource];
    

}
- (void)addDataSource{
    
    __block int x = 0;
    NSMutableDictionary *paramHome = [NSMutableDictionary dictionary];
    [paramHome addEntriesFromDictionary:@{@"Mid":_mId}]; x -= 1;
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_MallHomeInfo) parameters:paramHome requestblock:^(id responseobject, NSError *error) {
        
        if ([responseobject[@"status"] integerValue] == 0) {
            _mallHomeInfoModel = [[MallHomeInfoModel alloc] initWithDic:responseobject];
            _mallHomeInfoItem = [[MallHomeInfoItem alloc] initWithDic:_mallHomeInfoModel.Data];
            self.title = _mallHomeInfoItem.MallName;
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
        x += 1;     if (x == 0) [self creatUI];
    }];
    
    /*新品到店*/
    NSMutableDictionary *paramRunType = [NSMutableDictionary dictionary];
    [paramRunType addEntriesFromDictionary:@{@"Mid":_mId}]; x -= 1;
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_RunTypeMall) parameters:paramRunType requestblock:^(id responseobject, NSError *error) {
        
        if ([responseobject[@"status"] integerValue] == 0) {
            RunTypeMallModel *runTypeMallModel2 = [[RunTypeMallModel alloc] initWithDic:responseobject];
            
            if (runTypeMallModel2.Data.count > 0) {
                arr2 = runTypeMallModel2.Data;
            }else{
                activityClassHeight = 0;
            }
//            [self creatRunTypeMallView];
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
        x += 1;     if (x == 0) [self creatUI];
    }];
    
    /*获取商品分类*/
    NSMutableDictionary *paramShopClass = [NSMutableDictionary dictionary];
    [paramShopClass addEntriesFromDictionary:@{@"Mid":_mId}];   x -= 1;
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_ProductTypeMall) parameters:paramShopClass requestblock:^(id responseobject, NSError *error) {
        
        if ([responseobject[@"status"] integerValue] == 0) {
            RunTypeMallModel *runTypeMallModel = [[RunTypeMallModel alloc] initWithDic:responseobject];
            
            if (runTypeMallModel.Data.count > 0) {
                sourceArray = runTypeMallModel.Data;
            }else{
                businessClassViewHeight = 0;
            }
//            [self creatProductMallTypeView];
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
        x += 1;     if (x == 0) [self creatUI];
    }];
    
    [self loadPublishDataMessage];
}


- (void)creatUI{
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 50, 50)];
    UIImage *shareImage = [UIImage imageNamed:@"title_btn_share"];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom tag:0 title:nil titleSize:0 frame:CGRectMake(10, 0, 50, 50) Image:shareImage target:self action:@selector(didClickShareButton:)];
    [rightView addSubview:shareButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    UIView *tabTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, topViewHeight + activityClassHeight + businessClassViewHeight + 10)];
    self.shopCenterTableView.tableHeaderView = tabTopView;

    GJGTopView *topView = [[GJGTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topViewHeight) Height:topViewHeight imageName:_mallHomeInfoItem.MallImage name:_mallHomeInfoItem.MallName subName:@"" distance:[self changeDistanceClass:_mallHomeInfoItem.Distance]];
    topView.delegate = self;
    [tabTopView addSubview:topView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapTopView:)];
    [topView addGestureRecognizer:tap];
    tabTopView.backgroundColor = GJGRGB16Color(0xf1f1f1);
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(tabTopView);
        make.top.equalTo(tabTopView);
        make.trailing.equalTo(tabTopView);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, topViewHeight));
    }];
    
    /*新品到店*/
    GJGActivityClassView * activityClassView = [[GJGActivityClassView alloc] initWithFrame:CGRectMake(0, topView.frame.origin.y + topView.bounds.size.height + 10, ScreenWidth, activityClassHeight -10) withSourceArray:arr2];
    activityClassView.backgroundColor = [UIColor whiteColor];
    activityClassView.activityDelegate = self;
    [tabTopView addSubview:activityClassView];
    [activityClassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.top.equalTo(topView.bottom);
        make.size.equalTo(CGSizeMake(ScreenWidth, activityClassHeight));
    }];
    
    GJGBrandClassView *brandClassView = [[GJGBrandClassView alloc] initWithFrame:CGRectMake(0, activityClassView.frame.origin.y + activityClassView.bounds.size.height + 10, ScreenWidth, businessClassViewHeight) sourceArray:sourceArray];
    [tabTopView addSubview:brandClassView];
    brandClassView.backgroundColor = [UIColor whiteColor];
    brandClassView.delegate = self;
    [brandClassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.top.equalTo(activityClassView.bottom).offset(10);
        make.size.equalTo(CGSizeMake(ScreenWidth, businessClassViewHeight));
    }];
}

#pragma make - creatTableView
- (void)creatTableView{
    self.shopCenterTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    self.shopCenterTableView.delegate = self;
    self.shopCenterTableView.dataSource = self;
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
- (void)loadPublishDataMessage{
    //加载最新发布信息
    NSMutableDictionary *paramRunType = [NSMutableDictionary dictionary];
    [paramRunType addEntriesFromDictionary:@{@"Mid":_mId, @"page":[NSString stringWithFormat:@"%ld",page], @"order":@"0"}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_PromotionsShop) parameters:paramRunType requestblock:^(id responseobject, NSError *error) {
        NSLog(@"%@%@%@", self.title, @"----最新发布信息----", responseobject);
        if ([responseobject[@"status"] integerValue] == 0) {
            if (page == 1) {
                sourceArray == nil ? (sourceArray = [NSMutableArray array]) : ([sourceArray removeAllObjects]);
            }
            if ([responseobject[@"data"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:responseobject[@"data"]];
                if (array.count > 0) {
                    for (int i = 0; i< array.count; i++) {
                        
                        LBGuideInfoM * model = [[LBGuideInfoM alloc] initWithDict:array[i]];
                        [guideArray addObject:model];
                    }
                    
                }else{
                    [self.view makeToast:responseobject[@"message"] duration:0.3];
                }
                
            }
            
           [_shopCenterTableView reloadData]; 
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark - Update data

- (void)updateData {
    
        page = 1;
    
        [self addDataSource];
        [_shopCenterTableView.mj_header endRefreshing];
}

- (void)updateMoreData {
    
        page++;
        [self loadPublishDataMessage];
        [_shopCenterTableView.mj_footer endRefreshing];
}

#pragma mark - topViewTap - Action
- (void)TapTopView:(UITapGestureRecognizer *)tap{
    ShopingCenterDetailController *controller = [[ShopingCenterDetailController alloc] init];
    controller.title = [NSString stringWithFormat:@"%@详情", _mallHomeInfoItem.MallName];
    controller.mallId = _mId;
    controller.vcClass = @"mall";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 商品分类 - 男装，女装等
- (void)clickBrandClassButton:(UIButton *)button{
    NSLog(@"%@",button.titleLabel.text);
    RunTypeMallItem *item = sourceArray[button.tag - 1000];
    GirlClothesListController *controller = [[GirlClothesListController alloc] init];
    controller.title = button.titleLabel.text;
    controller.mId = _mId;
    controller.type = [NSString stringWithFormat:@"%ld", item.DicID];
    [self.navigationController pushViewController:controller animated:YES];
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
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

#pragma mark - clickMap
- (void)clickMapButtonAction:(UIButton *)button{
    MapOfMainViewController *mapVC = [[MapOfMainViewController alloc] init];
    mapVC.shopName = _mallHomeInfoItem.MallName;
    mapVC.shopAddress = _mallHomeInfoItem.MallAddress;
    mapVC.shopLocation = [[CLLocation alloc] initWithLatitude:_mallHomeInfoItem.Latitude longitude:_mallHomeInfoItem.Longitude];
    
    [self.navigationController pushViewController:mapVC animated:YES];
}


#pragma mark - share
- (void)didClickShareButton:(UIButton *)button{
    __block NSString *infoId = [NSString stringWithFormat:@"%ld", _mallHomeInfoItem.MallID];
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
                                                     presentedController:self
                                                                 success:^(id object, UserShareSns sns)
              {
                  [request requestPostTypeWithUrl:kGJGRequestUrl(kApiShareSuccess) parameters:@{@"InfoId":infoId, @"infoType":@"10", @"ShareTo":[NSString stringWithFormat:@"%ld", (long)sns]} requestblock:^(id responseobject, NSError *error) {
                      [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
                  }];
              } failure:^(id object, UserShareSns sns){

              }];
         }
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return guideArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopGuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopGuideTableViewCell"];
    cell.type = ShopGuideCellTypeIsDetail;
    cell.guideInfo = guideArray[indexPath.row];
//    [cell setSomeOne:5];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LBGuideInfoM * model = guideArray[indexPath.row];
    ShopGuideDetailViewController *controller = [[ShopGuideDetailViewController alloc] init];
    controller.infoid = model.InfoId;
    [self.navigationController pushViewController:controller animated:YES];
}


@end
