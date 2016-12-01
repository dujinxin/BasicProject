//
//  NotificationManager.m
//  GJieGo
//
//  Created by dujinxin on 16/6/14.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "NotificationManager.h"

NSString *const HasUnreadSystemMessagesNotification = @"HasUnreadMessagesNotification";
NSString *const NotificationKey = @"note";

@implementation NotificationManager
static NotificationManager * manager = nil;
+ (NotificationManager *)shareManager{
    @synchronized(self){
        if (manager == nil) {
            manager = [[self alloc]init ];
        }
    }
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:[self databaseWithPath:[NSString stringWithFormat:@"%@.db",NotificationDBName]]];
    }
    return self;
}
- (BOOL)isHasUnReadMessages{
    return [[NotificationManager shareManager] selectNumber:NotificationDBName];
}
/**
 *  条件查询
 *  @param name     表名
 *  @param key  查询字段
 *  @param condition 条件
 *  @return 查询结果字典数组
 */
- (NSArray *)selectNumbers:(NSString *)name key:(NSString *)key where:(NSArray *)condition{
    if (![self isExist:name]){
        return 0;
    }
    __block NSInteger num = 0;
    __block NSMutableArray * array = [NSMutableArray array];
    NSMutableArray * sqlArray = [NSMutableArray arrayWithCapacity:condition.count];
    for (int i = 0; i < condition.count; i++) {
        NSMutableString* SQL = [[NSMutableString alloc] init];
        [SQL appendString:@"select count"];
        if (key) {
            [SQL appendFormat:@" ( %@ ) from %@",key,name];
        }else{
            [SQL appendFormat:@" ( * ) from %@",name];
        }
        [SQL appendFormat:@" where %@",condition[i]];
        NSLog(@"SQL == %@",SQL);
        [sqlArray addObject:SQL];
    }
    //2.把任务包装到事务里
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback){
        for (int i = 0; i < sqlArray.count; i ++) {
            NSString * sqlStr = sqlArray[i];
            // 1.查询数据
            FMResultSet *rs = [db executeQuery:sqlStr];
            if (rs) {
                // 2.遍历结果集
                while (rs.next) {
                    num = [rs intForColumnIndex:0];
                }
                if (num >0) {
                    [array addObject:@(num)];
                }else{
                    [array addObject:@0];
                }
            }else{
                *rollback = YES;
                return ;
            }
        }
    }];
    return array;
}

- (BOOL)createTable:(NSDictionary *)dict{
    return [self createTable:NotificationDBName keys:dict.allKeys];
}
- (void)saveNotifications:(NSDictionary *)dict{
    [self insertData:NotificationDBName keyValues:dict];
}
- (void)clearNotifications:(NotificationType)type{
    [self deleteData:NotificationDBName];
}

- (NSMutableArray *)getNotifications:(NotificationType)type{
    NSString * conditionStr = [NSString stringWithFormat:@"NoteType = %ld",type];
    return [self selectData:NotificationDBName where:@[conditionStr]];
}
- (NSMutableArray *)getNotifications:(NotificationType)type page:(NSInteger)page limit:(NSString *)limit{
    return nil;
}
- (BOOL)deleteNotifications:(NotificationType)type{
    NSString * conditionStr = [NSString stringWithFormat:@"NoteType = %ld",type];
    return [self deleteData:NotificationDBName where:@[conditionStr]];
}



- (void)handleReceiveRemoteNotification:(NSDictionary *)userInfo{
    AppDelegate * appDelegate = [AppDelegate appDelegate];
    NSLog(@"Receive one notification = %@",userInfo);
    //[[JXViewManager sharedInstance] showAlertMessage:[NSString stringWithFormat:@"%@",userInfo]];
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        if (appDelegate.selectedIndex != 3) {
            [appDelegate.tabBarController setSelectedIndex:3];
        }
        [self appDelegate:appDelegate handleNotificationDetail:userInfo];
    }else{
        NSDictionary * extraDict = userInfo[NotificationKey];
        if (extraDict[@"chatId"]) {
            [self calculateNotificationNumber:@"chat" notification:userInfo];
        }else{
            //[self calculateNotificationNumber:@"other" notification:userInfo];
        }
    }
}
- (void)appDelegate:(AppDelegate *)appDelegate handleNotificationDetail:(NSDictionary *)userInfo{
    if (userInfo[NotificationKey]){
        NSDictionary * extraDict = userInfo[NotificationKey];
        NotificationType type = [extraDict[@"NoteType"] integerValue];
        BaseNavigationController * baseVc = appDelegate.tabBarController.selectedViewController;
        switch (type) {
            case NotificationFansType:
            {
                FansViewController * svc = [[FansViewController alloc ]init ];
                [baseVc pushViewController:svc animated:YES];
            }
                break;
            case NotificationPriseType:
            case NotificationCommentType:
            case NotificationShareType:
            case NotificationReturnType:
            {
                if ([extraDict[@"Infotype"] integerValue] == NotificationAssociationProm) {
//                    ShopGuideDetailViewController *svc = [[ShopGuideDetailViewController alloc] init];
//                    svc.infoid = [extraDict[@"InfoId"] integerValue];
//                    [baseVc pushViewController:svc animated:YES];
                }else if([extraDict[@"Infotype"] integerValue] == NotificationAssociationShow){
//                    SharedOrderDetailViewController *svc = [[SharedOrderDetailViewController alloc] init];
//                    svc.infoId = [extraDict[@"InfoId"] integerValue];
//                    [baseVc pushViewController:svc animated:YES];
                }else{
                    [[JXViewManager sharedInstance] showJXNoticeMessage:@"用户类型出错！"];
                }
            }
                break;
            case NotificationChatType:
            {
                NSLog(@"extraDict =  %@",extraDict);
                [[LoginManager shareManager] checkUserLoginState:^{
                    ConversationListViewController * svc = [[ConversationListViewController alloc ]init ];
                    if (extraDict[@"chatId"]) {
                        if ([baseVc.topViewController.class isEqual:svc.class]){
                            //不用跳转
                        }else if ([baseVc.topViewController.class isEqual:[ChatViewController class]]){
                            //假如 同一个会话，不用管，不同则返回到会话列表
                            if ([ChatManager shareManager].conversationId){
                                if (![[ChatManager shareManager].conversationId isEqualToString:extraDict[@"chatId"]]) {
                                    UIViewController * vc = baseVc.topViewController;
                                    [vc.navigationController popViewControllerAnimated:YES];
                                }
                            }
                        }else{
                            [baseVc pushViewController:svc animated:YES];
                        }
                    }else{
                        [baseVc pushViewController:svc animated:YES];
                    }
                }];
            }
                break;
        }
    }
}

- (void)calculateNotificationNumber:(NSString *)from notification:(NSDictionary *)userInfo{
    [(AppDelegate *)[UIApplication sharedApplication].delegate showBadge:YES];
    if ([from isEqualToString:@"chat"]) {
        //交由本地通知处理
    }else{
        [self handleOtherNotification:userInfo];
    }
}
- (void)handleChatMessages:(NSDictionary *)userInfo{
    AppDelegate * appDelegate = [AppDelegate appDelegate];
    BaseNavigationController * baseVc = appDelegate.tabBarController.selectedViewController;
    NSDictionary * extraDict = userInfo[NotificationKey];
    NSInteger number = [UIApplication sharedApplication].applicationIconBadgeNumber +1;
    if ([baseVc.topViewController.class isEqual:[ChatViewController class]]){
        //正在聊天，并且是同一个会话，那么不用计算
        if (![[ChatManager shareManager].conversationId isEqualToString:extraDict[@"chatId"]]) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = number;
        }
    }else{
        [UIApplication sharedApplication].applicationIconBadgeNumber = number;
        [[NSNotificationCenter defaultCenter] postNotificationName:HasUnreadChatMessagesNotification object:@YES];
    }
}
- (void)handleOtherNotification:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:HasUnreadSystemMessagesNotification object:@YES];
//    NSInteger number = [UIApplication sharedApplication].applicationIconBadgeNumber +1;
//    [UIApplication sharedApplication].applicationIconBadgeNumber = number;
}
@end
