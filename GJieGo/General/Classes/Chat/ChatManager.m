//
//  ChatManager.m
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "ChatManager.h"
#import "BaseNavigationController.h"
#import "ChatViewController.h"


NSString *const HasUnreadChatMessagesNotification = @"HasUnreadChatMessagesNotification";

@implementation ChatManager

static ChatManager * manager = nil;
+(ChatManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ChatManager alloc]init ];
        
        
    });
    return manager;
}
#pragma mark - create conversation/创建一个会话
- (void)getConversation:(NSString *)conversationId parentViewController:(UIViewController *)parentViewController{
    [self getConversation:conversationId title:nil headImage:nil type:EMConversationTypeChat parentViewController:parentViewController];
}
- (void)getConversation:(NSString *)conversationId title:(NSString *)nickName headImage:(NSString *)userImage type:(EMConversationType)type parentViewController:(UIViewController *)parentViewController{
    
    [[LoginManager shareManager] checkUserLoginState:^{
        //同步把环信的昵称和头像也设置了
        NSDictionary * dict = [self checkUserName:conversationId nickName:nickName userImage:userImage];
        if (dict) {
            [[ChatManager shareManager] createTable:ChatDBName keys:dict.allKeys];
            [[ChatManager shareManager] saveUserProfileEntityWithDict:dict];
            
            if (![[EMClient sharedClient] isLoggedIn]) {
                [[EMClient sharedClient] loginWithUsername:[UserDBManager shareManager].HxAccount password:[UserDBManager shareManager].HxPassword];

            }
        }
        //目前仅支持单聊模式
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:conversationId conversationType:EMConversationTypeChat];
        chatController.title = nickName?nickName:conversationId;
        //当前会话id
        [ChatManager shareManager].conversationId = conversationId;
        BaseNavigationController * nvc;
        if ([parentViewController isKindOfClass:[UINavigationController class]]) {
            nvc = (BaseNavigationController *)parentViewController;
        }else if (parentViewController.navigationController){
            nvc = (BaseNavigationController *)parentViewController.navigationController;
        }
        [nvc pushViewController:chatController animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:HasUnreadChatMessagesNotification object:nil];
    }];
    
}
- (BOOL)isInConversationList:(NSString *)conversationId{
    __block BOOL isIn = NO;
    NSArray *array = [[EMClient sharedClient].chatManager getAllConversations];
    [array enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL *stop){
        if ([conversation.conversationId isEqualToString:conversationId]) {
            isIn = YES;
            *stop = YES;
        }
    }];
    return isIn;
}
#pragma mark - blackList/黑名单
- (BOOL)addUserToBlackList:(NSString *)conversationId{
    EMError *error = [[EMClient sharedClient].contactManager addUserToBlackList:conversationId relationshipBoth:YES];
    if (!error) {
        NSLog(@"加入黑名单");
        return YES;
    }
    return NO;
}
- (BOOL)removeUserFromBlackList:(NSString *)conversationId{
    EMError *error = [[EMClient sharedClient].contactManager removeUserFromBlackList:conversationId];
    if (!error) {
        NSLog(@"从黑名单中移除");
        return YES;
    }
    return NO;
}
#pragma mark - get hxUserInfo/查询环信用户信息
/**
 *  获取聊天对象信息
 *  @param userName  环信账户
 */
- (UserProfileEntity *)getUserProfileEntityByUserName:(NSString *)userName{
    NSString * conditionStr = [NSString stringWithFormat:@"userName = '%@'",userName];
    NSArray * array = [self selectData:ChatDBName where:@[conditionStr]];
    if (array.count) {
        UserProfileEntity * entity = [[UserProfileEntity alloc ]init ];
        [entity setValuesForKeysWithDictionary:array.lastObject];
        return entity;
    }
    return nil;
}
/**
 *  获取聊天对象信息
 *  @param userId  用户ID
 */
- (UserProfileEntity *)getUserProfileEntityByUserId:(NSString *)userId{
    NSString * conditionStr = [NSString stringWithFormat:@"userId = %@",userId];
    NSArray * array = [self selectData:ChatDBName where:@[conditionStr]];
    if (array.count) {
        UserProfileEntity * entity = [[UserProfileEntity alloc ]init ];
        [entity setValuesForKeysWithDictionary:array.lastObject];
        return entity;
    }
    return nil;
}
/**
 *  获取聊天对象信息
 *  @param nickName  用户昵称
 */
- (UserProfileEntity *)getUserProfileEntityByNickName:(NSString *)nickName{
//    NSString * conditionStr = [NSString stringWithFormat:@"nickName = %@",nickName];
     NSString * conditionStr = [NSString stringWithFormat:@"userName = '%@'",nickName];
    NSArray * array = [self selectData:ChatDBName where:@[conditionStr]];
    if (array.count) {
        UserProfileEntity * entity = [[UserProfileEntity alloc ]init ];
        [entity setValuesForKeysWithDictionary:array.lastObject];
        return entity;
    }
    return nil;
}
#pragma mark - insert hxUserInfo/保存环信用户信息
/**
 *  保存聊天对象信息
 *  @param dict  用户信息
 */
- (void)saveUserProfileEntityWithDict:(NSDictionary *)dict{
    
    UserProfileEntity * entity = [self getUserProfileEntityByUserId:dict[@"userId"]];
    if (!entity) {//不存在，添加
        [self insertData:ChatDBName keyValues:dict];
    }else{//存在，则更新
        NSString * conditionStr = [NSString stringWithFormat:@"userId = %@",dict[@"userId"]];
        [self updateData:ChatDBName keyValues:dict where:@[conditionStr]];
    }
    
}
#pragma mark - check hxUserInfo/检查环信用户信息
/**
 *  检查用户信息
 *  @param userName  环信账户
 *  @param nickName  用户昵称
 *  @param userImage   头像
 */
- (NSDictionary *)checkUserName:(NSString *)userName nickName:(NSString *)nickName userImage:(NSString *)userImage{
    
    if (!userName) {
        return nil;
    }
    NSMutableDictionary * hxDict = [NSMutableDictionary dictionary];
    if (userImage) {
        [hxDict setValue:userImage forKey:@"userImage"];
    }else{
        [hxDict setValue:@"" forKey:@"userImage"];
    }
    if (nickName) {
        [hxDict setValue:nickName forKey:@"nickName"];
    }else{
        [hxDict setValue:@"" forKey:@"nickName"];
    }
    if (userName) {
        [hxDict setValue:userName forKey:@"userName"];
    }else{
        [hxDict setValue:@"" forKey:@"userName"];
    }
    return hxDict;
}
#pragma mark - update hxUserInfo/修改环信用户信息
/**
 *  更新聊天对象信息
 *  @param dict  用户信息
 */
- (void)updateUserProfileEntityWithDict:(NSDictionary *)dict{
    NSString * conditionStr = [NSString stringWithFormat:@"userId = %@",dict[@"userId"]];
    UserProfileEntity * entity = [self getUserProfileEntityByUserId:dict[@"userId"]];
    if (entity) {//存在，则更新
        [self updateData:ChatDBName keyValues:dict where:@[conditionStr]];
    }
}
/**
 *  修改自己的信息
 *  @param nickName   昵称
 */
- (BOOL)modifyUserNickName:(NSString *)nickName{
    NSString * conditionStr = [NSString stringWithFormat:@"userId = %@",[UserDBManager shareManager].UserID];
    BOOL result = [self updateData:ChatDBName keyValues:@{@"nickName":nickName} where:@[conditionStr]];
    return result;
}
/**
 *  修改自己的信息
 *  @param userImage   头像
 */
- (BOOL)modifyUserImage:(NSString *)userImage{
    NSString * conditionStr = [NSString stringWithFormat:@"userId = %@",[UserDBManager shareManager].UserID];
    BOOL result = [self updateData:ChatDBName keyValues:@{@"userImage":userImage} where:@[conditionStr]];
    return result;
}

@end

@implementation UserProfileEntity
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"value:%@  key:%@",value,key);
}
@end

@implementation UserProfileObj

@end
