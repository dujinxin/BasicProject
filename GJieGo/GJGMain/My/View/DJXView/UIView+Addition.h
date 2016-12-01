//
//  UIView+Addition.h
//  THCustomer
//
//  Created by dujinxin on 13-8-11.
//  Copyright (c) 2013年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIView (Addition)
/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat jxLeft;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat jxTop;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat jxRight;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat jxBottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat jxWidth;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat jxHeight;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat jxCenterX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat jxCenterY;
/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint jxOrigin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize jxSize;

/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;

/*取消阴影*/
- (void)hideShadow;

/*设置阴影*/
- (void)shadowColor:(UIColor*)color shadowOffset:(CGSize)offset shadowRadius:(CGFloat)radius shadowOpacity:(CGFloat)opacity;

/*设置圆角*/
- (void)cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color;

/*既有圆角又有阴影*/
- (void)shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)offset shadowRadius:(CGFloat)sradius shadowOpacity:(CGFloat)opacity
	   cornerRadius:(CGFloat)cradius borderWidth:(CGFloat)width borderColor:(UIColor *)borderColor;

- (void)shake;

- (void)doHide;

- (void)addCustomActivityIndicator;
- (void)removeCustomActivityIndicator;
//- (void)showNotice:(NSString *)string;

+ (UIView *)backButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
