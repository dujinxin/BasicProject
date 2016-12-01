//
//  ShopingCenterDetailController.m
//  GJieGo
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 购物中心详情 ---

#import "ShopingCenterDetailController.h"
#import "ShopingCenterDetailTopView.h"
#import "ShopingCenterDetailServiceView.h"
#import "BusinessInfoController.h"
#import "ShopFeedbackController.h"
#import "MallDetailModel.h"

#define shopCenterDetailTopHeight 187
//#define shopingCenterDetailServiceHeight (80)//70+10

@interface ShopingCenterDetailController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>{
    UIView *statusBackView;
    UITableView *shopingCenterTableView;
    
    NSArray *listArray;
    NSArray *mallArray;
    
    NSInteger shopingCenterDetailServiceHeight;
    
    MallDetailModel *_mallDetailModel;
    MallDetailItem *_item;
}
@property (nonatomic, strong)ShopingCenterDetailTopView *shopingCenterDetailTopView;
@property (nonatomic, strong)ShopingCenterDetailServiceView* shopingCenterDetailServiceView;
@property (nonatomic, strong)UIView *tableTopView;
@end

@implementation ShopingCenterDetailController
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

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    shopingCenterDetailServiceHeight = 80;
    
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
   
     self.automaticallyAdjustsScrollViewInsets = NO;
    [self setRightNavigationItemAction];
    [self loadData];
}

#pragma mark - request method
- (void)loadData{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *reqStr = kGet_MallDetails;
    if ([self.vcClass isEqualToString:@"mall"]) {
        
        [param addEntriesFromDictionary:@{@"Mid":_mallId}];
        reqStr = kGet_MallDetails;
        mallArray = [[NSArray alloc] initWithObjects:
                     @{@"imageName":@"list_icon_record", @"name":@"商场介绍", @"num":@"1"},
                     @{@"imageName":@"list_icon_fans", @"name":@"招商合作", @"num":@"2"},
//                     @{@"imageName":@"list_icon_invitation", @"name":@"招聘精英", @"num":@"3"},
//                     @{@"imageName":@"mall_list_icon_center", @"name":@"问题中心", @"num":@"4"},
                     @{@"imageName":@"list_icon_help", @"name":@"商场留言", @"num":@"8"},
                     nil];
    }else{
        
        [param addEntriesFromDictionary:@{@"ShopId":_shopId}];
        reqStr = kGet_ShopDetail;
        mallArray = [[NSArray alloc] initWithObjects:
                     @{@"imageName":@"list_icon_record", @"name":@"店铺介绍", @"num":@"1"},
                     @{@"imageName":@"list_icon_invitation", @"name":@"招聘精英", @"num":@"3"},
//                     @{@"imageName":@"mall_list_icon_center", @"name":@"问题中心", @"num":@"4"},
                     @{@"imageName":@"list_icon_help", @"name":@"店铺留言", @"num":@"8"},
                     nil];
    }
    [request requestPostTypeWithUrl:kGJGRequestUrl(reqStr) parameters:param requestblock:^(id responseobject, NSError *error) {
        if ([responseobject[@"status"] integerValue] == 0) {
            _mallDetailModel = [[MallDetailModel alloc] initWithDic:responseobject];
            [self creatTableView];
        }else{
            
            [self.view makeToast:responseobject[@"message"] duration:1 position:CSToastPositionCenter];
        }
        [shopingCenterTableView.mj_header endRefreshing];
    }];

    }

#pragma mark - Update data
- (void)updateData {
    
    [self loadData];
}

#pragma mark - create table
- (void)creatTableView{
    _item = [[MallDetailItem alloc] initWithDic:_mallDetailModel.Data];
    self.title = [_item.Name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (_item.Services.count > 0) {
        shopingCenterDetailServiceHeight = 10 + 70 * ceilf(_item.Services.count / 4.0);
    }else{
        shopingCenterDetailServiceHeight = 0;
        self.shopingCenterDetailServiceView.hidden = YES;
    }
    self.tableTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, shopCenterDetailTopHeight + shopingCenterDetailServiceHeight)];
    self.shopingCenterDetailTopView = [[ShopingCenterDetailTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, shopCenterDetailTopHeight) backImageName:_item.Image businessName:_item.Name subName:_item.Address time:_item.BusinessHours];
    if (_item.BusinessHours.length > 0) {
        self.shopingCenterDetailTopView.timeInfoLabel.hidden = NO;
    }else{
        self.shopingCenterDetailTopView.timeInfoLabel.hidden = YES;
    }
    if ([self.vcClass isEqualToString:@"mall"]){
        self.shopingCenterDetailServiceView = [[ShopingCenterDetailServiceView alloc] initWithFrame:CGRectMake(0, shopCenterDetailTopHeight, ScreenWidth, shopingCenterDetailServiceHeight) sourceArray:_item.Services serviceName:@"商场服务"];
    }else{
        self.shopingCenterDetailServiceView = [[ShopingCenterDetailServiceView alloc] initWithFrame:CGRectMake(0, shopCenterDetailTopHeight, ScreenWidth, shopingCenterDetailServiceHeight) sourceArray:_item.Services serviceName:@"店铺服务"];
    }
    
    [self.tableTopView addSubview:self.shopingCenterDetailTopView];
    [self.tableTopView addSubview:self.shopingCenterDetailServiceView];
    shopingCenterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    shopingCenterTableView.dataSource = self;
    shopingCenterTableView.delegate = self;
    shopingCenterTableView.tableHeaderView = self.tableTopView;
    shopingCenterTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:shopingCenterTableView];
    [shopingCenterTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ShopingCenterDetailController"];
    shopingCenterTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self updateData];
    }];
}

- (void)setRightNavigationItemAction{
    UIButton *cellphoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *cellphoneImage = [UIImage imageNamed:@"mall_title_phone"];
    cellphoneButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [cellphoneButton setImage:cellphoneImage forState:UIControlStateNormal];
    cellphoneButton.frame = CGRectMake(30, 30, 23, 23);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cellphoneButton];
    [cellphoneButton addTarget:self action:@selector(clickCellphone) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - actionSheet - delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_item.PhoneNumber]]];
    }
}
- (void)clickCellphone{
    if (_item.PhoneNumber != nil) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:_item.PhoneNumber, nil];
        [actionSheet showInView:self.view];
    }else{
        [self.view makeToast:@"电话号码获取失败，请刷新后重试" duration:2 position:CSToastPositionCenter];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mallArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopingCenterDetailController"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = mallArray[indexPath.row];
//    cell.imageView.image = [UIImage imageNamed:dic[@"imageName"]];
    cell.textLabel.text = dic[@"name"];
    cell.textLabel.textColor = GJGRGB16Color(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:mallArray[indexPath.row]];
    if ([dic[@"name"] isEqualToString:@"店铺留言"] || [dic[@"name"] isEqualToString:@"商场留言"]){
        [[LoginManager shareManager] checkUserLoginState:^{
            ShopFeedbackController *controller = [[ShopFeedbackController alloc] init];
            if ([self.vcClass isEqualToString:@"mall"]) {
                controller.It = @"2";
                controller.Id = _mallId;
            }else{
                controller.It = @"3";
                controller.Id = _shopId;
            }
            controller.title = dic[@"name"];
            [self.navigationController pushViewController:controller animated:YES];
        }];
    }else{
        BusinessInfoController *controller = [[BusinessInfoController alloc] init];
        controller.title = dic[@"name"];
        NSDictionary *dict;
        if ([self.vcClass isEqualToString:@"mall"]) {
            controller.viewRequest = kGet_MallProperty;
            dict = @{@"Mid":[NSString stringWithFormat:@"%ld", _item.MallID], @"Pt":dic[@"num"]};
        }else{
            controller.viewRequest = kGet_ShopProperty;
            dict = @{@"ShopId":[NSString stringWithFormat:@"%ld", _item.ShopID], @"Pt":dic[@"num"]};
        }
        controller.requestDic = dict;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
@end
