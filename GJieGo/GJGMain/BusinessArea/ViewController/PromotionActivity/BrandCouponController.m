//
//  BrandCouponController.m
//  GJieGo
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 品牌优惠券 ---

#import "BrandCouponController.h"
#import "GJGSelectorBar.h"
#import "BrandCouponTableCell.h"
#import "FreshFoodCollectionController.h"
#import "BrandCouponListTableCell.h"
#import "CouponListController.h"//优惠券列表
#import "CouponDetailController.h"//优惠券详情
#import "RunTypeMallModel.h"
#import "CouponTypeModel.h"

@interface BrandCouponController ()<UITableViewDataSource, UITableViewDelegate>{
    UIView *statusBackView;
    
    NSInteger selectViewHeight;     //分类选择框高度
    NSInteger once;
    NSInteger page;
    
    NSMutableArray *classArray;     //选择分类数组
    NSMutableArray *couponArray;    //优惠券数据
    NSInteger classId;              //分类id
    
}
@property (nonatomic, strong)GJGSelectorBar *topSelectView;
@property (nonatomic, strong)BaseTableView *couponTableView;
@end

@implementation BrandCouponController
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
    if (once == 0)      [self.couponTableView.mj_header beginRefreshing];
    once ++;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    
    classArray = [NSMutableArray array];
    couponArray = [NSMutableArray array];
    self.view.backgroundColor = GJGRGB16Color(0xf1f1f1);

    once = 0;
    page = 1;
    if (self.sourceArray.count > 0) {
        classId = [self.sourceArray[0][@"DicID"] integerValue];
    }
    
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
                [_couponTableView.mj_header beginRefreshing];
            }
        }
    }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    [self creatTableViewUI];
    
}

#pragma mark - loadData
- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:@{@"Mid":self.mId, @"Type":[NSString stringWithFormat:@"%ld", classId], @"Cp":[NSString stringWithFormat:@"%ld", page]}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_CouponType) parameters:param requestblock:^(id responseobject, NSError *error) {
        if ([responseobject[@"status"] integerValue] == 0) {
            if (page == 1) {
                couponArray == nil ? (couponArray = [NSMutableArray array]) : ([couponArray removeAllObjects]);
                [_couponTableView.mj_header endRefreshing];
            }else{
                if ([responseobject[@"data"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:responseobject[@"data"]];
                    if (array.count < 20) {
                        [_couponTableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [_couponTableView.mj_footer endRefreshing];
                    }
                }else{
                    [_couponTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            CouponTypeModel *model = [[CouponTypeModel alloc] initWithDic:responseobject];
            for (int i = 0; i < model.Data.count; i++) {
                [couponArray addObject:model.Data[i]];
            }
           [_couponTableView reloadData]; 
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
    }];
}
#pragma mark - Update data

- (void)updateData {
    
        page = 1;
    
        [self loadData];
//        [_couponTableView.mj_header endRefreshing];
}

- (void)updateMoreData {
    
        page++;
        [self loadData];
//        [_couponTableView.mj_footer endRefreshing];
}

- (void)creatTableViewUI{
    
    NSInteger h = 0;
    selectViewHeight == 44 ? (h = 5) : (h = 0);
    self.couponTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, (64 + h + selectViewHeight), ScreenWidth, (ScreenHeight - 64 - selectViewHeight - h))];
    self.couponTableView.dataSource = self;
    self.couponTableView.delegate = self;
    self.couponTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.couponTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.couponTableView.backgroundColor = GJGRGB16Color(0xf1f1f1);
    [self.couponTableView registerClass:[BrandCouponListTableCell class] forCellReuseIdentifier:@"BrandCouponListTableCell"];
    [self.view addSubview:self.couponTableView];
    self.couponTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self updateData];
    }];
    self.couponTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        
        [self updateMoreData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return couponArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 178;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BrandCouponListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandCouponListTableCell"];
    CouponTypeItem *item = [[CouponTypeItem alloc] initWithDic:couponArray[indexPath.row]];
    
    cell.brandLabel.text = item.ShopName;
    cell.titleLabel.text = item.ShopName;
    cell.subTitleLabel.text = item.CouponName;
    cell.couponLabel.text = item.DiscountDesc;
    cell.ruleLabel.text = [NSString stringWithFormat:@"每个用户可领取%ld张", item.QuantityLimit];
    cell.timeLabel.text = [NSString stringWithFormat:@"限用时间：%@", item.AvailableTime];
    [cell.getButton setTitle:@"领取" forState:UIControlStateNormal];
    cell.getButton.tag = indexPath.row;
    cell.getButton.tag = item.CouponID;
    [cell.getButton addTarget:self action:@selector(didClickGetButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.moreButton addTarget:self action:@selector(didClickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.moreButton.tag = indexPath.row;
    [cell.couponButton addTarget:self action:@selector(didClickCouponButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.couponButton.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - push 优惠券详情页
- (void)didClickCouponButton:(UIButton *)button{
    CouponTypeItem *item = [[CouponTypeItem alloc] initWithDic:couponArray[button.tag]];
    
    CouponDetailController * controller = [[CouponDetailController alloc] init];
    controller.title = @"优惠券详情";
    controller.cId = [NSString stringWithFormat:@"%ld", item.CouponID];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 领取优惠券
- (void)didClickGetButton:(UIButton *)button{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:@{@"Cid":[NSString stringWithFormat:@"%ld", button.tag]}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_Coupon) parameters:param requestblock:^(id responseobject, NSError *error) {
        [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
    }];

}
//点击更多
- (void)didClickMoreButton:(UIButton *)button{
    CouponTypeItem *item = [[CouponTypeItem alloc] initWithDic:couponArray[button.tag]];
    CouponListController *controller = [[CouponListController alloc] init];
    controller.title = @"优惠券";
    controller.shopId = [NSString stringWithFormat:@"%ld", item.ShopID];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
