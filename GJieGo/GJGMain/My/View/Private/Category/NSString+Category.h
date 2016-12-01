//
//  NSString+Category.h
//  JXView
//
//  Created by dujinxin on 16/4/26.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)

//用户名 6-16位只含有汉字、数字、字母、下划线，下划线位置不限
+ (BOOL)validateUserName:(NSString *)name;
+ (BOOL)validateTelephone:(NSString *)tel;
+ (BOOL)validatePassword:(NSString *)password;
+ (BOOL)validateVerficationCode:(NSString *)code;
+ (BOOL)validateInvitationCode:(NSString *)code;



#pragma mark 保存图片到document
+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
@end
