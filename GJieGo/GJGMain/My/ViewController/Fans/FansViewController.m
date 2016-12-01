//
//  FansViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/5/9.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "FansViewController.h"
#import "OrderGuiderView.h"
#import "LevelView.h"
#import "FansEntity.h"

@interface FansViewController ()

@end

@implementation FansViewController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage = nil;
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
    [[UserRequest shareManager] userFansList:kApiUserFansList param:@{@"page":@(self.page)} success:^(id object,NSString *msg) {
        //
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
        if (70 *_dataArray.count >(kScreenHeight -64)){
            MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [self loadMore:self.page];
            }];
            _tableView.mj_footer = footer;
        }
    } failure:^(id object,NSString *msg) {}];
    
    [FansNumberObj requestWithBlock:kApiUserFansNumber param:nil success:^(id object,NSString *msg) {
        if ([object isKindOfClass:[NSString class]]) {
            if ([(NSString *)object length]) {
                [self showJXNoticeMessage:object];
            }
        }
    } failure:^(id object,NSString *msg) {}];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.title = @"粉丝";
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refresh:_page];
    }];
    [self layoutSubView];
}

- (void)layoutSubView{
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavStatusHeight);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}
#pragma mark - Click events
- (void)attention:(UIButton *)button{
    FansEntity * entity = _dataArray[button.tag -100];
    NSString * cancel;
    if (entity.IsLiked.integerValue == 1) {
        cancel = @"false";
    }else{
        cancel = @"true";
    }
    
    [[UserRequest shareManager] userAttented:kApiUserAttented param:@{@"followId":entity.UserID,@"cancel":cancel} success:^(id object,NSString *msg) {
        //
        if (entity.IsLiked.integerValue == 1) {
            [button setTitle:@"已关注" forState:UIControlStateNormal];
            [button setTitleColor:JX999999Color forState:UIControlStateNormal];
            button.layer.borderColor = JXMainColor.CGColor;
            button.layer.borderWidth = 1.f;
            button.backgroundColor = JXClearColor;
            
            [self showJXNoticeMessage:msg];
            entity.IsLiked = @"0";
        }else{
            [button setTitle:@"+关注" forState:UIControlStateNormal];
            [button setTitleColor:JXFfffffColor forState:UIControlStateNormal];
            button.backgroundColor = JXMainColor;
            button.layer.borderColor = JXMainColor.CGColor;
            button.layer.borderWidth = 0.f;
            [self showJXNoticeMessage:msg];
            entity.IsLiked = @"1";
        }
        [_dataArray replaceObjectAtIndex:button.tag -100 withObject:entity];
        
    } failure:^(id object,NSString *msg) {
        [self showJXNoticeMessage:msg];
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
        
        
        UIButton * attention = [UIButton buttonWithType:UIButtonTypeCustom];
        attention.frame = CGRectMake(kScreenWidth -65, 20, 50, 30);
        [attention addTarget:self action:@selector(attention:) forControlEvents:UIControlEventTouchUpInside];
        attention.tag = indexPath.row + 100;
        attention.titleLabel.font = JXFontForNormal(12);
        [attention setTitleColor:JXFfffffColor forState:UIControlStateNormal];
        [attention setTitle:@"+关注" forState:UIControlStateNormal];
        attention.backgroundColor = JXMainColor;
        [cell.contentView addSubview:attention];
        
        UIView * line = [[UIView alloc ]initWithFrame:CGRectMake(0, 69.5, kScreenWidth, 0.5)];
        line.backgroundColor = JXSeparatorColor;
        [cell.contentView addSubview:line];
    }
    
    FansEntity * entity = _dataArray[indexPath.row]; 
    OrderGuiderView * guiderView = (OrderGuiderView *)[cell.contentView viewWithTag:10];
    [guiderView.userImageView sd_setImageWithURL:[NSURL URLWithString:entity.UserImage] placeholderImage:JXImageNamed(@"portrait_default")];
    guiderView.nameLabel.text = entity.UserName;
    guiderView.detailLabel.text = [NSString stringWithFormat:@"%@人关注",entity.LikedNumber];
    
    LevelView * levelView = (LevelView *)[cell.contentView viewWithTag:11];
    [levelView setLevelNum:[NSString stringWithFormat:@"V%@",entity.Level] levelTitle:entity.LevelName];
    
    UIButton * attention = (UIButton *)[cell.contentView viewWithTag:indexPath.row +100];
    if (entity.IsLiked.integerValue == 1) {
        [attention setTitleColor:JXFfffffColor forState:UIControlStateNormal];
        [attention setTitle:@"+关注" forState:UIControlStateNormal];
        attention.backgroundColor = JXMainColor;
        attention.layer.borderColor = JXMainColor.CGColor;
        attention.layer.borderWidth = 0.f;
    }else{
        [attention setTitle:@"已关注" forState:UIControlStateNormal];
        [attention setTitleColor:JX999999Color forState:UIControlStateNormal];
        attention.layer.borderColor = JXMainColor.CGColor;
        attention.layer.borderWidth = 1.f;
        attention.backgroundColor = JXClearColor;
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    FansEntity * entity = _dataArray[indexPath.row];
//    UserHomeViewController *userHomeVC = [[UserHomeViewController alloc] init];
//    userHomeVC.userId = entity.UserID.integerValue;
//    [self.navigationController pushViewController:userHomeVC animated:YES];
}
#pragma mark - RefreshAndLoadMore
- (void)refresh:(NSInteger)page{
    [super refresh:page];
    [[UserRequest shareManager] userFansList:self.urlStr param:@{@"page":@(self.page)} success:^(id object,NSString *msg) {
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
    [[UserRequest shareManager] userFansList:self.urlStr param:@{@"page":@(self.page)} success:^(id object,NSString *msg) {
        [self endRefresh];
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
        
    } failure:^(id object,NSString *msg) {
        [self endRefresh];
    }];
}

@end
