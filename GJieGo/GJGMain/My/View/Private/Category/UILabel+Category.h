//
//  UILabel+Category.h
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/26.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(Category)
/** font */
@property (nonatomic,copy) UIFont *appearanceFont UI_APPEARANCE_SELECTOR;
- (void)setAppearanceFont:(UIFont *)appearanceFont;

- (UIFont *)appearanceFont;

@end
