//
//  EnumHeader.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#ifndef EnumHeader_h
#define EnumHeader_h
/*
 * @param AppLaunchType app启动类型
 */
typedef NS_ENUM(NSUInteger, AppLaunchType){
    kAppLanuchDefault  =  1,
    kAppInstallFirst       ,  //首次安装
    kAppLanuchFirst        ,  //首次启动，包括覆盖安装
};
/*
 * @param UserLoginType 用户来源
 */
typedef NS_ENUM(NSUInteger, UserLoginType){
    kUserLoginDefault  =  1,  //普通登录
    kUserLoginWeiXin       ,  //微信登录
    kUserLoginQQ           ,  //QQ登录
    kUserLoginSina         ,  //新浪登录
};
/*
 * @param PayType 支付方式
 */
typedef NS_ENUM(NSUInteger, PayType){
    kUserAliPay  =  1,        //支付宝支付
    kUserWeiXinPay       ,    //微信支付
};
/*
 * @param UserType 用户类型
 */
typedef NS_ENUM(NSInteger, UserType) {
    Guider   =   2,
    User     =   1
};
/*
 * @param SortType  排序类型
 */
typedef NS_ENUM(NSInteger, SortType) {
    SortDistanceType   = 1,           //距离
    SortCollectType,                  //收藏
};
/*
 * @param VerificationCodeType 验证码类型
 */
typedef NS_ENUM(NSInteger, VerificationCodeType){
    VerificationCodeIdentityType, 	    //身份验证
    VerificationCodeLoginConfirmType, 	//登陆确认
    VerificationCodeLoginErrorType,     //登陆异常
    VerificationCodeRegisterType, 	    //用户注册
    VerificationCodeActivityType, 	    //活动确认
    VerificationCodeModifyPasswordType, //修改密码
    VerificationCodeModifyInfoType, 	//信息变更
    VerificationCodeInterviewType 	    //招聘面试
};

/*
 * @param ShareSNS 分享平台
 */
typedef NS_ENUM(NSInteger, UserShareSns){
    ShareToWechatSession   = 0,   //微信好友
    ShareToWechatTimeline, 	      //微信朋友圈
    ShareToQQ,                    //QQ
    ShareToQzone, 	              //QQ空间
    ShareToTencent, 	          //腾讯微博
    ShareToSina,                  //新浪微博
    ShareToShoppingGo	          //逛街购app
};


/*
 * @param UserShareType 用户分享信息类型
 */
typedef NS_ENUM(NSInteger, UserShareType){
    UserOrderShareType   = 1,   //晒单分享
    UserPromotionShareType, 	//促销分享
    UserHotPushShareType,       //热推分享
    UserShopHomeShareType, 	    //商铺首页分享
    UserCouponShareType, 	    //优惠券分享
    UserDiscoverShareType,      //发现分享
    UserGuiderDetailShareType, 	//导购详情分享
    UserUserDetailShareType,    //用户详情分享
    UserInviteShareType,        //邀请
    UserSuperMarketShareType    //商场、购物中心等首页分享
};





#endif /* EnumHeader_h */
