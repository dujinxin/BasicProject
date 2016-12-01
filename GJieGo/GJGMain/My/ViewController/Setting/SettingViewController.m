//
//  SettingViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/28.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "SettingViewController.h"
#import "ForgetViewController.h"
#import "AboutViewController.h"
#import "RegisterViewController.h"
#import "UserEntity.h"
#import <CloudPushSDK/CloudPushSDK.h>

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView      *   _tableView;
    NSMutableArray   *   _notificationArray;
    BOOL                 _isHasNews;
    
    UIButton         *   _logoutButton;
}

@end

@implementation SettingViewController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
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
    _isHasNews = YES;
    NSArray * textArray = @[@"修改密码",@"新消息通知",@"关于我们"];
    _notificationArray = [NSMutableArray array ];
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
    
    for (int i = 0; i< textArray.count ; i++) {
        NSString * str = textArray[i];
        CGRect rect = [str boundingRectWithSize:CGSizeMake(kScreenWidth, 20) options:option attributes:attributes context:nil];
        NSDictionary * dict = @{@"text":str,@"rect":[NSValue valueWithCGRect:rect]};
        [_notificationArray addObject:dict];
    }
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.title = @"设置";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
    _tableView.backgroundColor = JXF1f1f1Color;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionFooterHeight = 0.1;
    [self.view addSubview:_tableView];
    
    _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_logoutButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [_logoutButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
    [_logoutButton setBackgroundColor:jxRGB210Color];
    _logoutButton.layer.cornerRadius = 5.f;
    [_logoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_logoutButton];
    
    [self  layoutSubView];
}

- (void)layoutSubView{
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavStatusHeight);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.equalTo(260);
    }];
    [_logoutButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(44);
    }];
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _notificationArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  * cellIdentifier = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = JX333333Color;
        cell.textLabel.font = JXFontForNormal(13);
        
        NSDictionary * dict = _notificationArray[indexPath.row];
        CGRect rect = [[dict objectForKey:@"rect"] CGRectValue];
        UILabel * text = [[UILabel alloc ] initWithFrame:CGRectMake(15, 0, rect.size.width, 44)];
        //        text.backgroundColor = [UIColor blueColor];
        text.font = [UIFont systemFontOfSize:13];
        text.tag = 10;
        [cell.contentView addSubview:text];
        
        if (indexPath.row != 1) {
            UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 20, 17, 5, 9)];
            [arrow setImage:JXImageNamed(@"list_arrow")];
            [cell.contentView addSubview:arrow];
        }else{
            UILabel * detailText = [[UILabel alloc ] initWithFrame:CGRectMake(text.jxRight, 0, kScreenWidth - text.jxWidth -30, 44)];
            detailText.font = [UIFont systemFontOfSize:12];
            detailText.tag = 11;
            detailText.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:detailText];
        }
        
        
        UIView * line = [[UIView alloc ]initWithFrame:CGRectMake(0, 43.5, kScreenWidth, 0.5)];
        line.backgroundColor = JXSeparatorColor;
        [cell.contentView addSubview:line];
    }
    NSDictionary * dict = _notificationArray[indexPath.row];
    UILabel * text = [cell.contentView viewWithTag:10];
    UILabel * detailText = [cell.contentView viewWithTag:11];
    text.text = dict[@"text"];
    if (indexPath.row == 1) {
        UIUserNotificationSettings * setttings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (setttings.types == UIUserNotificationTypeNone){
            detailText.text = @"请到设置-通知中心中开启吧！";
        }else{
            detailText.text = @"您已经开启了通知提醒！";
        }
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            RegisterViewController * rvc = [[RegisterViewController alloc] init];
            rvc.accountType = UserModifyPasswordType;
            [self.navigationController pushViewController:rvc animated:YES];
        }
            break;
        case 1:
        {
            UIUserNotificationSettings * setttings = [[UIApplication sharedApplication] currentUserNotificationSettings];
            if (setttings.types == UIUserNotificationTypeNone){
                NSURL *url = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID&path=com.guangjiegou.GJieGo"];
                if ([[UIApplication sharedApplication] canOpenURL:url])
                {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }
            break;
        case 2:
        {
            AboutViewController * avc = [[AboutViewController alloc ]init ];
            [self.navigationController pushViewController:avc  animated:YES];
        }
            break;
    }
}

- (void)logout:(UIButton *)button{

    [self showLoadView];
    [[UserRequest shareManager] userExit:kApiUserExit param:nil success:^(id object,NSString *msg) {
        //
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res) {
                if (res.success){
                    NSLog(@"阿里推送解绑账号成功");
                }else{
                    NSLog(@"阿里推送解绑账号失败：%@",res.error);
                }
            }];

            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            [[LoginManager shareManager] logOut];
            EMError *error = [[EMClient sharedClient] logout:YES];
            [[UserDBManager shareManager] deleteToken];
            
            [kUserDefaults removeObjectForKey:UDKEY_MobileNumber];
            [kUserDefaults removeObjectForKey:UDKEY_Password];
            [kUserDefaults synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!error) {
                    //                [weakSelf showHint:error.errorDescription];
                    NSLog(@"环信退出成功");
                }
                else{
                    //[[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                    NSLog(@"环信退出失败：%@",error.errorDescription);

                }
            });
            NSString * parameterStr = [DJXNetworkConfig commonParameter:nil longitude:@0 latitude:@0];
            [[UserRequest shareManager] userShortToken:kGJGRequestUrl_v_cp(kApiVersion,kApiUserShortToken,parameterStr) param:@{@"Uc":[DJXNetworkConfig tokenStr:nil]} success:^(id object,NSString *msg) {
                [self hideLoadView];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(id object,NSString *msg) {
                [self hideLoadView];
            }];
        });
    } failure:^(id object,NSString *msg) {
        [self hideLoadView];
    }];
    
}
@end
