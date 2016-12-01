//
//  HelpViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/28.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "HelpViewController.h"
#import "IntroductionViewController.h"
#import "FeedbackViewController.h"
#import "DetailWebViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

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
    //@{@"page":@(self.page)}
    [[UserRequest shareManager] userNormalFAQ:kApiNormalFAQ param:nil success:^(id object,NSString *msg) {
        //        [self hideLoadView];
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
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
    self.title = @"帮助与反馈";
    
    _tableView.contentInset = UIEdgeInsetsMake(70, 0, 0, 0);
    
    UIView * _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.frame =CGRectMake(0, -70, kScreenWidth, 60);
    [_tableView addSubview:_bgView];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kScreenWidth, 60);
    [button setTitle:@"意见反馈" forState:UIControlStateNormal];
    [button setTitleColor:JX333333Color forState:UIControlStateNormal];
    [button setImage:JXImageNamed(@"editor") forState:UIControlStateNormal];
    button.titleLabel.font = JXFontForNormal(15);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [button addTarget:self action:@selector(feedback) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:button];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count +1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  * cellIdentifier = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = JX333333Color;
        cell.textLabel.font = JXFontForNormal(13);
        
        if (indexPath.row != 0) {
            UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 20, 17, 5, 9)];
            [arrow setImage:JXImageNamed(@"list_arrow")];
            [cell.contentView addSubview:arrow];
        }
        UIView * line = [[UIView alloc ]initWithFrame:CGRectMake(0, 43.5, kScreenWidth, 0.5)];
        line.backgroundColor = JXSeparatorColor;
        [cell.contentView addSubview:line];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"常见问题：";
    }else{
        NormalFAQEntity * entity = _dataArray[indexPath.row -1];
        cell.textLabel.text = entity.InfoTitle;
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0){
//        IntroductionViewController * fvc = [[IntroductionViewController alloc ] init ];
//        fvc.type = IntroductionOrderType;
//        [self.navigationController pushViewController:fvc animated:YES];
        
        NormalFAQEntity * entity = _dataArray[indexPath.row -1];
        DetailWebViewController * rvc = [[DetailWebViewController alloc] init];
        rvc.urlStr = entity.Url;
        rvc.title = entity.InfoTitle;
        rvc.infoId = entity.InfoId;
        [self.navigationController pushViewController:rvc animated:YES];
    }
}

#pragma click events 
- (void)feedback{
    [[LoginManager shareManager] checkUserLoginState:^{
        FeedbackViewController * fvc = [[FeedbackViewController alloc ] init];
        [self.navigationController pushViewController:fvc animated:YES];
    }];
}

@end
