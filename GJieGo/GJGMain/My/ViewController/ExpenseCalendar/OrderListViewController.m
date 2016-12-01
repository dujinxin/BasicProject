//
//  OrderListViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/27.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListCell.h"
#import "OrderDetailViewController.h"

@interface OrderListViewController ()
@end

@implementation OrderListViewController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [[UserRequest shareManager] userOrderList:kApiUserOrderList param:@{@"Cp":@(self.page)} success:^(id object,NSString *msg) {
        //
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
        if (70 *_dataArray.count >(kScreenHeight -64)){
            MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [self loadMore:self.page];
            }];
            _tableView.mj_footer = footer;
        }
    } failure:^(id object,NSString *msg) {
        //
        
    }];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.title = @"订单";
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 182;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  * cellIdentifier = @"cellId";
    OrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OrderListCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        cell = [[[NSBundle mainBundle ] loadNibNamed:@"OrderListCell" owner:self options:nil] lastObject];
        cell.backgroundView.backgroundColor = JXEeeeeeColor;
        cell.contentView.backgroundColor = JXEeeeeeColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    OrderEntity * entity = _dataArray[indexPath.row];
    [cell setOrderListCell:entity indexPath:indexPath];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderEntity * entity = _dataArray[indexPath.row];
    OrderDetailViewController * dvc = [[OrderDetailViewController alloc ] init ];
    dvc.orderId = entity.OrderID;
    [self.navigationController pushViewController:dvc animated:YES];
}
#pragma mark - RefreshAndLoadMore
- (void)refresh:(NSInteger)page{
    [super refresh:page];
    [[UserRequest shareManager] userOrderList:kApiUserOrderList param:@{@"Cp":@(self.page)} success:^(id object,NSString *msg) {
        [self endRefresh];
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
        
    } failure:^(id object,NSString *msg) {
        [self endRefresh];
    }];
    
}
- (void)loadMore:(NSInteger)page{
    [super loadMore:page];
    [[UserRequest shareManager] userOrderList:kApiUserOrderList param:@{@"Cp":@(self.page)} success:^(id object,NSString *msg) {
        [self endRefresh];
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
        
    } failure:^(id object,NSString *msg) {
        [self endRefresh];
    }];
}
@end
