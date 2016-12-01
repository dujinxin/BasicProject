//
//  ProjectControl.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#ifndef ProjectControl_h
#define ProjectControl_h

#pragma mark - production
#ifdef kProduction     /* 生产环境 */

/*版本号*/
#define K_APP_VERSION       @"1.0.0"
#define K_VERSION_CODE      1
#define kHostUrl            @""
/*
 *@param 极光推送(生产环境)
 */
#define kJGAppKey           @"0349f2ca93b61dd36f3de671"
#define kJGAppSecret        @"9f46462632a5ddad4cbf9dbf"

/*
 *@param 高德
 */
#define
/*
 *@param 微信
 */
#define kWeiXinAppId         @"wxd77706cf2956c97b"
#define kWeiXinAppSecret     @"8f7d607ada499035f20abf457cc534d0"
#define kWeiXinRefreshToken  @""
/*
 *@param 新浪
 */
#define kSinaAppKey          @"2892557353"
#define kSinaAppSecret       @"d9bb1b9ca395dd30e5366ecdd4bab98b"
/*
 *@友盟
 */
#define
#define

#else


#pragma mark - development
#ifdef kDevelopment    /* 开发环境 */

#define kHostUrl          @""
/*
 *@param 个推(开发环境)
 */
#define kAppKey           @"xcsjdctXU99HuqDUm1SpW8"
#define kAppId            @"WAI5zV4Xzg71bKNxS4J902"
#define kAppSecret        @"pDOXNhx4HqAyoThqd9vlt7"

#pragma mark - test
#else                  /* 测试环境 */
/*
 *@param 域名
 */
#define kHostUrl          @""
/*
 *@param 极光推送(测试环境)
 */
#define kJGAppKey           @"a0bf522ae9b3cfc06038afae"
#define kJGAppSecret        @"602b655aa21f6803bdc588ed"

#endif

#pragma mark - development and test shared

#define K_APP_VERSION       @"1.0.0"
#define K_VERSION_CODE      1

/*
 *@param 高德
 */
#define kGaode              @""

/*
 *@param 微信
 */
#define kWeiXinAppId         @"wxd77706cf2956c97b"
#define kWeiXinAppSecret     @"8f7d607ada499035f20abf457cc534d0"
#define kWeiXinRefreshToken  @""
/*
 *@腾讯
 */
#define kQQAppId             @"1105124301"
#define kQQAppKey            @"wMCa9AGqpYsi4vLK"
/*
 *@param 新浪
 */
#define kSinaAppKey          @"2892557353"
#define kSinaAppSecret       @"d9bb1b9ca395dd30e5366ecdd4bab98b"
/*
 *@友盟统计
 */
#define kUmengAppkey         @""
#define kUMeng               @""

#pragma mark -

#endif

#pragma mark - other

#define kAppUrlInAppStore    @""



#endif /* ProjectControl_h */
