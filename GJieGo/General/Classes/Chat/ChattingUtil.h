//
//  ChattingUtil.h
//  GJieGo
//
//  Created by dujinxin on 16/5/27.
//  Copyright © 2016年 yangzx. All rights reserved.
//
//  聊天类风格修改请搜索 //custom
//  自定义请继承重写
#import <Foundation/Foundation.h>

@class UserProfileEntity;

@protocol ChattingUtilDelegate <NSObject>
#pragma mark - create conversation/创建一个会话
/*
 *  与某人开始会话
 *  @param conversationId  会话ID
 */
- (void)getConversation:(NSString *)conversationId parentViewController:(UIViewController *)parentViewController;
/*
 *  与某人开始会话
 *  @param conversationId  会话ID   /以后台返回的 HxAccount 来作为会话id
 *  @param type            会话类型  /目前仅支持单聊模式，设置其他无效
 *  @param title           昵称     /没有特别设置，昵称为会话id
 *  @param headImage       头像
 */
- (void)getConversation:(NSString *)conversationId title:(NSString *)nickName headImage:(NSString *)userImage type:(EMConversationType)type parentViewController:(UIViewController *)parentViewController;
/*
 *  某人是否在会话列表中
 *  @param conversationId  会话ID
 */
- (BOOL)isInConversationList:(NSString *)conversationId;
#pragma mark - blackList/黑名单
/*
 *  将某人加入黑名单
 *  @param conversationId  会话ID
 */
- (BOOL)addUserToBlackList:(NSString *)conversationId;
/*
 *  将某人从黑名单中移除
 *  @param conversationId  会话ID
 */
- (BOOL)removeUserFromBlackList:(NSString *)conversationId;
#pragma mark - get hxUserInfo/查询环信用户信息
/**
 *  获取聊天对象信息
 *  @param userName  环信账户
 */
- (UserProfileEntity *)getUserProfileEntityByUserName:(NSString *)userName;
/**
 *  获取聊天对象信息
 *  @param userId    用户ID
 */
- (UserProfileEntity *)getUserProfileEntityByUserId:(NSString *)userId;
/**
 *  获取聊天对象信息
 *  @param nickName  用户昵称
 */
- (UserProfileEntity *)getUserProfileEntityByNickName:(NSString *)nickName;
#pragma mark - insert hxUserInfo/保存环信用户信息
/**
 *  保存聊天对象信息
 *  @param dict      用户信息
 */
- (void)saveUserProfileEntityWithDict:(NSDictionary *)dict;
#pragma mark - check hxUserInfo/检查环信用户信息
/**
 *  检查用户信息
 *  @param userName  环信账户
 *  @param nickName  用户昵称
 *  @param userImage   头像
 */
- (NSDictionary *)checkUserName:(NSString *)userName nickName:(NSString *)nickName userImage:(NSString *)userImage;
#pragma mark - update hxUserInfo/修改环信用户信息
/**
 *  更新聊天对象信息
 *  @param dict      用户信息
 */
- (void)updateUserProfileEntityWithDict:(NSDictionary *)dict;
/**
 *  修改自己的信息
 *  @param nickName   昵称
 */
- (BOOL)modifyUserNickName:(NSString *)nickName;
/**
 *  修改自己的信息
 *  @param userImage   头像
 */
- (BOOL)modifyUserImage:(NSString *)userImage;
@end
