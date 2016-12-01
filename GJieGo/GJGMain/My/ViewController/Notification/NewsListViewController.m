//
//  NewsListViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/5/9.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "NewsListViewController.h"
#import "OrderGuiderView.h"

#import "FansViewController.h"

@interface NewsListViewController (){
    NSDateFormatter * dateFormatter;
    NSString        * dateString;
}

@end

@implementation NewsListViewController

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
    
    switch (_type) {
        case NotificationFansType:
        {
            self.title = @"新的粉丝";
        }
            break;
        case NotificationShareType:
        {
            self.title = @"新的分享";
        }
            break;
        case NotificationCommentType:
        {
            self.title = @"新的评论";
        }
            break;
        case NotificationPriseType:
        {
            self.title = @"新的点赞";
        }
            break;
        case NotificationReturnType:
        {
            self.title = @"新的回复";
        }
            break;
    }

//    _dataArray = [[NotificationManager shareManager] getNotifications:self.type];
//    NSLog(@"notifications == %@",_dataArray);
//    if (_dataArray.count) {
//        [[NotificationManager shareManager] deleteNotifications:self.type];
//    }
    /*
     YYYY（年）/MM（月）/dd（日） hh（时）:mm（分）:ss（秒） SS（毫秒）
     需要用哪个的话就把哪个格式加上去。
     值得注意的是，如果想显示两位数的年份的话，可以用”YY/MM/dd hh:mm:ss SS”，两个Y代表两位数的年份。
     而且大写的M和小写的m代表的意思也不一样。“M”代表月份，“m”代码分钟
     “HH”代表24小时制，“hh”代表12小时制
     */
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//2016-07-08 16:44:37
    //[dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss aaa"];//2016-07-08 04:44:37 下午
    
    NSDate * date = [NSDate date];
    dateString = [dateFormatter stringFromDate:date];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refresh:_page];
    }];
    [[UserRequest shareManager] userNotificationList:kApiNotificationList param:@{@"typeId":@(self.type),@"page":@(self.page)} success:^(id object,NSString *msg) {
        
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
        if (44 *_dataArray.count >(kScreenHeight -64)){
            MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [self loadMore:self.page];
            }];
            _tableView.mj_footer = footer;
        }
        if (_dataArray.count) {
            
            [[UserRequest shareManager] userNotificationList:kApiNotificationState param:@{@"typeId":@(self.type),@"maxId":_dataArray.firstObject[@"NoticeId"]} success:^(id object,NSString *msg) {
                AppDelegate * appDelegate = [AppDelegate appDelegate];
                JXDispatch_async_global((^{
                    [[UserRequest shareManager] userNotificationNews:kApiNotificationNews param:nil success:^(id object,NSString *msg) {
                        BOOL yesOrNo = [object[@"hasNotice"] boolValue];
                        [NotificationManager shareManager].isHasNews = [object[@"hasNotice"] intValue];
                        [appDelegate showBadge:yesOrNo];
                        [[NSNotificationCenter defaultCenter] postNotificationName:HasUnreadSystemMessagesNotification object:@(yesOrNo)];
                        //[UIApplication sharedApplication].applicationIconBadgeNumber = [object[@"hasNotice"] intValue];
                    } failure:^(id object,NSString *msg) {}];
                }));
            } failure:^(id object,NSString *msg) {}];
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
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  * cellIdentifier = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UIImageView * userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 30, 30)];
        userImageView.backgroundColor = JXDebugColor;
        userImageView.clipsToBounds = YES;
        userImageView.image = JXImageNamed(@"portrait_default");
        userImageView.tag = 10;
        [cell.contentView addSubview:userImageView];

        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userImageView.jxRight +10, 0, kScreenWidth -80 -60, 44)];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.backgroundColor = JXDebugColor;
        nameLabel.textColor = JX333333Color;
        nameLabel.text = @"导购";
        nameLabel.numberOfLines = 2;
        nameLabel.tag = 11;
        [cell.contentView addSubview:nameLabel];
        
        UILabel * detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.jxRight+10, 0, 60, 44)];
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.font = [UIFont systemFontOfSize:11];
        detailLabel.backgroundColor = JXDebugColor;
        detailLabel.textColor = JX999999Color;
        detailLabel.text = @"导购";
        detailLabel.tag = 12;
        [cell.contentView addSubview:detailLabel];
        
        UIView * line = [[UIView alloc ]initWithFrame:CGRectMake(0, 43.5, kScreenWidth, 0.5)];
        line.backgroundColor = JXSeparatorColor;
        [cell.contentView addSubview:line];

    }
    NSDictionary * dict = _dataArray[indexPath.row];
    UIImageView * userImageView = (UIImageView *)[cell.contentView viewWithTag:10];
    UILabel * nameLabel = (UILabel *)[cell.contentView viewWithTag:11];
    UILabel * detailLabel = (UILabel *)[cell.contentView viewWithTag:12];
    //guiderView.userImageView.image = JXImageNamed(@"list_icon_privilege");
    if ([dict[@"HeadPortrait"] isKindOfClass:[NSString class]]) {
        [userImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"HeadPortrait"]] placeholderImage:JXImageNamed(@"portrait_default")];
    }else{
        userImageView.image = JXImageNamed(@"portrait_default");
    }
    detailLabel.text = @"10:00";
    nameLabel.text = dict[@"Message"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[dict[@"AddTime"] doubleValue]/1000];
    
    
    
    NSString *dateString1 = [dateFormatter stringFromDate:date];
    NSLog(@"interval = %f  date1 = %@",[dict[@"AddTime"] doubleValue]/1000 -8*60*60,dateString1);
    if (![[dateString substringWithRange:NSMakeRange(0, 4)] isEqualToString:[dateString1 substringWithRange:NSMakeRange(0, 4)]]) {
        detailLabel.text = [dateString1 substringWithRange:NSMakeRange(0, 10)];
    }else{
        if (![[dateString substringWithRange:NSMakeRange(0, 10)] isEqualToString:[dateString1 substringWithRange:NSMakeRange(0, 10)]]) {
            detailLabel.text = [dateString1 substringWithRange:NSMakeRange(5, 5)];
        }else{
            detailLabel.text = [NSString stringWithFormat:@"%@",[dateString1 substringWithRange:NSMakeRange(11, 5)]];
        }
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dict = _dataArray[indexPath.row];
    switch (self.type) {
        case NotificationFansType:
        {
            FansViewController * svc = [[FansViewController alloc ]init ];
            [self.navigationController pushViewController:svc animated:YES];
        }
            break;
        case NotificationPriseType:
        case NotificationCommentType:
        case NotificationShareType:
        case NotificationReturnType:
        {
            if ([dict[@"Infotype"] integerValue] == NotificationAssociationProm) {
//                ShopGuideDetailViewController *detailVC = [[ShopGuideDetailViewController alloc] init];
//                detailVC.infoid = [dict[@"InfoId"] integerValue];
//                [self.navigationController pushViewController:detailVC animated:YES];
            }else if([dict[@"Infotype"] integerValue] == NotificationAssociationShow){
//                SharedOrderDetailViewController *detailVC = [[SharedOrderDetailViewController alloc] init];
//                detailVC.infoId = [dict[@"InfoId"] integerValue];
//                [self.navigationController pushViewController:detailVC animated:YES];
            }else{
                [self showJXNoticeMessage:@"用户类型出错！"];
            }
            
        }
            break;
       
    }
}
- (void)refresh:(NSInteger)page{
    [super refresh:page];
    [[UserRequest shareManager] userNotificationList:kApiNotificationList param:@{@"typeId":@(self.type),@"page":@(self.page)} success:^(id object,NSString *msg) {
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
    [[UserRequest shareManager] userNotificationList:kApiNotificationList param:@{@"typeId":@(self.type),@"page":@(self.page)} success:^(id object,NSString *msg) {
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
