//
//  UINavigationBar+category.m
//  PRJ_Shopping
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "UINavigationBar+category.h"
#import <objc/runtime.h>
@implementation UINavigationBar (category)
static char alView;

/**
 *  set方法
 */
-(void)setAlphaView:(UIView *)alphaView{
    objc_setAssociatedObject(self, &alView, alphaView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
/**
 *  get方法
 */
-(UIView *)alphaView{
    return objc_getAssociatedObject(self, &alView);
}

-(void)alphaNavigationBarView:(UIColor *)color{
    if (!self.alphaView) {
        //设置背景图片
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //创建
        self.alphaView = [[UIView alloc ]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
        //插入到navigationbar
        
        [self insertSubview:self.alphaView atIndex:0];
        
    }
    
    [self.alphaView setBackgroundColor:color];
}
@end
