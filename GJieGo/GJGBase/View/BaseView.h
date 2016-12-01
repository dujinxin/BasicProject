//
//  BaseView.h
//  GJieGo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationMacro.h"
#import "PrefixHeader.pch"
#import "UtilsMacro.h"
#import "VendorMacro.h"
#import "AppMacro.h"

@interface BaseView : UIView

- (UIButton *)makeButtonWithFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag target:(id)target action:(SEL)action;
/***
 如果返回NO，字符串不为空
 返回YES，字符串为空
 **/
- (BOOL)isBlankString:(NSString *)string;
@end
