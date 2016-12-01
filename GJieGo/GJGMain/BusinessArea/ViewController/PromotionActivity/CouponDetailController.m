//
//  CouponDetailController.m
//  GJieGo
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 优惠券详情 ---

#import "CouponDetailController.h"
#import "MapOfMainViewController.h"
#import "BrandCouponTableCell.h"
#import "CouponDetailTableCell.h"
#import "CouponDetailModel.h"

@interface CouponDetailController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>{
    UIView *statusBackView;
    CouponDetailItem* _detailItem;
}
@property (nonatomic, strong)BaseTableView *couponDetailTableView;
@end

@implementation CouponDetailController
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
    
    [self creatRightButton];
    [self creatTableViewUI];
    [self loadData];
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:@{@"Cid":_cId}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_CouponDetail) parameters:param requestblock:^(id responseobject, NSError *error) {
        if ([responseobject[@"status"] integerValue] == 0) {
            CouponDetailModel *model = [[CouponDetailModel alloc] initWithDic:responseobject];
            _detailItem = [[CouponDetailItem alloc] initWithDic:model.Data];
            [_couponDetailTableView reloadData];
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
    }];
}
#pragma mark - Update data

- (void)updateData {
    
        [self loadData];
        [_couponDetailTableView.mj_header endRefreshing];
}

- (void)creatTableViewUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.couponDetailTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    self.couponDetailTableView.dataSource = self;
    self.couponDetailTableView.delegate = self;
    self.couponDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.couponDetailTableView.rowHeight = UITableViewAutomaticDimension;
    self.couponDetailTableView.estimatedRowHeight = 44.0;
    self.couponDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.couponDetailTableView.backgroundColor = GJGRGB16Color(0xf1f1f1);
    [self.view addSubview:self.couponDetailTableView];
    self.couponDetailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self updateData];
    }];
}

#pragma mark - share
- (void)didClickShareButton:(UIButton *)button{
    [[LBRequestManager sharedManager] getSharedInfoWithInfoId:[self.cId integerValue]
                                                     infoType:GJGShareInfoTypeIsCoupon
                                                       result:^(id responseobject, NSError *error)
     {
         if (!error) {
             GJGShareInfo *shareInfo = responseobject;
             [[ShareManager shareManager] showCustomShareViewWithContent:shareInfo.Content
                                                                   title:shareInfo.Title
                                                                imageUrl:shareInfo.Images
                                                                     url:shareInfo.Url
                                                             description:@""
                                                                  infoId:self.cId
                                                               shareType:UserCouponShareType
                                                     presentedController:self
                                                                 success:^(id object, UserShareSns sns){}
                                                                 failure:^(id object, UserShareSns sns) {
                                                                     NSLog(@"分享失败.");
                                                                 }];
//             [[ShareManager shareManager] showCustomShareViewWithContent:shareInfo.Content
//                                                                   title:shareInfo.Title
//                                                                imageUrl:shareInfo.Images
//                                                                     url:shareInfo.Url
//                                                             description:@""
//                                                     presentedController:self
//                                                                 success:^(id object, UserShareSns sns)
//              {
//                  [MBProgressHUD showSuccess:@"分享成功!" toView:self.view];
//              } failure:^(id object, UserShareSns sns){
//
//              }];
         }
     }];
}

- (void)creatRightButton{
    UIImage *image = [UIImage imageNamed:@"title_btn_share"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom tag:0 title:@"" titleSize:0 frame:CGRectMake(0, 0, image.size.width + 20, image.size.height + 20) Image:image target:self action:@selector(didClickShareButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}
#pragma mark -- 点击领取
- (void)didClickGetButton:(UIButton *)button{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:@{@"Cid":[NSString stringWithFormat:@"%ld", button.tag]}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_Coupon) parameters:param requestblock:^(id responseobject, NSError *error) {
        [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 124;
    }else if (indexPath.row % 2 == 1 && indexPath.row != 0){
        return 5;
    }else if(indexPath.row == 2){
        return 44;
    }else{
        return 208;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *identifier = @"CouponListCell";
        BrandCouponTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[BrandCouponTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.titleLabel.text = _detailItem.ShopName;//@"新百伦（西单商场店）";
        cell.subTitleLabel.text = _detailItem.CouponName;//@"夏季新款满减";
        cell.couponLabel.text = _detailItem.DiscountDesc;//@"满500-50";
        cell.ruleLabel.text = [NSString stringWithFormat:@"每个用户可领取%ld张", _detailItem.QuantityLimit];
        cell.timeLabel.text = [NSString stringWithFormat:@"限用时间：%@", _detailItem.AvailableTime];
        [cell.getButton setTitle:@"领取" forState:UIControlStateNormal];
        [cell.getButton addTarget:self action:@selector(didClickGetButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.getButton.tag = _detailItem.CouponID;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.row % 2 == 1 && indexPath.row != 0){
        static NSString *identifier = @"alpha";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = GJGRGB16Color(0xf1f1f1);
        return cell;
    }else if(indexPath.row == 2){
        static NSString *identifier = @"alpha";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 44)];
        lineView.backgroundColor = GJGRGB16Color(0xfee333);
        [cell addSubview:lineView];
        cell.textLabel.text = @"可用门店";
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
        cell.tintColor = GJGRGB16Color(0x333333);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *identifier = @"CouponDetailTableCell";
        CouponDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[CouponDetailTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell.CouponImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@55W_1o", _detailItem.ShopImage]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cell.titleLabel.text = _detailItem.ShopName;
        cell.addressLabel.text = [NSString stringWithFormat:@"地址：%@", _detailItem.ShopAddress];
        cell.distanceLabel.text = [NSString stringWithFormat:@"%@", [self changeDistanceClass:_detailItem.Distance]];
        cell.ruleLabel.text = _detailItem.Rules;
        [cell.distanceButton addTarget:self action:@selector(pushMapView:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)pushMapView:(UIButton *)button{
    MapOfMainViewController *mapVC = [[MapOfMainViewController alloc] init];
    mapVC.shopName = _detailItem.ShopName;
    mapVC.shopAddress = _detailItem.ShopAddress;
    mapVC.shopLocation = [[CLLocation alloc] initWithLatitude:_detailItem.Latitude longitude:_detailItem.Longitude];
    
    [self.navigationController pushViewController:mapVC animated:YES];

}

@end
