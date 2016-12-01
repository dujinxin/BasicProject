//
//  AppMacro.h
//  GJieGo
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 yangzx. All rights reserved.
//
#import "UtilsMacro.h"
#import "BaseModel.h"
#import "BaseView.h"
#import "BaseTableView.h"
#import "BaseViewController.h"
#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "BaseTableViewCell.h"
#import "UIView+frameExtension.h"

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



/** 
 *背景色管理
 **/
#define GJGBackColor [UIColor blueColor]
#define GJGNaviBackColor [UIColor brownColor]
#define GJGGRAYCOLOR GJGRGB16Color(0x999999)
#define GJGBLACKCOLOR GJGRGB16Color(0x333333)
/**
 * 文字统一字号
 **/
#define GJGFontOfSizeForTitle  30.0f
#define GJGFontOfSizeForText   13.0f
#define GJGFontOfSizeForDetail 10.0f

// 线的高度
#define LineHeight 0.5

// 线的宽度
#define LineWidth 0.5

//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define listHeight ScreenWidth * 0.4
#define maskAlpha   0.49
//获取根窗口
#define kAppKeyWindow [UIApplication sharedApplication].keyWindow

#define IOS7 [[[UIDevice currentDevice] systemVersion ]floatValue]>=7.0
#define IOS8 [[[UIDevice currentDevice] systemVersion ]floatValue]>=8.0

// 改变frame
#define ChangeViewX(view,x) [view setFrame:CGRectMake(x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
#define ChangeViewY(view,y) [view setFrame:CGRectMake(view.frame.origin.x, y, view.frame.size.width, view.frame.size.height)];
#define ChangeViewW(view,w) [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, w, view.frame.size.height)];
#define ChangeViewH(view,h) [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, h)];
#define ChangeViewYH(view,y,h) [view setFrame:CGRectMake(view.frame.origin.x, y, view.frame.size.width, h)];
#define ChangeViewXW(view,x,w) [view setFrame:CGRectMake(x, view.frame.origin.y, w, view.frame.size.height)];

// 获取frame
#define VIEW_TX(view) (view.frame.origin.x)
#define VIEW_TY(view) (view.frame.origin.y)
#define VIEW_W(view)  (view.frame.size.width)
#define VIEW_H(view)  (view.frame.size.height)
#define VIEW_BX(view) (view.frame.origin.x + view.frame.size.width)
#define VIEW_BY(view) (view.frame.origin.y + view.frame.size.height)

// 计算字符串size
#define SG_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#define SG_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;

/**
 * 各种颜色
 **/
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

/** #ffddeb **/
#define SGColor_Light_Pink COLOR(255.0f, 221.0f, 235.0, 1.0)
/** #ea4c88 (主题颜色) **/
#define SGColor_Main_Pink COLOR(234.0f, 76.0f, 136.0, 1.0) // COLOR(226.0, 49.0, 116.0, 1.0)

#pragma mark - 背景色
/** #f8f8f8 (灰白色) **/
#define SGColor_BG_White_Gray COLOR(248.0f, 248.0f, 248.0f, 1.0)
/** #ffddea (评论粉色) **/
#define SGColor_BG_Pink COLOR(255.0f, 221.0f, 234.0f, 1.0)
/** #ffddea (评论蓝色) **/
#define SGColor_BG_Blue COLOR(221.0f, 241.0f, 255.0f, 1.0)
/** #ffae00 (等级背景色1) **/
#define SGColor_BG_Level_1 COLOR(255.0f, 174.0f, 0.0f, 1.0)
/** #ff6085 (性别年龄背景色 - 女) **/
#define SGColor_BG_SexAge0 COLOR(255.0f, 96.0f, 133.0f, 1.0)
/** #3996ec (性别年龄背景色 - 男) **/
#define SGColor_BG_SexAge1 COLOR(57.0f, 150.0f, 236.0f, 1.0)
/** #ffc600 (Vip背景色1) **/
#define SGColor_BG_Vip_1 COLOR(255.0f, 198.0f, 0.0f, 1.0)
/** #9e2bff (Vip背景色2 - 超级会员) **/
#define SGColor_BG_Vip_2 COLOR(158.0f, 43.0f, 255.0f, 1.0)
/** #ff6c00 (星座背景色1) **/
#define SGColor_BG_XZ_1 COLOR(255.0f, 108.0f, 0.0f, 1.0)
/** #ec0013 (红人背景色) **/
#define SGColor_BG_HR COLOR(236.0f, 0.0f, 19.0f, 1.0)
/** 教练排班绿色 **/
#define SGColor_BG_Green COLOR(40.0f, 181.0f, 118.0f, 1.0)
/** 教练排班黄色 **/
#define SGColor_BG_Orange COLOR(252.0f, 171.0f, 57.0f, 1.0)

#pragma mark - 线的颜色
#define SGColor_Line_White_Gray COLOR(220.0f, 220.0f, 220.0f, 1.0)

#pragma mark - 字体颜色
/** #444444 （深色，用于普通文本）**/
#define SGColor_Text_Dark COLOR(68.0f, 68.0f, 68.0f, 1.0)
/** #787878 （中色，用于副标题）**/
#define SGColor_Text_Neutral COLOR(120.0f, 120.0f, 120.0f, 1.0)
/** #787878 （浅色）**/
#define SGColor_Text_Light COLOR(170.0f, 170.0f, 170.0f, 1.0)
/** #49d424 （绿色）**/
#define SGColor_Text_Green COLOR(73.0f, 212.0f, 36.0, 1.0)
/** 白色 **/
#define SGColor_Text_White [UIColor whiteColor]
/** #4d6d94 (可点击的文本颜色)**/
#define SGColor_Text_Click COLOR(77.0f, 109.0f, 148.0f, 1.0)
/** 375f90 (蓝色字体)**/
#define SGColor_Text_Blue COLOR(55.0f, 95.0f, 144.0f, 1.0)

#pragma mark - 按钮背景色
/** #787878 （深色，用于按钮背景）**/
#define SGColor_Btn_BG_Gray COLOR(120.0f, 120.0f, 120.0f, 1.0)

#pragma mark - 线的高度
#define SGHeight_Line 0.5




#endif /* AppMacro_h */
