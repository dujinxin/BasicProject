//
//  NSString+Extension.h
//  GJieGo
//
//  Created by liubei on 16/5/11.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

- (CGFloat)lb_widthWithFont:(UIFont *)font;
- (CGFloat)lb_heightWithFont:(UIFont *)font width:(CGFloat)width;
@end
