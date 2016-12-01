//
//  GirlClothesListController.m
//  GJieGo
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 女装 ---

#import "GirlClothesListController.h"
#import "FilmClassController.h"
#import "ShopMallTableCell.h"
#import "ShopTypeModel.h"
#import "ShopInMallTypeModel.h"
#import "GeneralMarketController.h"
#import "RestaurantClassController.h"

@interface GirlClothesListController ()<UITableViewDataSource, UITableViewDelegate>{
    UIView *statusBackView;
    
    NSMutableArray * _sourceArray;
    
    NSInteger once;
    NSInteger page;
}

@property (nonatomic, strong)BaseTableView *listTableView;

@end

@implementation GirlClothesListController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundColor:COLOR(254, 227, 48, 1)];
    [self.navigationController.navigationBar addSubview:statusBackView];
}

- (void)viewDidAppear:(BOOL)animated{
    if (once == 0) {
        once ++;
        [self.listTableView.mj_header beginRefreshing];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [statusBackView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    once = 0;
    page = 1;
    
    _sourceArray = [NSMutableArray array];
    
    [self gainData];
    [self creatUI];
    
}
- (void)gainData{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:@{@"Mid":self.mId, @"Type":self.type, @"Cp":[NSString stringWithFormat:@"%ld", page]}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_ShopInMallType) parameters:param requestblock:^(id responseobject, NSError *error) {
        if ([responseobject[@"status"] integerValue] == 0) {
            if (page == 1) {
                _sourceArray == nil ? (_sourceArray = [NSMutableArray array]) : ([_sourceArray removeAllObjects]);
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
            ShopInMallTypeModel *model = [[ShopInMallTypeModel alloc] initWithDic:responseobject];
            if (model.Data.count > 0) {
                for (int i = 0; i < model.Data.count; i++) {
                    
                    [_sourceArray addObject:model.Data[i]];
                }
                
            }else{
            }
            [_listTableView reloadData];
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
    }];
}
- (void)creatUI{
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.listTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    self.listTableView.backgroundColor = [UIColor whiteColor];
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.listTableView registerClass:[ShopMallTableCell class] forCellReuseIdentifier:@"ShopMallTableCell"];
    [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.listTableView];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self updateData];
    }];
    _listTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        
        [self updateMoreData];
    }];
}

#pragma mark - Update data

- (void)updateData {
    
    page = 1;
    [self gainData];

}

- (void)updateMoreData {
    
    page++;
    [self gainData];
}

#pragma mark - Init some config

- (void)initAttributes {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - tableView dataSource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sourceArray.count * 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row % 2 == 0 ? listHeight : 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 2 == 0) {// && _dataSource.count != 0
        ShopInMallTypeItem * item = [[ShopInMallTypeItem alloc] initWithDic:_sourceArray[indexPath.row / 2]];
        ShopMallTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopMallTableCell"];
        [cell.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%dW_1o", item.Image, (int)cell.bounds.size.width]] placeholderImage:[UIImage imageNamed:@"default_landscape_normal"]];
        cell.nameLabel.text = item.ShopName;
        cell.floorAddressLabel.text = item.Floor;
        cell.strowLabel.text = [NSString stringWithFormat:@"%ld", item.Collection];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopInMallTypeItem * item = [[ShopInMallTypeItem alloc] initWithDic:_sourceArray[indexPath.row / 2]];
    #pragma mark -- 数据埋点
    [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201010010005
                                                    andBCID:self.bcId
                                                  andMallID:self.mId
                                                  andShopID:[NSString stringWithFormat:@"%ld",item.ShopID]
                                            andBusinessType:item.TypeKey
                                                  andItemID:nil
                                                andItemText:nil
                                                andOpUserID:[UserDBManager shareManager].UserID];
    
    if ([item.TypeKey isEqualToString:@"supermarket"]) {//超市    ②③
        GeneralMarketController *controller = [[GeneralMarketController alloc] init];
        controller.shopId = [NSString stringWithFormat:@"%ld", item.ShopID];
        controller.bcId = self.bcId;
        controller.TypeKey = item.TypeKey;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([item.TypeKey isEqualToString:@"cafe"] || [item.TypeKey isEqualToString:@"hotel"] || [item.TypeKey isEqualToString:@"ktv"] || [item.TypeKey isEqualToString:@"restaurant"]){//咖啡店、酒店、KTV、美食  ①②
        RestaurantClassController *controller = [[RestaurantClassController alloc] init];
        controller.shopId = [NSString stringWithFormat:@"%ld", item.ShopID];
        controller.bcId = self.bcId;
        controller.TypeKey = item.TypeKey;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else{//影院、亲子、甜点饮品、美业、酒吧、健身、培训、足疗按摩、宠物店 ②
        FilmClassController *controller = [[FilmClassController alloc] init];
        controller.shopId = [NSString stringWithFormat:@"%ld", item.ShopID];
        controller.bcId = self.bcId;
        controller.TypeKey = item.TypeKey;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
@end
