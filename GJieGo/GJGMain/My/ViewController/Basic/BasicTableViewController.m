//
//  BasicTableViewController.m
//  GJieGo
//
//  Created by dujinxin on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicTableViewController.h"

@interface BasicTableViewController ()

@end

@implementation BasicTableViewController

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
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)dealloc{
    
}
- (void)loadView{
    [super loadView];
    
    _page = 1;
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_tableView.sectionHeaderHeight = 10;
    _tableView.sectionFooterHeight = 0.1;
    _tableView.backgroundColor = JXF1f1f1Color;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavStatusHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  * cellIdentifier = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - RefreshAndLoadMore
- (void)refresh:(NSInteger)page{
    _page = 1;
}
- (void)loadMore:(NSInteger)page{
    _page ++;
}
- (void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

@end
