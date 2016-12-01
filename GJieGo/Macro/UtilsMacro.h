//
//  UtilsMacro.h
//  GJieGo
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h



/** 
 *颜色
 **/
#define GJGRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define GJGRGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define GJGRGB16Color(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/** 
 *字体管理
 **/
#define GJGFZHTJWSize(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]//方正黑体简体字体定义
#define GJGFontForNormalSize(F) [UIFont systemFontOfSize:F]
#define GJGFontForBoldSize(F) [UIFont boldSystemFontOfSize:F]
#define GJGFontForItalicSize(F) [UIFont italicSystemFontOfSize:F]

/** 
 *获取硬件信息
 **/
#define GJGSCREEN_W [UIScreen mainScreen].bounds.size.width
#define GJGSCREEN_H [UIScreen mainScreen].bounds.size.height
#define GJGCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
//#define GJGCurrentSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

/** 
 *适配
 **/
#define GJGiOS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define GJGiOS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define GJGiOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define GJGiOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define GJGiOS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#define GJGiPhone4_OR_4s    (GJGSCREEN_H == 480)
#define GJGiPhone5_OR_5c_OR_5s   (GJGSCREEN_H == 568)
#define GJGiPhone6_OR_6s   (GJGSCREEN_H == 667)
#define GJGiPhone6Plus_OR_6sPlus   (GJGSCREEN_H == 736)
#define GJGiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/** 
 *弱指针
 **/
#define GJGWeakSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;

/**
 * 使用图片
 * UIImage *image = GJGLoadImage(icon,png);
 **/
#define GJGLoadImage(fileName,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileName ofType:type]]
#define GJGLoadArray(fileArrayName,type) [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileArrayName ofType:type]]
#define GJGLoadDict(fileDictName,type) [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileDictName ofType:type]]

/** 
 *多线程GCD
 **/
#define GJGGlobalGCD(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GJGMainGCD(block) dispatch_async(dispatch_get_main_queue(),block)

/** 
 *数据存储
 **/
#define kGJGUserDefaults [NSUserDefaults standardUserDefaults]
#define kGJGCacheDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) laGJGObject]
#define kGJGDocumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define kGJGTempDir NSTemporaryDirectory()

#endif /* UtilsMacro_h */
