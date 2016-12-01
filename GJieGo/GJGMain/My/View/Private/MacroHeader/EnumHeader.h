//
//  EnumHeader.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#ifndef EnumHeader_h
#define EnumHeader_h

typedef NS_ENUM(NSUInteger, AppLaunchType){
    kAppLanuchDefault  =  1,
    kAppInstallFirst       ,  //首次安装
    kAppLanuchFirst        ,  //首次启动，包括覆盖安装
};

typedef NS_ENUM(NSUInteger, UserLoginType){
    kUserLoginDefault  =  1,  //普通登录
    kUserLoginWeiXin       ,  //微信登录
    kUserLoginQQ           ,  //QQ登录
    kUserLoginSina         ,  //新浪登录
};

typedef NS_ENUM(NSUInteger, PayType){
    kUserAliPay  =  1,        //支付宝支付
    kUserWeiXinPay       ,    //微信支付
};

#endif /* EnumHeader_h */
