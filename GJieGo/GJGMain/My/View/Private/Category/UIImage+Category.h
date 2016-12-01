//
//  UIImage+Category.h
//  GJieGo
//
//  Created by dujinxin on 16/5/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Category)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
