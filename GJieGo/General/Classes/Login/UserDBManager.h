//
//  UserDBManager.h
//  GJieGo
//
//  Created by dujinxin on 16/6/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "DBManager.h"

#define     UserDBName      @"UserDBManager"

@interface UserDBManager : DBManager

//个人信息
@property (nonatomic,copy) NSString * Token;//短令牌 2小时时效
@property (nonatomic,copy) NSString * RefreshToken;//长令牌 一个月时效
@property (nonatomic,copy) NSString * PhoneNumber;
@property (nonatomic,copy) NSString * UserID;
@property (nonatomic,copy) NSString * UserName;
@property (nonatomic,copy) NSString * UserAge;
@property (nonatomic,copy) NSString * UserImage;
@property (nonatomic,copy) NSString * UserGender;//0男1女

@property (nonatomic,copy) NSString * HxAccount;
@property (nonatomic,copy) NSString * HxPassword;

+ (UserDBManager *)shareManager;
/*
 * 清空用户信息
 */
- (void)clearUserInfo;
/*
 * 修改用户昵称,头像,性别
 */
- (BOOL)modifyUserNickName:(NSString *)nickName;
- (BOOL)modifyUserImage:(NSString *)imageUrl;
- (BOOL)modifyUserGender:(NSString *)gender;
/*
 * 仅用于更新,删除plist中的token
 */
- (BOOL)updateToken:(NSString *)token refreshToken:(NSString *)refreshToken;
- (void)deleteToken;
- (NSString *)getToken;
- (NSString *)getRefreshToken;
- (BOOL)isVisitor;
@end

