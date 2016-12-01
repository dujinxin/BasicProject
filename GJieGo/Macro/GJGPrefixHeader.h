//
//  GJGPrefixHeader.h
//  GJieGo
//
//  Created by dujinxin on 16/5/11.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#ifdef __OBJC__
 
/*运行环境
 *@param kProduction生产环境,kBeta测试环境,都注释为开发环境
 */
//#define kProduction
//#define kBeta


#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "BaseNavigationController.h"

#import "AppMacro.h"
#import "NotificationMacro.h"
#import "VendorMacro.h"
#import "EnumHeader.h"
#import "MyHeader.h"
//环信
#import <Hyphenate_CN/EMSDKFull.h>
#import "EMSDKFull.h"
#import "EaseUI.h"

#import "LoginManager.h"
#import "ShareManager.h"
#import "ChatManager.h"
#import "NotificationManager.h"

#import "GJGApiUrl.h"

#import "MJRefresh.h"

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

#endif
