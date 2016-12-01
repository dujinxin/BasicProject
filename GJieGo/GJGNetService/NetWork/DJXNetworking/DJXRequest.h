//
//  DJXRequest.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "DJXBasicRequest.h"
#import "LoginManager.h"


@interface DJXRequest : DJXBasicRequest<UIAlertViewDelegate>

@property (nonatomic) BOOL useCache;

// 返回当前缓存的对象
- (id)cacheJson;

// 是否当前的数据从缓存获得
- (BOOL)isDataFromCache;

// 返回是否当前缓存需要更新
- (BOOL)isCacheVersionExpired;

// 强制更新缓存
- (void)startWithoutCache;

// 手动将其他请求的JsonResponse写入该请求的缓存
- (void)saveJsonResponseToCacheFile:(id)jsonResponse;

// For subclass to overwrite
- (NSInteger)cacheTimeInSeconds; //缓存有效时间
- (long long)cacheVersion;
- (id)cacheSensitiveData;
- (BOOL)isUseFormat;             //数据统一处理
- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess;//统一处理结构

@end
