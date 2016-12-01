//
//  SGSettingUtil.h
//  SGShow
//
//  Created by fanshijian on 15-3-13.
//  Copyright (c) 2015年 fanshijian. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface SGSettingUtil : NSObject

/**
 * 解析字符串成键值对 <id=8242DAF5-EE30-407C-AC02-26B1A5C94AC0&ext=PNG>
 */
+ (NSDictionary *)dictionaryParseFromString:(NSString *)string;

// 获取省份列表
+ (NSArray *)getProvinces;

// 判断数据是否为空或空对象
+ (BOOL)dataIsNull:(id)string;

// 判断数据是否为空或空对象(如果字符串的话是否为@"")
+ (BOOL)dataAndStringIsNull:(id)string;

// 密码＋key md5
//+ (NSString *)getMd5Password:(NSString *)password;

// 设置label的 部分字体颜色
+ (void)setAttributeLabel:(UILabel *)label font:(UIFont *)font color:(UIColor *)color rangeArray:(NSArray *)array;

// 根据城市代码得到对应的城市
+ (NSString *)getCityNameByCityCode:(NSString *)cityCode;

// 处理手机号格式
+ (NSString*)telephoneWithReformat:(NSString *)tmpString;

// 根据手机号获取对应的姓名
//+ (NSString *)getPhoneNameByPhoneNum:(NSString *)phoneNum;

// 获取手机通讯录中所有的手机号码
//+ (NSMutableArray *)getAllPhoneNum;

// 获取手机通讯录授权情况
//+ (BOOL)getAddressBookAuthorizationStatus;

// 根据文本内容自动得到view高度
+ (CGSize)getHeightByString:(NSString *)string andWithViewWidth:(CGFloat)width andWithFontSize:(CGFloat)fontSize;

// 给某个view加线(上下线)
+ (void)addLineWithView:(UIView *)view withUpLineFrame:(CGRect)upFrame withDownLineFrame:(CGRect)downFrame withColor:(UIColor *)color;

// 根据frame加线
+ (void)addLineWithView:(UIView *)view withLineFrame:(CGRect)lineFrame withColor:(UIColor *)color;

// 设置一段字符串显示两种颜色
+ (NSAttributedString *)getDifferentColorString:(NSString *)totalStr oneStr:(NSString *)oneStr color:(UIColor *)oneColor otherStr:(NSString *)otherStr ortherColor:(UIColor *)otherColor withTextFontSize:(CGFloat)fontSize;

// 设置一段字符串显示两种颜色,并且设置每段字符串的字体大小
+ (NSAttributedString *)getDifferentColorString:(NSString *)totalStr oneStr:(NSString *)oneStr color:(UIColor *)oneColor  oneStrFontSize:(CGFloat)fontSize otherStr:(NSString *)otherStr ortherColor:(UIColor *)otherColor otherStrFontSize:(CGFloat)fontSize;

// 给某个view添加手势
+ (void)addTapGestureInView:(UIView *)inView addTarget:(id)target action:(SEL)action withTag:(NSInteger)viewTag;

//  绘制有色矩形view
+ (UIView *)drawColorViewWithRect:(CGRect)rect withColor:(UIColor *)color;

//  生成UILabel对象
+ (UILabel *)allocLabelWithRect:(CGRect)rect withTextColor:(UIColor *)color withTextAligment:(NSTextAlignment)textAlignment withTextFontSize:(CGFloat)fontSize withTitle:(NSString *)title;

//  生成UIButton对象
+ (UIButton *)allocBtnWithRect:(CGRect)rect withBtnType:(UIButtonType)btnType withBtnTitle:(NSString *)btnTitle withTitleColor:(UIColor *)titleColor withTitleFontSize:(CGFloat)fontSize addTarget:(id)target action:(SEL)action;

// 判断字符串为空或者全为空格
+ (BOOL)isBlankString:(NSString *)string;

// 从字符串中提取里边的数字
+ (NSInteger)findNumFromStr:(NSString *)string;

// 获取字符串字节数
+ (NSInteger)charNumberForString:(NSString*)str;

// 改变线条颜色和高度
+ (void)changeLineHeightAndColor:(UILabel *)line;

// 在两个view之间添加颜色view
+ (void)insertSubColorView:(UIView *)parentView withUpView:(UIView *)upView withDownView:(UIView *)downView withColor:(UIColor *)color;

// 改变superView里边的line
+ (void)changeLineViewWithSuperView:(UIView *)superView;

// 传入两个view使两个view处于水平同一条线上
+ (void)changeViewHorizontalCenterWithOneView:(UIView *)oneView withOtherView:(UIView *)otherView;

// 对UIImage进行base64转码
+ (NSString *)base64WithImage:(UIImage *)image;

@end


