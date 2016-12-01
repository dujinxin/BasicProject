//
//  AppMacro.h
//  GJieGo
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#define kAppVersion    @"1.0.3"
#define kPackage       @"GjieGo"

#ifdef kProduction       /* 生产环境 */
#define kHostUrl       @"http://appc.guangjiego.com"
#define kDiscoveryUrl  @"http://find.guangjiego.com/Discovery/home.html"  //发现
#define kStatisticUrl  @"http://statistics.guangjiego.com/UserOperStat/Index"//埋点
#define kPrivacyUrl    @"http://find.guangjiego.com/AboutUs/UserAgreement.html" //隐私政策
#define kGrowLevelUrl  @"http://find.guangjiego.com/FAQ/growth.html"            //成长值

#else

#ifdef kBeta             /* 测试环境 */
#define kHostUrl       @"http://172.136.1.167:8888"
#define kDiscoveryUrl  @"http://172.136.1.220/Discovery/home.html"        //发现
#define kStatisticUrl  @"Http://172.136.1.168:8889/UserOperStat/Index"    //埋点
#define kPrivacyUrl    @"http://172.136.1.220/AboutUs/UserAgreement.html" //隐私政策
#define kGrowLevelUrl  @"http://172.136.1.220/FAQ/growth.html"            //成长值

#else                    /* 开发环境 */
#define kHostUrl       @"http://172.136.1.168:8888"
#define kDiscoveryUrl  @"http://172.136.1.220:168/Discovery/home.html"    //发现
#define kStatisticUrl  @"Http://172.136.1.168:8889/UserOperStat/Index"    //埋点
#define kPrivacyUrl    @"http://172.136.1.220/AboutUs/UserAgreement.html" //隐私政策
#define kGrowLevelUrl  @"http://172.136.1.220/FAQ/growth.html"            //成长值


#endif
#endif


#define kAppStoreUrl   @"https://itunes.apple.com/us/app/guang-jie-gou/id1132022124?l=zh&ls=1&mt=8"                                                       //下载链接




#endif /* AppMacro_h */
