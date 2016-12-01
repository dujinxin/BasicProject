//
//  GUListViewController.m
//  GJieGo
//
//  Created by dujinxin on 16/5/30.
//  Copyright © 2016年 yangzx. All rights reserved.
//
//  系统名称：GUListViewController
//  功能描述：导购&用户列表(guider&user)
//  修改记录：(仅记录功能修改)

#import "GUListViewController.h"
#import "OrderGuiderView.h"
#import "LevelView.h"
#import "AttentionEntity.h"

@interface GUListViewController ()
@end

@implementation GUListViewController

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

    [self requestWithPage:self.page];

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refresh:_page];
    }];

}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.view.backgroundColor = JXF1f1f1Color;

    [_tableView removeFromSuperview];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_tableView.sectionHeaderHeight = 10;
    _tableView.sectionFooterHeight = 0.1;
    _tableView.backgroundColor = JXF1f1f1Color;
    [self.view addSubview:_tableView];
    
    [self  layoutSubView];
}

- (void)layoutSubView{
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  * cellIdentifier = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        OrderGuiderView * guiderView = [[OrderGuiderView alloc ]initWithStyle:OrderGuiderStyleSubtitle];
        guiderView.tag = 10;
        guiderView.userImageView.layer.cornerRadius = 20;
        [cell.contentView addSubview:guiderView];
        [guiderView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(0);
            make.top.equalTo(cell.contentView).offset(0);
            make.bottom.equalTo(cell.contentView).offset(0);
            make.right.equalTo(cell.contentView.right).offset(-65);
        }];
        
        LevelView * levelView = [[LevelView alloc ]initWithFrame:CGRectMake(140, 40, 80, 11)];
        levelView.tag = 11;
        [cell.contentView addSubview:levelView];
        
        UIView * line = [[UIView alloc ]initWithFrame:CGRectMake(0, 69.5, kScreenWidth, 0.5)];
        line.backgroundColor = JXSeparatorColor;
        [cell.contentView addSubview:line];
    }
    OrderGuiderView * guiderView = (OrderGuiderView *)[cell.contentView viewWithTag:10];
    //guiderView.userImageView.image = JXImageNamed(@"list_icon_privilege");
    LevelView * levelView = (LevelView *)[cell.contentView viewWithTag:11];
    
    
    AttentionEntity * entity;
    if (_type == Guider) {
        entity = _dataArray[indexPath.row];
    }else{
        entity = _dataArray[indexPath.row];
        
    }
    guiderView.nameLabel.text = entity.UserName;
    guiderView.detailLabel.text = [NSString stringWithFormat:@"%@人关注",entity.FollowNum];
    [guiderView.userImageView sd_setImageWithURL:[NSURL URLWithString:entity.HeadPortrait] placeholderImage:JXImageNamed(@"portrait_default")];
    [levelView setLevelNum:[NSString stringWithFormat:@"V%@",entity.UserLevel] levelTitle:entity.UserLevelName];
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_type == Guider) {
//        AttentionGuiderEntity * entity = _dataArray[indexPath.row];
//        GuideHomeViewController *home = [[GuideHomeViewController alloc] init];
//        home.gid = entity.UserId.integerValue;
//        home.statisticChatOfHome = ID_0201080180003;
//        [self.navigationController pushViewController:home animated:YES];
    }else {
//        AttentionEntity * entity = _dataArray[indexPath.row];
//        UserHomeViewController *userHomeVC = [[UserHomeViewController alloc] init];
//        userHomeVC.userId = entity.UserId.integerValue;
//        [self.navigationController pushViewController:userHomeVC animated:YES];
    }
}
#pragma mark - RefreshAndLoadMore
- (void)requestWithPage:(NSUInteger)page{
    if (self.type == Guider){
        self.urlStr = kApiGuideAttentionList;
    }else{
        self.urlStr = kApiUserAttentionList;
    }
    [[UserRequest shareManager] userGuiderAttentionList:self.urlStr param:@{@"page":@(page)} type:self.type success:^(id object,NSString *msg) {
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
        if (70 *_dataArray.count >(kScreenHeight -64 -35)){
            MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [self loadMore:self.page];
            }];
            _tableView.mj_footer = footer;
        }
    } failure:^(id object,NSString *msg) {
        //
        [self showJXNoticeMessage:msg];
    }];
}
- (void)refresh:(NSInteger)page{
    [super refresh:page];
    [[UserRequest shareManager] userGuiderAttentionList:self.urlStr param:@{@"page":@(self.page)} type:self.type success:^(id object,NSString *msg) {
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
    [[UserRequest shareManager] userGuiderAttentionList:self.urlStr param:@{@"page":@(self.page)} type:self.type success:^(id object,NSString *msg) {
        [self endRefresh];
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
        
    } failure:^(id object,NSString *msg) {
        [self endRefresh];
    }];
}
- (void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
@end
