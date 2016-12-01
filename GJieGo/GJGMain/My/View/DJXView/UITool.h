//
//  UITool.h
//  LimitFreeProject
//
//  Created by dujinxin on 14-10-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXButton.h"
#import "JXImageView.h"
#import "JXLabel.h"


#ifndef JXButton
#ifdef JXButton_h
#define JXButton JXButton
#else
#define JXButton UIButton
#endif
#endif


#ifndef JXImageView
#ifdef JXImageView_h
#define JXImageView JXImageView
#else
#define JXImageView UIImageView
#endif
#endif



#ifndef JXLabel
#ifdef JXLabel_h
#define JXLabel JXLabel
#else
#define JXLabel UILabel
#endif
#endif
//将创建控件的通用的代码 可以写在此类中
@interface UITool : NSObject

/*
 快速创建基本视图控件
 */
//button
+(JXButton *)createButtonWithTitle:(NSString *)title imageName:(NSString *)imageName frame:(CGRect)frame font:(UIFont *)font tag:(NSInteger)tag block:(void(^)(id obj))block;
//label
+(JXLabel *)createLabelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font frame:(CGRect)frame;
//imageView
+(JXImageView *)createImageViewWithImageName:(NSString *)imageName frame:(CGRect)frame tag:(NSInteger )tag;

//背景视图
+(UIView *)createBackgroundViewWithColor:(UIColor *)color frame:(CGRect)frame;
//item
+(UIBarButtonItem *)createItemWithTitle:(NSString *)title imageName:(NSString *)imageName delegate:(id)delegate selector:(SEL)selector;
+(UIBarButtonItem *)createItemWithNormalTitle:(NSString *)normalTitle selectedTitle:(NSString *)selectedTitle normalImage:(NSString *)normalImage selectedImage:(NSString * )selectedImage delegate:(id)delegate selector:(SEL)selector tag:(NSInteger)tag;
//tab
//循环创建button
//+(UIView *)createButtonsWithClass:(Class *)className count:(NSInteger)count row:(NSInteger)row calumn:(NSInteger)calumn tag:(NSInteger)tag titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray;
+(UIView *)createButtonsWithClassName:(NSString *)className count:(NSInteger)count row:(NSInteger)row calumn:(NSInteger)calumn tag:(NSInteger)tag titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray delegate:(id)delegate selector:(SEL)selector;


/*
 *弹窗提示
 */
+ (void)showAlertView:(NSString *)message;
+ (void)showAlertView:(NSString *)message target:(id)target;
@end
