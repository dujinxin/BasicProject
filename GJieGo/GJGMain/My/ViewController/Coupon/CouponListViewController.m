//
//  CouponListViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/29.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "CouponListViewController.h"
#import "CouponDetailViewController.h"
#import "PayCouponCell.h"


@interface CouponListViewController ()

@end

@implementation CouponListViewController

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
    
    self.urlStr = kApiUserFansList;
//    [self showLoadView];
    [[UserRequest shareManager] userCouponList:kApiUserCouponList param:@{@"Cp":@(self.page)} success:^(id object,NSString *msg) {
//        [self hideLoadView];
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
        if (107 *kPercent *_dataArray.count >(kScreenHeight -64)){
            MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [self loadMore:self.page];
            }];
            _tableView.mj_footer = footer;
        }
    } failure:^(id object,NSString *msg) {
//        [self hideLoadView];
        [self showJXNoticeMessage:msg];
    }];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.title = @"我的优惠特权";
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refresh:self.page];
    }];
    
}
#pragma mark - subView init

- (void)layoutSubView{
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavStatusHeight);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107*kPercent;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView FooterForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  * cellIdentifier = @"cellId";
    PayCouponCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PayCouponCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.type = MyCouponListType;
    }
    CouponEntity * entity = _dataArray[indexPath.row];
    [cell setCouponContent:entity indexPath:indexPath];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CouponEntity * entity = _dataArray[indexPath.row];
    CouponDetailViewController * dvc = [[CouponDetailViewController alloc ]init ];
    dvc.cid = entity.CouponID;
    [self.navigationController pushViewController:dvc animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//要求委托方的编辑风格在表视图的一个特定的位置。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;//设置删除风格
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[_dataArray count]) {
            [_dataArray removeObjectAtIndex:indexPath.row];//移除数据源的数据
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
        }
    }
}
#pragma mark - RefreshAndLoadMore
- (void)refresh:(NSInteger)page{
    [super refresh:page];
    [[UserRequest shareManager] userCouponList:kApiUserCouponList param:@{@"Cp":@(self.page)} success:^(id object,NSString *msg) {
        [self endRefresh];
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
        
    } failure:^(id object,NSString *msg) {
        [self endRefresh];
        [self showJXNoticeMessage:msg];
    }];
    
}
- (void)loadMore:(NSInteger)page{
    [super loadMore:page];
    [[UserRequest shareManager] userCouponList:kApiUserCouponList param:@{@"Cp":@(self.page)} success:^(id object,NSString *msg) {
        [self endRefresh];
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
        
    } failure:^(id object,NSString *msg) {
        [self endRefresh];
        [self showJXNoticeMessage:msg];
    }];
}
@end
