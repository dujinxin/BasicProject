//
//  ShopCenterListController.m
//  GJieGo
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "ShopCenterListController.h"
#import "GJGShopListCell.h"
#import "ShopCenterController.h"
#import "MallBCModel.h"

@interface ShopCenterListController ()<UITableViewDataSource, UITableViewDelegate>{
    UIView *statusBackView;
    NSInteger once;
    NSInteger page;
    MallBCItem *_mallItem;
}
@property (nonatomic, strong)BaseTableView *shopCenterListTableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@end

@implementation ShopCenterListController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundColor:COLOR(254, 227, 48, 1)];
    [self.navigationController.navigationBar addSubview:statusBackView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [statusBackView removeFromSuperview];
    if (once == 0) {
        [self.shopCenterListTableView.mj_header beginRefreshing];
    }
    once ++;
}

- (void)creatShopCenterListTableViewUI{
    self.shopCenterListTableView = [[BaseTableView alloc] init];
    self.shopCenterListTableView.dataSource = self;
    self.shopCenterListTableView.delegate = self;
    self.shopCenterListTableView.estimatedRowHeight = 44.f;
    self.shopCenterListTableView.rowHeight = UITableViewAutomaticDimension;
    self.shopCenterListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.shopCenterListTableView];
    [self.shopCenterListTableView registerClass:[GJGShopListCell class] forCellReuseIdentifier:@"ShopCenterListcell"];
    [self.shopCenterListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.shopCenterListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.shopCenterListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self updateData];
    }];
    self.shopCenterListTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        
        [self updateMoreData];
    }];
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundColor:COLOR(254, 227, 48, 1)];
    once = 0;
    page = 1;
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    self.view.backgroundColor = [UIColor whiteColor];
    self.sourceArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    [self creatShopCenterListTableViewUI];
}

#pragma mark - Update data

- (void)updateData {
    
    page = 1;
    [self getMallByTypeMethed];
}

- (void)updateMoreData {
    
    page ++;
    [self getMallByTypeMethed];    
}

#pragma mark - DataRequest
- (void)getMallByTypeMethed{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:@{@"Bcid":[NSString stringWithFormat:@"%ld", self.bcId], @"bId":[NSString stringWithFormat:@"%ld", self.bId], @"Cp":[NSString stringWithFormat:@"%ld", page]}];
    [request requestUrl:kGJGRequestUrl(kGet_MallType) requestType:RequestPostType parameters:param requestblock:^(id responseobject, NSError *error) {
        
        if ([responseobject[@"status"] integerValue] == 0) {
            if (page == 1) {
                _sourceArray == nil ? (_sourceArray = [NSMutableArray array]) : ([_sourceArray removeAllObjects]);
                [_shopCenterListTableView.mj_header endRefreshing];
            }else{
                if ([responseobject[@"data"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:responseobject[@"data"]];
                    if (array.count < 20) {
                        [_shopCenterListTableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [_shopCenterListTableView.mj_footer endRefreshing];
                    }
                }else{
                    [_shopCenterListTableView.mj_footer endRefreshingWithNoMoreData];
                }
                
            }
            MallBCModel *model = [[MallBCModel alloc] initWithDic:responseobject];
            if (model.Data.count > 0) {
                _mallItem = [[MallBCItem alloc] initWithDic:model.Data[0]];
                NSMutableArray *array = [NSMutableArray arrayWithArray:_mallItem.MallList];
                for (int i = 0; i < array.count; i++) {
                    [_sourceArray addObject:array[i]];
                }
                
            }else{
                NSLog(@"没有更多可加载数据");
            }
            [_shopCenterListTableView reloadData];
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
    }];
}
#pragma mark -- tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sourceArray.count * 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row % 2 == 1 ? 10 : listHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MallBCListItem *item = [[MallBCListItem alloc] initWithDic:_sourceArray[indexPath.row / 2]];
    
    if (indexPath.row % 2 == 0) {
        GJGShopListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCenterListcell"];
        cell.item = item;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MallBCListItem *listItem = [[MallBCListItem alloc] initWithDic:_sourceArray[indexPath.row / 2]];
    ShopCenterController *controller = [[ShopCenterController alloc] init];
#pragma mark -- 数据埋点
    [[GJGStatisticManager sharedManager] statisticByEventID:self.eventID
                                                    andBCID:[NSString stringWithFormat:@"%ld",self.bcId]
                                                  andMallID:[NSString stringWithFormat:@"%ld",listItem.ID]
                                                  andShopID:nil
                                            andBusinessType:self.TypeKey
                                                  andItemID:nil
                                                andItemText:nil
                                                andOpUserID:[UserDBManager shareManager].UserID];
    
    if ([self.TypeKey isEqualToString:@"shoppingcenter"] || [self.TypeKey  isEqualToString:@"departmentstore"]) {
        //购物中心
        controller.type = 1;
            }else{
        //电器卖场
        controller.type = 2;
    }
    controller.bcId = [NSString stringWithFormat:@"%ld",_bcId];
    controller.typeKey = self.TypeKey;
    controller.mId = [NSString stringWithFormat:@"%ld", listItem.ID];
        [self.navigationController pushViewController:controller animated:YES];

}
@end
