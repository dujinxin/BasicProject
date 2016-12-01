//
//  VendorMacro.h
//  GJieGo
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#ifndef VendorMacro_h
#define VendorMacro_h

/**********************所有的Key和Secret都以k开头****************************/
#ifdef kProduction     /* 生产环境 */

/**
 * 环信
 **/
#define kHXApnsName           @"guangjiegoDis"

#else

#ifdef  kBeta

#define kHXApnsName           @"guangjiegoDev"

#else

#define kHXApnsName           @"guangjiegoDev"

#endif
#endif

/**
 *极光推送(生产环境)
 **/
#define kJGAppKey           @""
#define kJGAppSecret        @""

/**
 * 高德地图
 **/
#define kGDAppKey           @""
#define kGDAppSecret        @""

/**
 * 微信
 **/
#define kWeiXinAppId         @"wx47f94c234b62e5fe"
#define kWeiXinAppSecret     @"bb823cf325e1122432bc53a8a1552483"
#define kWeiXinRefreshToken  @""

/**
 * 腾讯
 **/
#define kTencentAppId         @"1105124301"
#define kTencentAppSecret     @"wMCa9AGqpYsi4vLK"

/**
 * 新浪
 **/
#define kSinaAppKey          @""
#define kSinaAppSecret       @""

/**
 * 友盟
 **/
#define kUmengAppKey           @"575e638b67e58eeef200238f"
#define kUmengAppSecret        @""

/**
 * 环信
 **/

#define kHXAppKey           @"guangjiego#gjgapp"
#define kHXAppSecret        @"YXA6DbMrIeFPeoYmpvsNj7ltG2tYLzc"
#define kClientSecret       @"YXA6cJWuID6MEeaCfSWen-3L4w"

/**
 * 支付ping++
 **/
#define kPingAppKey           @""
#define kPingAppSecret        @""

#endif /* VendorMacro_h */
