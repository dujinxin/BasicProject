//
//  UITabBar+Badge.h
//  GJieGo
//
//  Created by dujinxin on 16/6/17.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index; //显示小红点
- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
