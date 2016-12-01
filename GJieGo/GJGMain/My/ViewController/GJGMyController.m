//
//  MyViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/25.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "GJGMyController.h"
#import "LevelView.h"

#import "LoginViewController.h"

#import "NotificationViewController.h"
#import "ModifyInformationViewController.h"

#import "PayScanViewController.h"
#import "AttentionViewController.h"
#import "ChatListViewController.h"
#import "ConversationListViewController.h"
#import "OrderListViewController.h"

#import "RecordListViewController.h"
#import "CouponListViewController.h"
#import "CollectionListViewController.h"
#import "LevelViewController.h"

#import "FansViewController.h"

#import "SettingViewController.h"
#import "HelpViewController.h"

#import "MyInvitationViewController.h"

static CGFloat MyHeadViewHeight = 225;

@interface GJGMyController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    UIView       * navigationBar;
    UIView       * navigationBarBackgroundView;
    UILabel      * titleView;
    UIButton     * right;
    UIView       * badgeView;
    
    UIView       * _headView;
    UIImageView  * bgImageView;
    UITapGestureRecognizer * _loginTap;
    UILabel      * redLabel;
    
    UITableView  * _tableView;
    
    UserDetailEntity * _userDetailEntity;
    UIImageView  * _userImageView;
    LevelView    * _levelView;
    UILabel      * _nameLabel;
    
    NSArray      * _defaultArray;
    
}

@property (nonatomic, strong) UITapGestureRecognizer * loginTap;
@end

@implementation GJGMyController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
    
    _isShowNavigationBar = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if ([LoginManager shareManager].isHadLogin) {
//        [self showLoadView];
        [[UserRequest shareManager] userDetail:kApiUserDetail param:@{@"userId":[UserDBManager shareManager].UserID} success:^(id object,NSString *msg) {
//            [self hideLoadView];
            _userDetailEntity = (UserDetailEntity *)object;
            [_headView removeGestureRecognizer:_loginTap];
            [_userImageView sd_setImageWithURL:[NSURL URLWithString:_userDetailEntity.HeadPortrait] placeholderImage:JXImageNamed(@"portrait_default")];
            _nameLabel.text = _userDetailEntity.UserName;
            [_levelView setHidden:NO];
            
            CGRect frame = _levelView.frame;
            frame.size.width = kScreenWidth;
            _levelView.frame = frame;
            [_levelView setLevelNum:[NSString stringWithFormat:@"V%@",_userDetailEntity.UserLevel] levelTitle:_userDetailEntity.UserLevelName];
            
        } failure:^(id object,NSString *msg) {
//            [self hideLoadView];
            [self showJXNoticeMessage:msg];
        } showLoadView:self.view animated:YES];
        //通知
//        if ([[NotificationManager shareManager]isHasUnReadMessages]) {
        if ([[NotificationManager shareManager]isHasNews]) {
            //新建小红点
            if (!badgeView) {
                badgeView = [[UIView alloc]init];
                badgeView.layer.cornerRadius = 5.f;
                badgeView.backgroundColor = [UIColor redColor];
                badgeView.frame = CGRectMake(22, 10, 10, 10);
            }
            [right addSubview:badgeView];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBadge:YES];
        }else{
            [badgeView removeFromSuperview];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBadge:NO];
        }
        //聊天
        NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
        NSInteger unreadCount = 0;
        for (EMConversation *conversation in conversations) {
            unreadCount += conversation.unreadMessagesCount;
        }
        if (unreadCount >0) {
            NSString * str;
            if (unreadCount >99) {
                str = @"99";
            }else{
                str = [NSString stringWithFormat:@"%ld",(long)unreadCount];
            }
            redLabel.text = str;
            redLabel.hidden = NO;
        }else{
            redLabel.hidden = YES;
        }
        
    }else{
        _isShowNavigationBar = YES;

        _userDetailEntity = nil;
        [_headView addGestureRecognizer:self.loginTap];
        _userImageView.image = JXImageNamed(@"portrait_default");
        _nameLabel.text = @"登录";
        [_levelView setHidden:YES];
        
        redLabel.hidden = YES;
        [badgeView removeFromSuperview];
        [(AppDelegate *)[UIApplication sharedApplication].delegate showBadge:NO];
    }
    
    [_tableView reloadData];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (!_isShowNavigationBar) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad{
    [super viewDidLoad];

    _defaultArray = @[
                      @[
                        @{@"title":@"Coupons",@"image":@"list_icon_privilege"},
                        @{@"title":@"Records",@"image":@"list_icon_record"},
                        @{@"title":@"Favorites",@"image":@"list_icon_collect"},
                        @{@"title":@"Level",@"image":@"list_icon_level"}
                          ],
                      @[
                          @{@"title":@"Follower",@"image":@"list_icon_fans"},
                          @{@"title":@"Share",@"image":@"list_icon_friends_share"}
                          ],
                      @[
                          @{@"title":@"Settings",@"image":@"list_icon_setting"},
                          @{@"title":@"Help",@"image":@"list_icon_help"}
                          ],
                      @[
                          @{@"title":@"Invitation",@"image":@"list_icon_invitation"},
                          @{@"title":@"OpenShop",@"image":@"list_icon_open_shop"}
                          ],
                      @[
                          @{@"title":@"Service",@"image":@"list_icon_phon"},
                          ]
                      ];
    //测试。。。。。。。
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hasUnReadSystemMessages:)
                                                 name:HasUnreadSystemMessagesNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hasUnReadChatMessages:)
                                                 name:HasUnreadChatMessagesNotification
                                               object:nil];
    
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HasUnreadSystemMessagesNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HasUnreadChatMessagesNotification object:nil];
}
- (void)loadView{
    [super loadView];
    
    [self setHeadView];
    [self setNavigationBar];
}

#pragma mark - subView init
-(void)setNavigationBar{

//    UIButton * left = [UIButton buttonWithType:UIButtonTypeCustom];
//    [left setTitle:@"聊天" forState:UIControlStateNormal];
//    left.titleLabel.font = JXFontForNormal(13);
//    [left addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    right = [UIButton buttonWithType:UIButtonTypeCustom];
    //[right setImage:JXImageNamed(@"title_icon_notice") forState:UIControlStateNormal];
    [right setImage:[JXImageNamed(@"title_icon_notice") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    right.tintColor = [UIColor whiteColor];
    [right addTarget:self action:@selector(notificationEvent:) forControlEvents:UIControlEventTouchUpInside];
    navigationBar = [self setNavigationBar:@"我的" backgroundColor:JXMainColor leftItem:nil rightItem:right delegete:self];
    navigationBar.frame = CGRectMake(0, 0, kScreenWidth, 64);
    navigationBarBackgroundView = [navigationBar viewWithTag:10];
    navigationBarBackgroundView.alpha = 0;
    titleView = [navigationBar viewWithTag:11];
    [self.view addSubview:navigationBar];

}

- (void)setHeadView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.sectionHeaderHeight = 10;
    _tableView.sectionFooterHeight = 0.1;
    [self.view addSubview:_tableView];
    [self  layoutSubView];
    
    _tableView.contentInset = UIEdgeInsetsMake(MyHeadViewHeight +71*kPercent, 0, 0, 0);
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    bgImageView = [[UIImageView alloc]init];
    bgImageView.frame = CGRectMake(0, -MyHeadViewHeight-71*kPercent, kScreenWidth, MyHeadViewHeight );
    bgImageView.image = [UIImage imageNamed:@"bg"];
    bgImageView.userInteractionEnabled = YES;
    [_tableView addSubview:bgImageView];
    
    
    //
    _headView = [[UIView alloc]init];
    _headView.backgroundColor =[UIColor clearColor];
    _headView.frame = CGRectMake(0, -MyHeadViewHeight-71*kPercent, kScreenWidth, MyHeadViewHeight +71*kPercent);
    [_tableView addSubview:_headView];
    
    
    //
    UIImageView * _userBgImageView=[[UIImageView alloc]init];
    _userBgImageView.image=[UIImage imageNamed:@"portrait_storke"];
    _userBgImageView.frame=CGRectMake((kScreenWidth-71.0)/2, 64 +20, 71, 71);
    _userBgImageView.layer.cornerRadius = 71.0/2;
    _userBgImageView.clipsToBounds = YES;
    _userBgImageView.userInteractionEnabled = YES;
    [_headView addSubview:_userBgImageView];
    
    _userImageView =[[UIImageView alloc]init];
    _userImageView.image =[UIImage imageNamed:@"portrait_default"];
    _userImageView.frame =CGRectMake((kScreenWidth-65.0)/2, 64 +20 +3, 65, 65);
    _userImageView.layer.cornerRadius = 65.0/2;
    _userImageView.clipsToBounds = YES;
    _userImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyPersonalInformation)];
    [_userImageView addGestureRecognizer:tap];
    [_headView addSubview:_userImageView];

    //
//    _levelView = [[LevelView alloc ]initWithFrame:CGRectMake(0, CGRectGetMaxY(_userBgImageView.frame)+11, kScreenWidth, 12) num:@"V21" title:@"导购大神"];
    _levelView = [[LevelView alloc ]initWithFrame:CGRectMake(0, CGRectGetMaxY(_userBgImageView.frame)+14, kScreenWidth, 12)];
    _levelView.titleLabel.textColor = JXFfffffColor;
    [_headView addSubview:_levelView];
    
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = JXFfffffColor;
    _nameLabel.font = JXFontForNormal(13);
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    _nameLabel.frame = CGRectMake(0, CGRectGetMaxY(_levelView.frame)+8, kScreenWidth, 13);
    [_headView addSubview:_nameLabel];

    NSArray * titleArray = @[@"Pay",@"Follow",@"Chat",@"Order"];
    NSArray * imageArray = @[@"icon_pay",@"icon_follower",@"icon_chat",@"icon_consumption"];
    for (int i = 0; i < titleArray.count ; i ++)
    {
        UIButton *dmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dmBtn.backgroundColor = JXFfffffColor;
        dmBtn.tag = 10 + i;
        dmBtn.frame = CGRectMake(kScreenWidth /4 * (i%4),(MyHeadViewHeight) + 71*kPercent *(i/4), kScreenWidth /4, 71*kPercent);
        [dmBtn.titleLabel setFont:JXFontForNormal(13)];
        [dmBtn setTitleColor:JXTextColor forState:UIControlStateNormal];
        [dmBtn setTitle:JXLocalizedString(titleArray[i]) forState:UIControlStateNormal];
        [dmBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
        [dmBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 8, 0)];
        
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth /4 -25*kPercent)/2, 15, 25*kPercent, 25*kPercent)];
        [image setImage:JXImageNamed(imageArray[i])];
        image.userInteractionEnabled = NO;
        [dmBtn addSubview:image];
        UILabel * xline = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth /4, 0.5)];
        xline.backgroundColor = JXSeparatorColor;
        [dmBtn addSubview:xline];
        UILabel * yline = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth /4-0.5, 0, 0.5, 71*kPercent)];
        yline.backgroundColor = JXSeparatorColor;
        if (i != titleArray.count -1) {
            [dmBtn addSubview:yline];
        }

        [dmBtn setBackgroundImage:JXImageNamed(@"icon_pressed") forState:UIControlStateHighlighted];
        [dmBtn setBackgroundImage:JXImageNamed(@"icon_normal") forState:UIControlStateNormal];
        [dmBtn addTarget:self action:@selector(speedEntryClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:dmBtn];
        
        if (i == 2){
            redLabel = [UILabel new];
            redLabel.frame = CGRectMake((kScreenWidth /4 +25*kPercent)/2 -5, 5, 15.f, 15.f);
            redLabel.backgroundColor = [UIColor redColor];
            //redLabel.backgroundColor = JXff5252Color;
            redLabel.textColor = JXFfffffColor;
            redLabel.textAlignment = NSTextAlignmentCenter;
            redLabel.font = JXFontForNormal(10);
            redLabel.layer.cornerRadius = 15.f/2;
            //redLabel.clipsToBounds = YES;
            redLabel.layer.masksToBounds = YES;
            redLabel.hidden = YES;
            [dmBtn addSubview:redLabel];
        }
    }

}
- (void)layoutSubView{
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-kTabBarHeight);
    }];
}
- (UITapGestureRecognizer *)loginTap{
    if (!_loginTap) {
        _loginTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login)];
    }
    return _loginTap;
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * rowArray = _defaultArray[section];
    return rowArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _defaultArray.count;
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
        
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 20, 20, 5, 9)];
        [arrow setImage:JXImageNamed(@"list_arrow")];
        [cell.contentView addSubview:arrow];
        
    }
    NSDictionary * defraultDict = _defaultArray[indexPath.section][indexPath.row];
    cell.textLabel.text = JXLocalizedString(defraultDict[@"title"]);
    cell.imageView.image = [UIImage imageNamed:defraultDict[@"image"]];
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            [[LoginManager shareManager] checkUserLoginState:^{
                switch (indexPath.row) {
                    case 0:
                    {
                        [self showJXNoticeMessage:@"功能马上开通，敬请期待"];
                        return ;
//                        CouponListViewController * cvc = [[CouponListViewController alloc ] init ];
//                        [self.navigationController pushViewController:cvc animated:YES];
                    }
                        break;
                    case 1:
                    {
                        RecordListViewController * cvc = [[RecordListViewController alloc ] init ];
                        [self.navigationController pushViewController:cvc animated:YES];
                    }
                        break;
                    case 2:
                    {
                        CollectionListViewController * cvc = [[CollectionListViewController alloc ] init ];
                        [self.navigationController pushViewController:cvc animated:YES];
                    }
                        break;
                    case 3:
                    {
                        LevelViewController * lvc = [[LevelViewController alloc ]init ];
                        _isShowNavigationBar = YES;
                        lvc.userDetailEntity = _userDetailEntity;
                        [self.navigationController pushViewController:lvc animated:YES];
                    }
                        break;
                }
                
            }];
        }
            break;
        case 1:
        {
            [[LoginManager shareManager] checkUserLoginState:^{
                switch (indexPath.row) {
                    case 0:
                    {
                        FansViewController * svc = [[FansViewController alloc ]init ];
                        [self.navigationController pushViewController:svc animated:YES];
                    }
                        break;
                    case 1:
                    {
                        [DJXRequest requestWithBlock:kApiShareInfo param:@{@"infoId":[UserDBManager shareManager].UserID,@"infoType":@(UserInviteShareType)} success:^(id object,NSString *msg) {
                            if ([object isKindOfClass:[NSDictionary class]]) {
                                NSDictionary * dict = (NSDictionary *)object;
                                [[ShareManager shareManager] showCustomShareViewWithContent:dict[@"Content"] title:dict[@"Title"] imageUrl:dict[@"Images"] url:dict[@"Url"] description:nil infoId:dict[@"InfoId"] shareType:UserInviteShareType presentedController:self success:^(id object, UserShareSns sns){
                                    //
                                    NSLog(@"邀请成功");
//                                    [DJXRequest requestWithBlock:kApiShareSuccess param:@{@"InfoId":dict[@"InfoId"] ,@"infoType":@(UserInviteShareType),@"ShareTo":@(sns)} success:^(id object) {
//                                        [self showJXNoticeMessage:object];
//                                    } failure:^(id object) {
//                                        //
//                                    } animated:NO];
                                } failure:^(id object, UserShareSns sns){
                                    //
                                    NSLog(@"邀请失败");
                                }];
                            }
                            
                        } failure:^(id object,NSString *msg) {
                            //
                        } animated:NO];
                        
                    }
                        break;
                }
                
            }];
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [[LoginManager shareManager] checkUserLoginState:^{
                        SettingViewController * svc = [[SettingViewController alloc ]init ];
                        [self.navigationController pushViewController:svc animated:YES];
                    }];
                }
                    break;
                case 1:
                {
                    HelpViewController * hvc = [[HelpViewController alloc ] init];
                    [self.navigationController pushViewController:hvc animated:YES];
                }
                    break;
            }
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [[LoginManager shareManager] checkUserLoginState:^{
                        
                        MyInvitationViewController * svc = [[MyInvitationViewController alloc ]init ];
                        [self.navigationController pushViewController:svc animated:YES];
                    }];
                }
                    break;
                case 1:
                {
                    [[LoginManager shareManager] checkUserLoginState:^{
                        NSURL *url = [NSURL URLWithString:@"GJieGoGuider://"];
                        // 如果已经安装了这个应用,就跳转
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@YES} completionHandler:^(BOOL success) {
                                //
                                NSLog(@"安装:%d",success);
                        
                            }];
                        }else{
                            NSLog(@"未安装");
                        }
                    }];
                }
                    break;
            }
        }
            break;
        case 4:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self performSelector:@selector(connectServices)];
                }
                    break;
            }
        }
            break;
    }

    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + MyHeadViewHeight +71*kPercent)/2;
    
    if (yOffset < -(MyHeadViewHeight +71*kPercent)) {
        
        CGRect rect = bgImageView.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset -71*kPercent ;
        rect.origin.x = xOffset;
        rect.size.width = kScreenWidth + fabs(xOffset);
        bgImageView.frame = rect;
        
//        CGRect HeadImageRect = CGRectMake((KScreen_Width-HeadImageHeight)/2, 40, HeadImageHeight, HeadImageHeight);
//        HeadImageRect.origin.y = _headImageView.frame.origin.y;
//        HeadImageRect.size.height =  HeadImageHeight + fabs(xOffset)*0.5 ;
//        HeadImageRect.origin.x = self.view.center.x - HeadImageRect.size.height/2;
//        HeadImageRect.size.width = HeadImageHeight + fabs(xOffset)*0.5;
//        _headImageView.frame = HeadImageRect;
//        _headImageView.layer.cornerRadius = HeadImageRect.size.height/2;
//        _headImageView.clipsToBounds = YES;
//        
//        CGRect NameRect = CGRectMake((KScreen_Width-HeadImageHeight)/2, CGRectGetMaxY(_headImageView.frame)+5, HeadImageHeight, 20);
//        NameRect.origin.y = CGRectGetMaxY(_headImageView.frame)+5;
//        NameRect.size.height =  20 + fabs(xOffset)*0.5 ;
//        NameRect.size.width = HeadImageHeight + fabs(xOffset)*0.5;
//        NameRect.origin.x = self.view.center.x - NameRect.size.width/2;
//        
//        _nameLabel.font=[UIFont systemFontOfSize:17+fabs(xOffset)*0.2];
//        
//        _nameLabel.frame = NameRect;
        
        
    }else{
        
//        CGRect HeadImageRect = CGRectMake((KScreen_Width-HeadImageHeight)/2, 40, HeadImageHeight, HeadImageHeight);
//        HeadImageRect.origin.y = _headImageView.frame.origin.y;
//        HeadImageRect.size.height =  HeadImageHeight - fabs(xOffset)*0.5 ;
//        HeadImageRect.origin.x = self.view.center.x - HeadImageRect.size.height/2;
//        HeadImageRect.size.width = HeadImageHeight - fabs(xOffset)*0.5;
//        _headImageView.frame = HeadImageRect;
//        _headImageView.layer.cornerRadius = HeadImageRect.size.height/2;
//        _headImageView.clipsToBounds = YES;
//        
//        CGRect NameRect = CGRectMake((KScreen_Width-HeadImageHeight)/2, CGRectGetMaxY(_headImageView.frame)+5, HeadImageHeight, 20);
//        NameRect.origin.y = CGRectGetMaxY(_headImageView.frame)+5;
//        NameRect.size.height =  20;
//        NameRect.size.width = HeadImageHeight - fabs(xOffset)*0.5;
//        NameRect.origin.x = self.view.center.x - NameRect.size.width/2;
//        
//        _nameLabel.font=[UIFont systemFontOfSize:17-fabs(xOffset)*0.2];
//        
//        _nameLabel.frame = NameRect;
        
    }
  
    if (yOffset >= kNavStatusHeight -(MyHeadViewHeight +71*kPercent)) {
        navigationBarBackgroundView.alpha = 1;
        right.tintColor = [UIColor blackColor];
        titleView.textColor = [UIColor blackColor];
    }else if (yOffset <= -(MyHeadViewHeight +71*kPercent)){
        navigationBarBackgroundView.alpha = 0;
        right.tintColor = [UIColor whiteColor];
        titleView.textColor = [UIColor whiteColor];
    }else{
        navigationBarBackgroundView.alpha = fabs(fabs(yOffset) -(MyHeadViewHeight +71*kPercent)) /kNavStatusHeight;
    }
}
#pragma mark - notification
- (void)hasUnReadSystemMessages:(NSNotification *)notification{
    BOOL isHadSystemMessage = [notification.object boolValue];
    if ([LoginManager shareManager].isHadLogin && isHadSystemMessage) {
        if (!badgeView) {
            badgeView = [[UIView alloc]init];
            badgeView.layer.cornerRadius = 5.f;
            badgeView.backgroundColor = [UIColor redColor];
            badgeView.frame = CGRectMake(22, 10, 10, 10);
        }
        if (!badgeView.superview) {
            [right addSubview:badgeView];
        }
        [(AppDelegate *)[UIApplication sharedApplication].delegate showBadge:YES];
    }else{
        if (badgeView.superview && badgeView) {
            [badgeView removeFromSuperview];
        }
        //并且没有聊天消息才隐藏
        if ([LoginManager shareManager].isHadLogin) {
            NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
            NSInteger unreadCount = 0;
            for (EMConversation *conversation in conversations) {
                unreadCount += conversation.unreadMessagesCount;
            }
            if (unreadCount == 0) {
                [(AppDelegate *)[UIApplication sharedApplication].delegate showBadge:NO];
            }
        }
    }
}
- (void)hasUnReadChatMessages:(NSNotification *)notification{
    if ([LoginManager shareManager].isHadLogin) {
        NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
        NSInteger unreadCount = 0;
        for (EMConversation *conversation in conversations) {
            unreadCount += conversation.unreadMessagesCount;
        }
        if (unreadCount >0) {
            NSString * str;
            if (unreadCount >99) {
                str = @"99";
            }else{
                str = [NSString stringWithFormat:@"%ld",(long)unreadCount];
            }
            redLabel.text = str;
            redLabel.hidden = NO;
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBadge:YES];
        }else{
            redLabel.hidden = YES;
            //并且没有通知消息才隐藏
//            if (![[NotificationManager shareManager]isHasUnReadMessages]){
            if (![[NotificationManager shareManager]isHasNews]){
                [(AppDelegate *)[UIApplication sharedApplication].delegate showBadge:NO];
            }
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = unreadCount;
    }
    
}
#pragma mark - click events
- (void)login{
    [[LoginManager shareManager] checkUserLoginState:^{}];
//    [[ChatManager shareManager] getConversation:@"b0781b3d35018454b" title:@"名门" type:EMConversationTypeChat parentViewController:self];
}
- (void)notificationEvent:(UIButton *)button{
    [[LoginManager shareManager] checkUserLoginState:^{
        NotificationViewController * nvc = [[NotificationViewController alloc ]init ];
        [self.navigationController pushViewController:nvc animated:YES];
    }];
}
- (void)modifyPersonalInformation{
    [[LoginManager shareManager] checkUserLoginState:^{
        ModifyInformationViewController * mvc = [[ModifyInformationViewController alloc ]init ];
        [self.navigationController pushViewController:mvc animated:YES];
    }];
}
- (void)speedEntryClick:(UIButton *)button{
    [[LoginManager shareManager] checkUserLoginState:^{
        switch (button.tag) {
            case 10:
            {
                [self showJXNoticeMessage:@"功能马上开通，敬请期待"];
                return ;
//                PayScanViewController * svc = [[PayScanViewController alloc ]init ];
//                [self.navigationController pushViewController:svc animated:YES];
            }
                break;
            case 11:
            {
                AttentionViewController * avc = [[AttentionViewController alloc ]init ];
                [self.navigationController pushViewController:avc animated:YES];
            }
                break;
            case 12:
            {
                ConversationListViewController * avc = [[ConversationListViewController alloc ]init ];
                [self.navigationController pushViewController:avc animated:YES];
            }
                break;
            case 13:
            {
                [self showJXNoticeMessage:@"功能马上开通，敬请期待"];
                return ;
//                OrderListViewController * ovc = [[OrderListViewController alloc ]init ];
//                [self.navigationController pushViewController:ovc animated:YES];
            }
                break;
        }
    }];
}
- (void)connectServices{
    if (kIOS_VERSION >= 8) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * pictureAction = [UIAlertAction actionWithTitle:@"400-086-9009" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSString *phoneNum = @"400-086-9009";// 电话号码
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
            
//            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
//            UIWebView * phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
//            [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
            
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [alertVC addAction:pictureAction];
        [alertVC addAction:cancelAction];

        [pictureAction setValue:JXTextColor forKey:@"_titleTextColor"];
        [cancelAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
        
        [self presentViewController:alertVC animated:YES completion:^{}];
    }else{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"400-200-500", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        actionSheet.tintColor = JXTextColor;//不起作用
        [actionSheet showInView:self.view];
        //注意整个工程的view 都会被修改
        // [[UIView appearance] setTintColor:JXTextColor];
    }
}

#pragma mark –-------------------------UIActionSheetDelegate
// iOS8.0之前可用
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *view in actionSheet.subviews) {
        UIButton *btn = (UIButton *)view;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        if([[btn titleForState:UIControlStateNormal] isEqualToString:@"取消"]){
            [btn setTitleColor:JXTextColor forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString *phoneNum = @"400-200-500";// 电话号码
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
    }
}

@end
