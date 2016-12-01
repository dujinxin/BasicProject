//
//  UIPageControl+Extension.m
//  Guide
//
//  Created by gjg on 16/6/16.
//  Copyright © 2016年 gjg. All rights reserved.
//

#import "UIPageControl+Extension.h"
#import <objc/runtime.h>

@implementation UIPageControl (Extension)


+ (void)load

{
    Method origin = class_getInstanceMethod([self class], @selector(_indicatorSpacing));
    Method custom = class_getInstanceMethod([self class], @selector(custom_indicatorSpacing));
    method_exchangeImplementations(origin, custom);
    
}

- (double)custom_indicatorSpacing
{
    return 14.0;
}

@end
