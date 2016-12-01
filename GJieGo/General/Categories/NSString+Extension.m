//
//  NSString+Extension.m
//  GJieGo
//
//  Created by liubei on 16/5/11.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "NSString+Extension.h"


@implementation NSString (Extension)

- (CGFloat)lb_widthWithFont:(UIFont *)font {

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:dic
                                     context:nil].size;
    return size.width;
}

- (CGFloat)lb_heightWithFont:(UIFont *)font width:(CGFloat)width{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:dic
                                     context:nil].size;
    return size.height;
}
@end
