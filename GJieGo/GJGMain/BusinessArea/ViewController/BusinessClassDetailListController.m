//
//  BusinessClassDetailListController.m
//  GJieGo
//
//  Created by apple on 16/5/7.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 败家列表 ---

#import "BusinessClassDetailListController.h"
#import "GJGBusinessClassDetailCell.h"
#import "BusinessInfoController.h"
#import "FilmClassController.h"
#import "RestaurantClassController.h"
#import "ShopTypeModel.h"
#import "GeneralMarketController.h"

@interface BusinessClassDetailListController ()<UITableViewDataSource, UITableViewDelegate>{
    NSInteger page;
    NSInteger once;
    UIView *statusBackView;
    NSMutableArray *_dataSource;
}

@property (nonatomic, strong)BaseTableView *listTableView;
@end

@implementation BusinessClassDetailListController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundColor:COLOR(254, 227, 48, 1)];
    [self.navigationController.navigationBar addSubview:statusBackView];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(once == 0)  [self.listTableView.mj_header beginRefreshing];
    once ++;
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
    
    once = 0;
    page = 1;
    _dataSource = [[NSMutableArray alloc] init];
    
    [self creatListTableView];
}

- (void)creatListTableView{
    self.listTableView = [[BaseTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    self.listTableView.backgroundColor = [UIColor whiteColor];
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.listTableView];
    
    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self updateData];
    }];
    self.listTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [self updateMoreData];
    }];
}

#pragma mark - Update data
- (void)updateData {
    page = 1;
    [self loadListData];
}

- (void)updateMoreData {
    page++;
    [self loadListData];
}

- (void)loadListData{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:@{@"BcId":_bcId, @"Type":_Type, @"Cp":[NSString stringWithFormat:@"%ld", page]}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_ShopType) parameters:parameters requestblock:^(id responseobject, NSError *error) {
        if ([responseobject[@"status"] integerValue] == 0) {
            
            if (page == 1) {
                [_dataSource removeAllObjects];
                [_listTableView.mj_header endRefreshing];
            }else{
                if ([responseobject[@"data"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:responseobject[@"data"]];
                    if (array.count < 20) {
                        [_listTableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [_listTableView.mj_footer endRefreshing];
                    }
                }else{
                    [_listTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
            ShopTypeModel *_shopTypeModel = [[ShopTypeModel alloc] initWithDic:responseobject];
            if (_shopTypeModel.Data.count > 0) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:responseobject[@"data"]];
                for (int i = 0; i < array.count; i ++) {
                    [_dataSource addObject:array[i]];
                }
            }else{
            }
            [_listTableView reloadData];
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark - tableDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count * 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row % 2 == 0 ? listHeight : 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataSource[indexPath.row / 2];
    ShopTypeItem *item = [[ShopTypeItem alloc] initWithDic:dic];
    
    if (indexPath.row % 2 == 1) {
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        static NSString *identifier = @"GJGBusinessClassDetailCell";
        GJGBusinessClassDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[GJGBusinessClassDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%dW_1o", item.Image, (int)cell.bounds.size.width]] placeholderImage:[UIImage imageNamed:@"default_portrait_less"]];
        cell.nameLabel.text = item.ShopName;
        cell.addressLabel.text = item.MallName;
        cell.floorAddressLabel.text = item.Floor;
        cell.strowLabel.text = [NSString stringWithFormat:@"%ld", item.Collection];
        cell.distanceLabel.text = [self changeDistanceClass:item.Distance];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataSource[indexPath.row / 2];
    ShopTypeItem *item = [[ShopTypeItem alloc] initWithDic:dic];
#pragma mark -- 数据埋点
    [[GJGStatisticManager sharedManager] statisticByEventID:self.eventID
                                                    andBCID:_bcId
                                                  andMallID:nil
                                                  andShopID:[NSString stringWithFormat:@"%ld", item.ShopID]
                                                andItemType:self.Type
                                            andBusinessType:item.TypeKey
                                                  andItemID:nil
                                                andItemText:self.businessName
                                                andOpUserID:[UserDBManager shareManager].UserID];
    
    if ([item.TypeKey isEqualToString:@"supermarket"]) {//超市    ②③
        GeneralMarketController *controller = [[GeneralMarketController alloc] init];
        controller.shopId = [NSString stringWithFormat:@"%ld", item.ShopID];
        controller.bcId = self.bcId;
        controller.TypeKey = item.TypeKey;
        controller.dicID = self.Type;
        controller.dicName = self.businessName;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([item.TypeKey isEqualToString:@"cafe"] || [item.TypeKey isEqualToString:@"hotel"] || [item.TypeKey isEqualToString:@"ktv"] || [item.TypeKey isEqualToString:@"restaurant"]){//咖啡店、酒店、KTV、美食  ①②
        RestaurantClassController *controller = [[RestaurantClassController alloc] init];
        controller.shopId = [NSString stringWithFormat:@"%ld", item.ShopID];
        controller.bcId = self.bcId;
        controller.TypeKey = item.TypeKey;
        controller.dicName = self.businessName;
        [self.navigationController pushViewController:controller animated:YES];

    }else{//影院、亲子、甜点饮品、美业、酒吧、健身、培训、足疗按摩、宠物店 ②
        FilmClassController *controller = [[FilmClassController alloc] init];
        controller.shopId = [NSString stringWithFormat:@"%ld", item.ShopID];
        controller.bcId = self.bcId;
        controller.TypeKey = item.TypeKey;
        controller.dicName = self.businessName;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
