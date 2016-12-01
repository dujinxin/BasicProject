//
//  LoginUtil.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * @param UserLogoutType 退出类型
 */
typedef NS_ENUM(NSInteger, UserLogoutType){
    kUserLogoutDefault,         //正常退出
    kUserLogoutTokenDisabled ,  //RefreshToken失效
    kUserLogoutForOtherDevice   //在其他设备登录
};

@class UserEntity;

@protocol LoginUtilDelegate <NSObject>
/**
 *  用户是否登录
 *  @return YES/NO
 */
- (BOOL)isHadLogin;
/**
 *  登录操作
 */
- (void)login;
/**
 *  退出操作
 */
- (void)logOut;
/**
 *  检测用户是否登录（用户需要登录之后才可以进行的操作）
 *  @param completion 确定是登陆状态，do something
 *  @return YES/NO
 */
- (BOOL)checkUserLoginState:(void(^)())completion;
/**
 *  弹出登录页面，并附有登录与取消的回调
 *  @param loginCompletion  登录成功回调
 *  @param cancelCompletion 取消，关闭页面回调
 *  @param type 退出类型
 */
- (void)presentLoginViewController:(BOOL)animated loginSuccess:(void (^)(id object))loginCompletion cancel:(void (^)(id object))cancelCompletion;
- (void)presentLoginViewController:(BOOL)animated logoutType:(UserLogoutType)type loginSuccess:(void (^)(id object))loginCompletion cancel:(void (^)(id object))cancelCompletion;

@end
