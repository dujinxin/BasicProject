//
//  CouponListController.m
//  GJieGo
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 优惠券列表 ---

#import "CouponListController.h"
#import "BrandCouponTableCell.h"
#import "CouponDetailController.h"
#import "CouponTypeModel.h"

@interface CouponListController ()<UITableViewDataSource, UITableViewDelegate>{
    UIView *statusBackView;
    
    NSMutableArray *sourceArray;
    
    NSInteger page;
    NSInteger once;
}
@property (nonatomic, strong)BaseTableView *couponTableView;
@end

@implementation CouponListController
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
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    
    sourceArray = [NSMutableArray array];
    
    once = 0;
    page = 1;
    
    [self creatTableView];
}

- (void)viewDidAppear:(BOOL)animated{
    if(once == 0)  [self.couponTableView.mj_header beginRefreshing];
    once ++;
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

#pragma mark - loadData
- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:@{@"ShopId":_shopId, @"Cp":[NSString stringWithFormat:@"%ld", page]}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_CouponShop) parameters:param requestblock:^(id responseobject, NSError *error) {
        if ([responseobject[@"status"] integerValue] == 0) {
            if (page == 1) {
                sourceArray == nil ? (sourceArray = [NSMutableArray array]) : ([sourceArray removeAllObjects]);
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
            CouponTypeModel *couponModel = [[CouponTypeModel alloc] initWithDic:responseobject];
            if (couponModel.Data.count > 0) {
                for (int i = 0; i < couponModel.Data.count; i ++) {
                    [sourceArray addObject:couponModel.Data[i]];
                }
                
            }else{
            }
//            [_couponTableView.mj_header endRefreshing];
            [_couponTableView reloadData];
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
    }];
}

- (void)creatTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.couponTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    self.couponTableView.backgroundColor = GJGRGB16Color(0xf1f1f1);
    self.couponTableView.dataSource = self;
    self.couponTableView.delegate = self;
    self.couponTableView.rowHeight = UITableViewAutomaticDimension;
    self.couponTableView.estimatedRowHeight = 44.0;
    self.couponTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.couponTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.couponTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.couponTableView registerClass:[BrandCouponTableCell class] forCellReuseIdentifier:@"BrandCouponTableCell"];
    [self.view addSubview:self.couponTableView];
    self.couponTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self updateData];
    }];
    self.couponTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        
        [self updateMoreData];
    }];
}
#pragma mark --领取优惠券
- (void)didClickGetButton:(UIButton *)button{
       
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:@{@"Cid":[NSString stringWithFormat:@"%ld", button.tag]}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_Coupon) parameters:param requestblock:^(id responseobject, NSError *error) {
        [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
    }];
}
#pragma mark -- TableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sourceArray.count;//array.count * 2
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.row % 2 == 1) ? 5 : 124;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CouponTypeItem *item = [[CouponTypeItem alloc] initWithDic:sourceArray[indexPath.row / 2]];
    
    if (indexPath.row % 2 == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = GJGRGB16Color(0xf1f1f1);
        return cell;
    }else{
        
        BrandCouponTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandCouponTableCell"];
        cell.titleLabel.text = item.ShopName;//@"新百伦（西单商场店）";
        cell.subTitleLabel.text = item.CouponName;//@"夏季新款满减";
        cell.couponLabel.text = item.DiscountDesc;//@"满500-50";
        cell.ruleLabel.text = [NSString stringWithFormat:@"每个用户可领取%ld张", item.QuantityLimit];
        cell.timeLabel.text = [NSString stringWithFormat:@"限用时间：%@", item.AvailableTime];
        [cell.getButton setTitle:@"领取" forState:UIControlStateNormal];
        [cell updateConstraints];
        cell.getButton.tag = item.CouponID;
        [cell.getButton addTarget:self action:@selector(didClickGetButton:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponTypeItem *item = [[CouponTypeItem alloc] initWithDic:sourceArray[indexPath.row / 2]];
    CouponDetailController *controller = [[CouponDetailController alloc] init];
    controller.title = @"优惠券详情";
    controller.cId = [NSString stringWithFormat:@"%ld", item.CouponID];
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
