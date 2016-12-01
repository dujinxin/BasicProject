//
//  DJXNetworkConfig.m
//  GJieGo
//
//  Created by dujinxin on 16/6/21.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "DJXNetworkConfig.h"
#import <CommonCrypto/CommonDigest.h>

@implementation DJXNetworkConfig


/*
 * 获取公共参数字符串
 */
+ (NSString *)commonParameters{
    NSString * token = [[UserDBManager shareManager] getToken];
    if (!token.length){
        token = [self tokenStr:nil];
    }
    
//    token = [token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSNumber * longitude = @116.343651;//@116.343651;//替换为首页获取到的经纬度
    NSNumber * latitude = @39.7319074;//@39.7319074;//替换为首页获取到的经纬度
    NSString * parameters = [self commonParameter:token longitude:longitude latitude:latitude];
    return parameters;
}
/**获取公共参数字符串，自己配置
 * @param token 令牌，UserInfo/GetTokenByKey除外 其他所有接口都需拼接
 * @param longitude 经度，没有定位到时 默认传0
 * @param latitude 纬度，同上
 */
+ (NSString *)commonParameter:(NSString *)token longitude:(NSNumber *)longitude latitude:(NSNumber *)latitude{
    if (!longitude) {
        longitude = @0;
    }
    if (!latitude) {
        latitude = @0;
    }
    NSString * parameters;
    NSString * Channel = @"appStore";
    NSString * Mac = @"";
    NSString * IP = @"";
    if (token) {
        parameters = [NSString stringWithFormat:@"Version=%@&Package=%@&Token=%@&Channel=%@&Longitude=%@&Latitude=%@&Mac=%@&IP=%@",kAppVersion,kPackage,token,Channel,longitude,latitude,Mac,IP];
    }else{
        parameters = [NSString stringWithFormat:@"Version=%@&Package=%@&Channel=%@&Longitude=%@&Latitude=%@&Mac=%@&IP=%@",kAppVersion,kPackage,Channel,longitude,latitude,Mac,IP];
    }
    return parameters;
}
+ (NSString *)getURLString:(NSString *)baseUrl{
    return nil;
}
+ (NSString *)getURLString:(NSString *)baseUrl apiVersion:(NSString *)version detailUrl:(NSString *)dUrl commonParameterStr:(NSString *)cpStr{
    NSString * url = [NSString stringWithFormat:@"%@/%@%@?%@",baseUrl,version,dUrl,cpStr];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
/**初始化app时使用
 * @param 加密方式：md5(md5(uuid)+ md5(date))
 */
+ (NSString *)tokenStr:(NSString *)str{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //NSString * idfv = @"E621E1F8-C36C-495A-93FC-0C247A3E6E5F";
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    NSString * dateStr = [formatter stringFromDate:date];
    NSString * uuidMd5 = [self md5StringFromString:idfv];
    NSString * dateMd5 = [self md5StringFromString:dateStr];
    
    return [self md5StringFromString:[NSString stringWithFormat:@"%@%@",uuidMd5,dateMd5]];
}
+ (NSString *)md5StringFromString:(NSString *)string {
    if(string == nil || [string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}
@end
