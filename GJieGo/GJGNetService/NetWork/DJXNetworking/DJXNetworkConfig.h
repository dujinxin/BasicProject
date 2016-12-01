//
//  DJXNetworkConfig.h
//  GJieGo
//
//  Created by dujinxin on 16/6/21.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kGJGRequestUrl_v_url_cp(a,b,c,d) [self getURLString:a apiVersion:b detailUrl:c commonParameterStr:d]

@interface DJXNetworkConfig : NSObject

/*
 * @param 获取公共参数字符串，采用默认
 */
+ (NSString *)commonParameters;
/*
 * @param 获取公共参数字符串，自己配置
 * @param token 令牌，UserInfo/GetTokenByKey除外 其他所有接口都需拼接
 * @param longitude 经度，没有定位到时 默认传0
 * @param latitude 纬度，同上
 */
+ (NSString *)commonParameter:(NSString *)token longitude:(NSNumber *)longitude latitude:(NSNumber *)latitude;


+ (NSString *)getURLString:(NSString *)baseUrl;
+ (NSString *)getURLString:(NSString *)baseUrl apiVersion:(NSString *)version detailUrl:(NSString *)dUrl commonParameterStr:(NSString *)cpStr;

/*
 * @param 初始化app时使用
 * @param 加密方式：md5(md5(uuid)+ md5(date))
 */
+ (NSString *)tokenStr:(NSString *)str;

@end
