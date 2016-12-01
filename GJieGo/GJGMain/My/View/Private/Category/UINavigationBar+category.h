//
//  UINavigationBar+category.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (category )

/**
 *  自定义导航栏上的view
 */
@property (nonatomic,strong) UIView * alphaView;

/**
 *  给外界一个方法，来改变颜色
 */
-(void)alphaNavigationBarView:(UIColor *)color;

@end
