//
//  GJGBusinessAreaController.m
//  GJieGo
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "GJGBusinessAreaController.h"
#import "ShopCenterController.h"
#import "BusinessClassMoreController.h"
#import "GJGShopListCell.h"
#import "GJGBusinessClassView.h"
#import "GJGBusinessView.h"
#import "BusinessClassDetailListController.h"//败家
#import "ShopCenterListController.h"
#import "SearchOfMainViewController.h"
#import "LocationViewController.h"
#import "ChooseCityController.h"
#import "MallBCModel.h"
#import "ByCityModel.h"
#import "ShopTypeModel.h"
#import "OpenedCityModel.h"
#import "GJGLocationManager.h"

#define rowNum 10
#define rowHeight 130
#define classViewHeight 198

@interface GJGBusinessAreaController ()<UITableViewDelegate, UITableViewDataSource, businessViewDelegate, businessDelegate, chooseNameDelegate>{
    UIView *alphaBusinessView;
    NSInteger h;
    UIImageView *titleImageView;
    UIView *statusBackView;
    NSInteger btnT;
    UILabel *titleLabel;
    
    NSString *location;
    GJGBusinessClassView *classView;    //tabHeaderView
    
    MallBCModel *_mallBCModel;               //商圈首页下的商场
    BusinessTypeModel *_businessTypeModel;   //行业业态类别
    ByCityModel *_byCityModel;              //获取城市下商圈
    OpenedCityModel *_openedCityModel;      //开放城市
    
    NSInteger once;
    
    NSString *_cityName;                //当前城市名称
    NSString *_cityId;                  //当前城市id
    NSString *_bcId;                     //当前商圈id
    GJGLocationManager *_locationManager;    //获取位置和定位数据
    
}

@property (nonatomic, strong)BaseTableView *businessAreaTable;
@property (nonatomic, strong)GJGBusinessView *businessView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation GJGBusinessAreaController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [statusBackView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundColor:COLOR(254, 227, 48, 1)];
    [self.navigationController.navigationBar addSubview:statusBackView];
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnT = 0;
    once = 0;
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    
    _cityId = [NSString stringWithFormat:@"%ld", (long)[GJGLocationManager sharedManager].cityID];
    _cityName = [GJGLocationManager sharedManager].cityName;
    
    [self creatTableView];
    [self GetBCByCityData];
    
}

- (void)viewDidAppear:(BOOL)animated{
    once ++;
}

#pragma mark - Get
- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - Init some config

- (void)initAttributes {
    self.automaticallyAdjustsScrollViewInsets = NO;
}

//获取城市下商圈
- (void)GetBCByCityData{
    __block typeof (self) selfVC = self;
    if (_cityId != nil && ![_cityId isEqualToString:@""]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param addEntriesFromDictionary:@{@"Cid":_cityId}];
        [request requestUrl:kGJGRequestUrl(kGet_BCCity) requestType:RequestPostType parameters:param requestblock:^(id responseobject, NSError *error) {
            NSLog(@"%@", responseobject);
            
            if([responseobject[@"status"] integerValue] == 0){
                _byCityModel = [[ByCityModel alloc] initWithDic:responseobject];
                if (_byCityModel.Data.count > 0) {
                    NSDictionary *dic = _byCityModel.Data[0];
                    if (dic != nil) {
                        ByCityItem *item = [[ByCityItem alloc] initWithDic:dic];
                        _bcId = [[NSString stringWithFormat:@"%ld", (long)item.BCID] copy];
                        [selfVC addNavigationCenterView];
                        [selfVC GetBusinessTypeByBC:[NSString stringWithFormat:@"%ld", (long)item.BCID]];
                        classView.hidden = NO;
                        selfVC.businessAreaTable.hidden = NO;
                    }else{
                        classView.hidden = YES;
                        selfVC.businessAreaTable.hidden = YES;
                        [selfVC addNavigationCenterView];
                    }
                }else{
                    _bcId = @"";
                    [self addNavigationCenterView];
                    [self GetBusinessTypeByBC:@""];
                }
            }else{
                //失败
                [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
            }
        }];
    }
}


- (void)GetBusinessTypeByBC:(NSString *)bcId{
    //获取商圈类别【吃货，败家。。。】
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:@{@"BcId":bcId}];
    [request requestUrl:kGJGRequestUrl(kGet_BusinessTypeBC) requestType:RequestGetType parameters:param requestblock:^(id responseobject, NSError *error) {
        if ([responseobject[@"status"] integerValue] == 0) {
            _businessTypeModel = [[BusinessTypeModel alloc] initWithDic:responseobject];
            classView.sourceArray = _businessTypeModel.Data;
            if (_businessTypeModel.Data.count == 0) {
                classView.hidden = YES;
            }else{
                classView.hidden = NO;
            }
        }else{
            classView.hidden = YES;
        }
    }];
    
    //获取业态
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:@{@"BcId":bcId}];
    [request requestUrl:kGJGRequestUrl(kGet_MallBC) requestType:RequestPostType parameters:parameters requestblock:^(id responseobject, NSError *error) {
        if ([responseobject[@"status"] integerValue] == 0) {
            _mallBCModel = [[MallBCModel alloc] initWithDic:responseobject];
            
        }else{
            _mallBCModel = [[MallBCModel alloc] init];
        }
        [_businessAreaTable reloadData];
    }];
}

- (void)creatTableView{
    
    classView = [[GJGBusinessClassView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight * 0.3 + 10)];
    classView.sourceArray = _businessTypeModel.Data;
    classView.delegate = self;
    classView.backgroundColor = GJGRGB16Color(0xf1f1f1);
    self.businessAreaTable = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight ) style:UITableViewStyleGrouped];
    self.businessAreaTable.delegate = self;
    self.businessAreaTable.dataSource = self;
    self.businessAreaTable.tableHeaderView = classView;
    self.businessAreaTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.businessAreaTable];
    [self.businessAreaTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.businessAreaTable registerClass:[GJGShopListCell class] forCellReuseIdentifier:@"BusinessAreaCell"];
    self.businessAreaTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    __block typeof (self) businessVC = self;
    _businessAreaTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self updateData];
    }];
}

#pragma mark - Update data
- (void)updateData {
    
    if (_bcId == nil) {
        [self GetBCByCityData];
    }else{
        /*商圈首页 行业业态*/
        [self GetBusinessTypeByBC:_bcId];
    }
    [_businessAreaTable.mj_header endRefreshing];
}

#pragma mark --------chooseCityController delegate method
- (void)chooseCityName:(NSString *)cityName cityId:(NSString *)cityId{
    /*城市下商圈*/
    _cityId = cityId;
    _cityName = cityName;
    [self GetBCByCityData];
    
}
- (void)tapAlphaBusinessView:(UITapGestureRecognizer *)tap {
    if (btnT % 2 == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            alphaBusinessView.alpha = 0.8;
            _businessView.frame = CGRectMake(0, 64, ScreenWidth, h);
            titleImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            alphaBusinessView.alpha = 0;
            _businessView.frame = CGRectMake(0, 64 - h , ScreenWidth, h);
            titleImageView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
    btnT ++;
}

- (void)addNavigationCenterView{
    
    UIButton *titleViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleViewButton addTarget:self action:@selector(chooseBusinessArea:) forControlEvents:UIControlEventTouchUpInside];
    titleLabel = [[UILabel alloc] init];
    if (_byCityModel.Data.count > 0) {
        NSDictionary *dic = _byCityModel.Data[0];
        ByCityItem *item = [[ByCityItem alloc] initWithDic:dic];
        
        if (dic == nil || [_byCityModel.Data isKindOfClass:[NSNull class]]) {
            titleLabel.text = _cityName;
            titleViewButton.tag = [_cityId integerValue];
        }else{
            titleLabel.text = item.BCName;
            titleViewButton.tag = item.BCID;
        }
        
    }else{
        titleViewButton.tag = 0;
    }
    if ([titleLabel.text isEqualToString:@""] || titleLabel.text == nil) {
        titleLabel.text = @"暂无商圈";
    }
    titleLabel.font = [UIFont systemFontOfSize:17.0f];
    titleLabel.textColor = GJGRGB16Color(0x333333);
    titleImageView = [[UIImageView alloc] init];
    titleImageView.image = [UIImage imageNamed:@"mall_title_cbb_down"];
    titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [titleViewButton addSubview:titleLabel];
    [titleViewButton addSubview:titleImageView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleViewButton);
        make.centerY.equalTo(titleViewButton);
    }];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(titleLabel.trailing).offset(7);
        make.centerY.equalTo(titleLabel);
    }];
    [titleLabel layoutIfNeeded];
    titleViewButton.frame = CGRectMake(0, 0, titleLabel.frame.size.width, 40);
    //搜索
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom tag:0 title:@"" titleSize:13 frame:CGRectMake(0, 0, 23, 23) Image:[UIImage imageNamed:@"mall_title_btn_search"] target:self action:@selector(didClickSearchButton:)];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.titleView = titleViewButton;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    if (self.businessView != nil) {
        self.businessView = nil;
    }
    
    h = 24 + 21 + 33 + 23 + _byCityModel.Data.count / 3 * 43;
    if (_byCityModel.Data.count % 3 != 0) {
        h += 33;
    }
    alphaBusinessView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    alphaBusinessView.backgroundColor = [UIColor blackColor];
    alphaBusinessView.alpha = 0;
    [self.view addSubview:alphaBusinessView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAlphaBusinessView:)];
    [alphaBusinessView addGestureRecognizer:tap];
    self.businessView = [[GJGBusinessView alloc] initWithFrame:CGRectMake(0, 64 - h, ScreenWidth, h) sourceArray:_byCityModel.Data location:[NSString stringWithFormat:@"%@", _cityName] className:@"business"];
    self.businessView.delegate = self;
    [self.view addSubview:self.businessView];
}

#pragma mark - 点击切换商圈/城市
- (void)chooseBusinessArea:(UIButton *)button{
    if (btnT % 2 == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            alphaBusinessView.alpha = 0.8;
            _businessView.frame = CGRectMake(0, 64, ScreenWidth, h);
            titleImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            alphaBusinessView.alpha = 0;
            _businessView.frame = CGRectMake(0, 64 - h , ScreenWidth, h);
            titleImageView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
    btnT ++;
}

#pragma mark - 点击搜索
- (void)didClickSearchButton:(UIButton *)button{
    
    SearchOfMainViewController *searchVC = [[SearchOfMainViewController alloc] init];
    [searchVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:searchVC animated:YES];
    alphaBusinessView.alpha = 0;
    self.businessView.frame = CGRectMake(0, 64 - h , ScreenWidth, h);
    titleImageView.transform = CGAffineTransformMakeRotation(0);
    btnT = 0;
}

#pragma mark - 点击败家分类
- (void)transformBusinessViewButtonAction:(UIButton *)button{
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:_businessTypeModel.Data[button.tag - 1000]];
    BusinessTypeItem *item = [[BusinessTypeItem alloc] initWithDic:dic];
    if ([button.titleLabel.text isEqualToString:@"更多"]) {
        BusinessClassMoreController *classMoreController = [[BusinessClassMoreController alloc] init];
        classMoreController.title = @"所有分类";
        classMoreController.bcId = _bcId;
        classMoreController.sourceArray = _businessTypeModel.Data;
        [self.navigationController pushViewController:classMoreController animated:YES];
    }else{
        BusinessClassDetailListController *controller = [[BusinessClassDetailListController alloc] init];
        controller.businessName = button.titleLabel.text;
        controller.title = button.titleLabel.text;
        controller.eventID = ID_0201010010001;
        controller.Type = item.DicID;
        controller.bcId = _bcId;
        controller.businessName = item.DicName;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark -- delegate 点击商圈按钮
- (void)clickBusinessButtonAction:(UIButton *)button{
    if (btnT % 2 == 0) {
        
        [UIView animateWithDuration:0.3 animations:^{
            alphaBusinessView.alpha = 0.8;
            _businessView.frame = CGRectMake(0, 64, ScreenWidth, h);
            titleImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            alphaBusinessView.alpha = 0;
            _businessView.frame = CGRectMake(0, 64 - h , ScreenWidth, h);
            titleImageView.transform = CGAffineTransformMakeRotation(0);
            titleLabel.text = button.titleLabel.text;
            ByCityItem *item = [[ByCityItem alloc] initWithDic:_byCityModel.Data[button.tag]];
            _bcId = [NSString stringWithFormat:@"%ld",(long)item.BCID];
            [_businessAreaTable.mj_header beginRefreshing];
        }];
    }
    btnT ++;
}

#pragma mark -- 更多商场
- (void)clickMoreButton:(UIButton *)button{
    ShopCenterListController *controller = [[ShopCenterListController alloc] init];
    MallBCItem *item = [[MallBCItem alloc] initWithDic:_mallBCModel.Data[button.tag - 100]];
    controller.title = item.TypeName;
    controller.TypeKey = item.TypeKey;
    controller.bcId = [_bcId integerValue];
    controller.bId = item.TypeID;
    controller.eventID = ID_0201010040003;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -- 点击切换当前城市
- (void)clickMapButtonAction:(UIButton *)button{
    ChooseCityController *locationVC = [[ChooseCityController alloc] init];
    locationVC.openedCityArray = [GJGLocationManager sharedManager].openedCitys;
    locationVC.delegate = self;
    [self presentViewController:locationVC animated:YES completion:nil];
    
    alphaBusinessView.alpha = 0;
    self.businessView.frame = CGRectMake(0, 64 - h , ScreenWidth, h);
    titleImageView.transform = CGAffineTransformMakeRotation(0);
    btnT = 0;
}

#pragma mark --- tableView 商圈内容 ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _mallBCModel.Data.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 34)];
    sectionView.backgroundColor = [UIColor whiteColor];
    UILabel *tLabel = [[UILabel alloc] init];
    MallBCItem *item = [[MallBCItem alloc] initWithDic:_mallBCModel.Data[section]];
    tLabel.text = [NSString stringWithFormat:@"%@", item.TypeName];
    tLabel.font = [UIFont systemFontOfSize:13.0f];
    tLabel.textColor = GJGRGB16Color(0x333333);
    tLabel.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mall_content_btn_more_1"]];
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    moreLabel.text = @"更多";
    moreLabel.font = [UIFont systemFontOfSize:13];
    moreLabel.textColor = GJGRGB16Color(0xf1b12a);
    moreLabel.backgroundColor = [UIColor whiteColor];
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag = section + 100;
    moreButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [moreButton setTitle:item.TypeKey forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:0];
    
    [sectionView addSubview:tLabel];
    [sectionView addSubview:moreLabel];
    [sectionView addSubview:imageView];
    [sectionView addSubview:moreButton];
    
    [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(13);
    }];
    [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(imageView).offset(-12);
        make.centerY.equalTo(tLabel);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(sectionView).offset(-15);
        make.centerY.equalTo(tLabel);
    }];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(sectionView);
        make.centerY.equalTo(sectionView);
        make.height.equalTo(30);
        make.width.equalTo(80);
    }];
    
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.001)];
    view.backgroundColor = [UIColor whiteColor];//GJGRGB16Color(0xf1f1f1);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MallBCItem *item = [[MallBCItem alloc] initWithDic:_mallBCModel.Data[section]];
    return item.MallList.count * 2;//每部分2个cell
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MallBCItem *item = [[MallBCItem alloc] initWithDic:_mallBCModel.Data[indexPath.section]];
    if (indexPath.row == (item.MallList.count * 2 - 1)) {
        return 0;
    }else
        return indexPath.row % 2 == 1 ? 10 : listHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MallBCItem *item = [[MallBCItem alloc] initWithDic:_mallBCModel.Data[indexPath.section]];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:item.MallList[indexPath.row / 2]];
    MallBCListItem *listItem = [[MallBCListItem alloc] initWithDic:dic];
    
    if (indexPath.row % 2 == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *identifier = @"BusinessAreaCell";
        GJGShopListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.item = listItem;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MallBCItem *item = [[MallBCItem alloc] initWithDic:_mallBCModel.Data[indexPath.section]];
    MallBCListItem *listItem = [[MallBCListItem alloc] initWithDic:item.MallList[indexPath.row / 2]];
#pragma mark -- 数据埋点
    [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201010040002
                                                    andBCID:_bcId
                                                  andMallID:[NSString stringWithFormat:@"%ld", (long)listItem.ID]
                                                  andShopID:nil
                                                andItemType:nil
                                            andBusinessType:item.TypeKey
                                                  andItemID:nil
                                                andItemText:nil
                                                andOpUserID:[UserDBManager shareManager].UserID];
    
    if(indexPath.row % 2 == 0){
        ShopCenterController *controller = [[ShopCenterController alloc] init];
        if ([item.TypeKey isEqualToString:@"shoppingcenter"] || [item.TypeKey  isEqualToString:@"departmentstore"]) {
            //购物中心
            controller.type = 1;
        }else{
            //电器卖场
            controller.type = 2;
        }
        controller.bcId = _bcId;
        controller.typeKey = item.TypeKey;
        controller.mId = [NSString stringWithFormat:@"%ld", (long)listItem.ID];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
@end
