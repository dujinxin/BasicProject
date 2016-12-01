//
//  UIView+Controller.m
//  GJieGo
//
//  Created by liubei on 16/4/29.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "UIView+Controller.h"

@implementation UIView (Controller)
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
