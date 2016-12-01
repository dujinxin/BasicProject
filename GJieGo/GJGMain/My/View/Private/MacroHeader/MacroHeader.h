//
//  MacroHeader.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//


#ifndef MacroHeader_h
#define MacroHeader_h




/*************图片*************/
#pragma mark - 图片管理
/*
 *建议使用前两种宏定义,性能高于后者
 */
//读取本地图片
#define JXImageFileWithType(file,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]
//定义UIImage对象
#define JXImageFile(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]
//定义UIImage对象
#define JXImageNamed(nameStr) [UIImage imageNamed:nameStr]




/*************颜色类*************/
#pragma mark - 颜色管理
//RGB颜色转换（16进制->10进制）
#define JXColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define JXColorFromRGBA(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha: alphaValue]
//带有RGBA的颜色设置
#define JXColorFromR_G_B_A(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
//获取RGB颜色
#define JXColorFromR_G_B(r,g,b) JXColorFromR_G_B_A(r,g,b,1.0f)

//透明
#define JXClearColor [UIColor clearColor]
//......

#define JXEeeeeeColor JXColorFromRGB(0xeeeeee)//灰色系 用作背景，分割线等，
#define JXFfffffColor JXColorFromRGB(0xffffff)//白色系 用作背景
#define JXF1f1f1Color JXColorFromRGB(0xf1f1f1)//灰色系 用作背景
#define JXDededeColor JXColorFromRGB(0xdedede)//灰色系 用作分割线颜色，
#define JX333333Color JXColorFromRGB(0x333333)//黑色系 用作字体颜色，
#define JX666666Color JXColorFromRGB(0x666666)//黑色系 用作字体颜色，
#define JX999999Color JXColorFromRGB(0x999999)//黑色系 用作字体颜色
#define JXff5252Color JXColorFromRGB(0xff5252)//红色系 用作特殊字体颜色，

#define jxRGB210Color JXColorFromR_G_B(210,210,210)//灰色系 按钮背景颜色 


//#define JXMainColor   JXColorFromR_G_B(250,229,88) //app 主色调，
#define JXMainColor   JXColorFromRGB(0xfee330)//app 主色调，

#define JXTextColor      JX333333Color //主要文本颜色
#define JXSeparatorColor JXDededeColor //分割线颜色


/*************字体begin*************/
#pragma mark - 字体管理
//方正黑体简体字体定义
#define JXFZHTJW(F)           [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]

#define JXFontForNormal(F)    [UIFont systemFontOfSize:F]
#define JXFontForBold(F)      [UIFont boldSystemFontOfSize:F]
#define JXFontForItalic(F)    [UIFont italicSystemFontOfSize:F]

#define JXFontOfSizeForTitle  30.0f
#define JXFontOfSizeForText   13.0f
#define JXFontOfSizeForDetail 10.0f
/*************字体end*************/

#pragma mark - 尺寸常量管理
/*************尺寸begin*************/
#define kIOS_VERSION          [[[UIDevice currentDevice] systemVersion] floatValue]

#define kScreenBounds         [[UIScreen mainScreen] bounds]
#define kScreenWidth          ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight         ([UIScreen mainScreen].bounds.size.height)
#define kStartHeight          ((kIOS_VERSION >= 7.0)?0.0:20.0)
#define kStatusBarHeight      ((kIOS_VERSION >= 7.0)?20.0:0.0)
#define kNavigationBarHeight  44.f
#define kNavStatusHeight      (kStatusBarHeight+kNavigationBarHeight)
#define kTabBarHeight         49.f
#define kHWPercent            (kScreenHeight/kScreenWidth) //高宽比
#define kPercent              (kScreenWidth /375.0f) //目前是以6的尺寸所做的图，为了其他尺寸屏幕能够更好的显示，相应的比例应该做些调整
#define kWPercent             (kScreenWidth /375.0f)
#define kHPercent             (kScreenHeight /667.0f)

#define iPhone4               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) :NO)
#define iPhone5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)



//程序的本地化,引用国际化的文件
#define JXLocalizedString(x, ...)   NSLocalizedString(x, nil)

//设置View的tag属性
#define JXViewWithTag(view, tag)    [view viewWithTag :tag]

//G－C－D
#define JXDispatch_async_global(GCDBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), GCDBlock)
#define JXDispatch_async_main(block) dispatch_async(dispatch_get_main_queue(),block)

//NSUserDefaults 实例化
#define kUserDefaults             [NSUserDefaults standardUserDefaults]

#define JXWeakSelf(self)          __weak __typeof(&*self)weakSelf = self;


//#define kDebug
#define kShowLog

#ifdef kDebug
#define JXDebugColor  [UIColor redColor]
#else
#define JXDebugColor  [UIColor clearColor]
#endif

/**
 *  打印设置
 */
#ifdef kShowLog
#define NSLog(fmt, ...) NSLog(fmt,##__VA_ARGS__)
#else
#define NSLog(fmt, ...)
#endif

#endif /* MacroHeader_h */





