//
//  NetService.h
//  GJieGo
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetWorking.h"

typedef void(^ResultBlock)(id responseobject,NSError *error);
typedef void(^DownloadBlock)(id responseo,id filepath,NSError *error);
typedef void(^uploadBlock)(NSURLSessionDataTask *task,id responseObject,NSError *error);
typedef NS_ENUM(NSInteger, RequestType) {
    RequestPostType,
    RequestGetType
};

typedef enum{
    ReachabilityStatusNotReachable,
    ReachabilityStatusSuccess,
    ReachabilityStatusError
}ReachabilitySatus;

@interface AFNetWorkRequest__ : NSObject
@property (nonatomic, copy) ResultBlock Resultblock;
@property (nonatomic, copy) DownloadBlock downloadblock;
@property (nonatomic, assign)NSInteger status;

- (void)requestUrl:(NSString *)urlString requestType:(RequestType)type parameters:(NSDictionary *)parameters requestblock:(ResultBlock)resultBlock;
- (void)downloadWithrequest:(NSString *)urlString downloadpath:(NSString *)downloadpath downloadblock:(DownloadBlock)downloadblock;
- (void)uploadImage:(NSDictionary *)dic uploadpath:(NSString *)uploadpath imageData:(NSData *)imagData uploadblock:(uploadBlock)uploadblock;
- (NSInteger)requestPostTypeWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters requestblock:(ResultBlock)resultBlock;

@end
