//
//  NotificationManager.h
//  GJieGo
//
//  Created by dujinxin on 16/6/14.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "DBManager.h"
#import "NotificationUtil.h"

#import "FansViewController.h"
#import "ConversationListViewController.h"
#import "ChatViewController.h"

#define NotificationDBName      @"NotificationManager"

UIKIT_EXTERN NSString *const HasUnreadSystemMessagesNotification;
UIKIT_EXTERN NSString *const NotificationKey;

/*
 * @param NotificationType 通知类型
 */
typedef NS_ENUM(NSInteger ,NotificationType) {
    NotificationFansType = 1,   //粉丝
    NotificationPriseType,      //赞
    NotificationCommentType,    //评论
    NotificationShareType,      //分享
    NotificationReturnType,     //回复
    
    
    NotificationChatType =  100 //聊天、11.1新增
};

/*
 * @param NotificationType 通知关联信息
 */
typedef NS_ENUM(NSInteger ,NotificationAssociationType) {
    NotificationAssociationNone = 0,   //无
    NotificationAssociationShow,       //晒单
    NotificationAssociationProm,       //促销
    NotificationAssociationShop,       //商铺
};

@interface NotificationManager : DBManager<NotificationUtilDelegate>{
    NSString * _dbName;
}

@property (nonatomic,copy) NSString * UserId;
@property (nonatomic,copy) NSString * UserType;
@property (nonatomic,strong) NSNumber * NoteType;
@property (nonatomic,copy) NSString * InfoId;
@property (nonatomic,copy) NSString * Infotype;
@property (nonatomic,copy) NSString * Message;
@property (nonatomic,copy) NSString * AddTime;
@property (nonatomic,copy) NSString * HeadPortrait;

@property (nonatomic,assign) NSInteger     isHasNews;

/*
 *
 {
 "UserId": 111,
 "UserType": 1,
 "NoteType": 2,
 "InfoId": 11111,
 "Infotype": 1,
 "Message": "乘风赞了你的爱晒“YONEX尤尼克斯羽毛球...”，获得赞+2",
 "AddTime": 1464804952411
 }
 
 */


+ (NotificationManager *)shareManager;
- (BOOL)isHasUnReadMessages;
/*改为接口，以下方法已废弃*/
- (NSArray *)selectNumbers:(NSString *)name key:(NSString *)key where:(NSArray *)condition;

- (void)saveNotifications:(NSDictionary *)dict;

- (NSMutableArray *)getNotifications:(NotificationType)type;
- (NSMutableArray *)getNotifications:(NotificationType)type page:(NSInteger)page limit:(NSString *)limit;

- (BOOL)deleteNotifications:(NotificationType)type;
- (void)clearNotifications:(NotificationType)type;
/*---------------------*/



@end
