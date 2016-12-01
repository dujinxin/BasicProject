//
//  SGAlertUtil.h
//  SGShow
//
//  Created by fanshijian on 15-3-10.
//  Copyright (c) 2015年 fanshijian. All rights reserved.
//  提示语类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SGAlertUtil : NSObject {
    MBProgressHUD *promptHUD;
}

@property (nonatomic,assign)BOOL isShow;  // 控制是否重复显示

+ (id)alertManager;

// 显示提示语，一闪而逝
- (void)showPromptInfo:(NSString *)info;

// alert，单个按钮，没有回调
+ (void)showAlertInfoSingle:(NSString *)info;
// alert，单个按钮，有回调
+ (void)showAlertInfoSingle:(NSString *)info delegate:(id)delegate;
// alert，两个按钮，有回调
+ (void)showAlertInfoDouble:(NSString *)info delegate:(id)delegate;

//网络请求显示HUD timeOut :网络请求超过timeOut值隐藏HUD
+(void)showHUDAndHidentAfterTimeOut:(NSInteger)timeOut;
//请求成功隐藏HUD
+(void)hidentHUDAfterRequestSuccess;
@end
