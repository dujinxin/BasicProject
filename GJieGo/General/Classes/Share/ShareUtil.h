
//
//  ShareUtil.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShareUtilDelegate <NSObject>
/**
 检测要分享到的app是否已安装
 @param sns    分享到的平台是否已安装。
 
 */
- (BOOL)checkIsAppInstalled:(UserShareSns)sns;
/**
 发送分享内容到多个分享平台
 
 @param platformTypes    分享到的平台，数组的元素是`UMSocialSnsPlatformManager.h`定义的平台名的常量字符串，例如`UMShareToSina`，`UMShareToTencent`等。
 @param object           分享的任意对象,model or NSDictionary
 @param success          发送完成执行的block对象
 @param failure          发送完成执行的block对象
 @param presentedController 如果发送的平台微博只有一个并且没有授权，传入要授权的viewController，将弹出授权页面，进行授权。可以传nil，将不进行授权。
 
 */
- (void)showCustomShareViewWithObject:(id)object presentedController:(UIViewController *)presentedController success:(void(^)(id object,UserShareSns sns))success failure:(void(^)(id object,UserShareSns sns))failure;
- (void)showCustomShareViewWithObject:(id)object shareType:(UserShareType)type presentedController:(UIViewController *)presentedController success:(void(^)(id object,UserShareSns sns))success failure:(void(^)(id object,UserShareSns sns))failure;
/**
 发送分享内容到多个分享平台
 
 @param platformTypes    分享到的平台，数组的元素是`UMSocialSnsPlatformManager.h`定义的平台名的常量字符串，例如`UMShareToSina`，`UMShareToTencent`等。
 @param content          分享的文字内容
 @param image            分享的图片,可以传入UIImage类型或者NSData类型
 @param location         分享的地理位置信息
 @param urlResource      图片、音乐、视频等url资源
 @param success          发送完成执行的block对象
 @param failure          发送完成执行的block对象
 @param presentedController 如果发送的平台微博只有一个并且没有授权，传入要授权的viewController，将弹出授权页面，进行授权。可以传nil，将不进行授权。
 
 */
- (void)showCustomShareViewWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description presentedController:(UIViewController *)presentedController success:(void(^)(id object,UserShareSns sns))success failure:(void(^)(id object,UserShareSns sns))failure;
- (void)showCustomShareViewWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description infoId:(NSString *)infoId shareType:(UserShareType)type presentedController:(UIViewController *)presentedController success:(void(^)(id object,UserShareSns sns))success failure:(void(^)(id object,UserShareSns sns))failure;

@end
