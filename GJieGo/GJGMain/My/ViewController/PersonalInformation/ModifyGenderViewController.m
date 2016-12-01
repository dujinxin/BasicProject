//
//  ModifyGenderViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/26.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "ModifyGenderViewController.h"
#import "UserEntity.h"

@interface ModifyGenderViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView * _tableView;
    NSArray     * _genderArr;
}

@end

@implementation ModifyGenderViewController

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
    
    _genderArr = @[@"男",@"女"];
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    
    self.navigationItem.leftBarButtonItem = [self getNavigationItem:self selector:@selector(cancel:) title:JXLocalizedString(@"Cancel") style:kDefault];
    self.navigationItem.rightBarButtonItem = [self getNavigationItem:self selector:@selector(save:) title:JXLocalizedString(@"Save") style:kDefault];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionHeaderHeight = 10;
    _tableView.sectionFooterHeight = 0.1;
    _tableView.backgroundColor = JXF1f1f1Color;
    [self.view addSubview:_tableView];
    [self  layoutSubView];
}

- (void)layoutSubView{
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavStatusHeight);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}
#pragma mark - click events
- (void)cancel:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)save:(UIButton *)button{
    [self showLoadView];
    [[UserRequest shareManager] userGender:kApiUserGender param:@{@"Gd":_gender} success:^(id object,NSString *msg) {
        //
        [self hideLoadView];
        if ([[UserDBManager shareManager] modifyUserGender:[NSString stringWithFormat:@"%@",_gender]]){
            [self showJXNoticeMessage:msg];
            if (_block) {
                self.block(_gender);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(id object,NSString *msg) {
        //
        [self hideLoadView];
        [self showJXNoticeMessage:msg];
    }];
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _genderArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  * cellIdentifier = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = JX333333Color;
        cell.textLabel.font = JXFontForNormal(13);
        
        
        UIImageView * userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 30, 15, 15, 12)];
        userImageView.tag = 10;
        [cell.contentView addSubview:userImageView];
        
        UIView * line = [[UIView alloc ]initWithFrame:CGRectMake(0, 43.5, kScreenWidth, 0.5)];
        line.backgroundColor = JXSeparatorColor;
        [cell.contentView addSubview:line];
    }
    cell.textLabel.text = _genderArr[indexPath.row];
    UIImageView * userImageView = (UIImageView *)[cell.contentView viewWithTag:10];
    if (_gender.intValue == indexPath.row) {
        userImageView.image = JXImageNamed(@"Rounded-Rectangle-2-copy-57");
    }else{
        userImageView.image = nil;
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (UITableViewCell * cell in tableView.visibleCells) {
        UIImageView * userImageView = (UIImageView *)[cell.contentView viewWithTag:10];
        userImageView.image = nil;
    }
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView * userImageView = (UIImageView *)[cell.contentView viewWithTag:10];
    userImageView.image = JXImageNamed(@"Rounded-Rectangle-2-copy-57");
    _gender = @(indexPath.row);
}

@end
