//
//  AboutViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/28.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "AboutViewController.h"
#import "IntroductionViewController.h"
#import "DetailWebViewController.h"

static CGFloat PayBillViewHeight = 221;

@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIView         * _headView;
}

@end

@implementation AboutViewController

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
//    [self showLoadView];
    [[UserRequest shareManager] userAboutUs:kApiAboutUs param:nil success:^(id object,NSString *msg) {
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
    self.title = @"关于我们";
    [self setHeadView];
    [self layoutSubView];
}
#pragma mark - subView init

- (void)setHeadView{
    
    _headView = [[UIView alloc ]init ];
    _headView.backgroundColor = JXF1f1f1Color;
    _headView.frame=CGRectMake(0, -PayBillViewHeight, kScreenWidth, PayBillViewHeight);
    
    
    _tableView.scrollEnabled = NO;
    _tableView.sectionFooterHeight = 0.1;
    [_tableView addSubview:_headView];
    
    _tableView.contentInset = UIEdgeInsetsMake(PayBillViewHeight, 0, 0, 0);
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    UIImageView * bgImageView = [[UIImageView alloc]init];
    bgImageView.frame = CGRectMake(0, -PayBillViewHeight, kScreenWidth, PayBillViewHeight);
    
    [_tableView addSubview:bgImageView];
    
    UIImageView * _userImageView=[[UIImageView alloc]init];
    _userImageView.image=[UIImage imageNamed:@"logo_image"];
    _userImageView.frame=CGRectMake((kScreenWidth-106)/2, 53, 106, 106);
    _userImageView.layer.cornerRadius = 20;
    _userImageView.clipsToBounds = YES;
    [_headView addSubview:_userImageView];
    
    
    //
    UILabel * _infoLabel=[[UILabel alloc] init];
    _infoLabel.text=[NSString stringWithFormat:@"版本信息：v%@",kAppVersion];
    _infoLabel.textAlignment=NSTextAlignmentCenter;
    _infoLabel.font = JXFontForNormal(15);
    _infoLabel.textColor = JX333333Color;
    _infoLabel.frame=CGRectMake(CGRectGetMinX(_userImageView.frame) -50, CGRectGetMaxY(_userImageView.frame)+14, CGRectGetWidth(_userImageView.frame) +100, 15);
    [_headView addSubview:_infoLabel];
    
    UILabel * _numLabel = [[UILabel alloc] init];
    _numLabel.text=@"检查更新";
    _numLabel.textAlignment=NSTextAlignmentCenter;
    _numLabel.font = JXFontForNormal(12);
    _numLabel.textColor = JX999999Color;
    _numLabel.frame = CGRectMake(0, CGRectGetMaxY(_infoLabel.frame)+10, kScreenWidth, 12);
//    [_headView addSubview:_numLabel];
    
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
- (void)back:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  * cellIdentifier = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = JX333333Color;
        cell.textLabel.font = JXFontForNormal(13);
        
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 20, 17.5, 5, 9)];
        [arrow setImage:JXImageNamed(@"list_arrow")];
        [cell.contentView addSubview:arrow];
        
        
        UIView * line = [[UIView alloc ]initWithFrame:CGRectMake(0, 43.5, kScreenWidth, 0.5)];
        line.backgroundColor = JXSeparatorColor;
        [cell.contentView addSubview:line];
    }
    SettingEntity * entity = _dataArray[indexPath.row];
    cell.textLabel.text = entity.InfoTitle;
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    switch (indexPath.row) {
//        case 0:
//        {
//            IntroductionViewController * rvc = [[IntroductionViewController alloc] init];
//            rvc.type = IntroductionPrivateType;
//            [self.navigationController pushViewController:rvc animated:YES];
//        }
//            break;
//        case 1:
//        {
//            IntroductionViewController * rvc = [[IntroductionViewController alloc] init];
//            rvc.type = IntroductionCompanyType;
//            [self.navigationController pushViewController:rvc animated:YES];
//        }
//            break;
//        case 2:
//        {
//            IntroductionViewController * rvc = [[IntroductionViewController alloc] init];
//            rvc.type = IntroductionTeamType;
//            [self.navigationController pushViewController:rvc animated:YES];
//        }
//            break;
//            
//        default:
//            break;
//    }

    SettingEntity * entity = _dataArray[indexPath.row];
    DetailWebViewController * rvc = [[DetailWebViewController alloc] init];
    rvc.urlStr = entity.Url;
    rvc.title = entity.InfoTitle;
    [self.navigationController pushViewController:rvc animated:YES];
}

@end
