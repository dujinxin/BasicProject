//
//  NetService.m
//  GJieGo
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#if TARGET_IPHONE_SIMULATOR
#include <net/route.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <sys/sysctl.h>
#include <string.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#include "resolv.h"
#else
#include <arpa/inet.h>
#include <stdio.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <sys/sysctl.h>
#include <string.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#include "resolv.h"
#endif

#import "NetService.h"

@interface AFNetWorkRequest__()
//重写属性getter方法@property (nonatomic,           assign,getter=connectedToNetwork)
@property (nonatomic, assign,getter=connectedToNetwork) BOOL connected;
@property (nonatomic, retain) NSURLSessionTask *task;
@end

@implementation AFNetWorkRequest__

- (NSInteger)requestPostTypeWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters requestblock:(ResultBlock)resultBlock{
    if (!self.connected) {
        NSLog(@"没有网络,请检查网络状态");
        return ReachabilityStatusNotReachable;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
    
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        resultBlock(dic,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"file----------------------------------------------file-error");
        resultBlock(@{@"message":@"请求数据失败，请重新请求", @"status":@"555555555"}, error);
    }];
    return ReachabilityStatusSuccess;
}

- (void)requestUrl:(NSString *)urlString requestType:(RequestType)type parameters:(NSDictionary *)parameters requestblock:(ResultBlock)resultBlock {
    if (!self.connected) {
        NSLog(@"没有网络,请检查网络状态");
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
    switch (type) {
        case RequestGetType:
        {
            [manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                resultBlock(dic,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"file----------------------------------------------file-error");
                resultBlock(nil,error);
                
            }];
        }
            break;
        case RequestPostType:
        {
            [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                resultBlock(dic,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"file----------------------------------------------file-error");
                resultBlock(task, error);
            }];
        }
            break;
        default:
            break;
    }
    
}

- (BOOL) connectedToNetwork{
    // 创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;//sockaddr_in是与sockaddr等价的数据结构
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;//sin_family是地址家族，一般都是“AF_xxx”的形式。通常大多用的是都是AF_INET,代表TCP/IP协议族
    
    /**
     *  SCNetworkReachabilityRef: 用来保存创建测试连接返回的引用
     *
     *  SCNetworkReachabilityCreateWithAddress: 根据传入的地址测试连接.
     *  第一个参数可以为NULL或kCFAllocatorDefault
     *  第二个参数为需要测试连接的IP地址,当为0.0.0.0时则可以查询本机的网络连接状态.
     *  同时返回一个引用必须在用完后释放.
     *  PS: SCNetworkReachabilityCreateWithName: 这个是根据传入的网址测试连接,
     *  第二个参数比如为"www.apple.com",其他和上一个一样.
     *
     *  SCNetworkReachabilityGetFlags: 这个函数用来获得测试连接的状态,
     *  第一个参数为之前建立的测试连接的引用,
     *  第二个参数用来保存获得的状态,
     *  如果能获得状态则返回TRUE，否则返回FALSE
     *
     */
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress); //创建测试连接的引用：
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flagsn");
        return NO;
    }
    
    /**
     *  kSCNetworkReachabilityFlagsReachable: 能够连接网络
     *  kSCNetworkReachabilityFlagsConnectionRequired: 能够连接网络,但是首先得建立连接过程
     *  kSCNetworkReachabilityFlagsIsWWAN: 判断是否通过蜂窝网覆盖的连接,
     *  比如EDGE,GPRS或者目前的3G.主要是区别通过WiFi的连接.
     *
     */
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

- (void)downloadWithrequest:(NSString *)urlString downloadpath:(NSString *)downloadpath downloadblock:(DownloadBlock)downloadblock {
    if (!self.connected) {
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    self.task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *desturl = [NSURL fileURLWithPath:downloadpath];
        return desturl;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        downloadblock(response,filePath,error);
    }];
    [self.task resume];
}
//-(void)stopdownload {
//    [self.task suspend];
//}
//该方法只能适用post上传
- (void)uploadImage:(NSDictionary *)dic uploadpath:(NSString *)uploadpath imageData:(NSData *)imagData uploadblock:(uploadBlock)uploadblock {
    if (!self.connected) {
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:uploadpath parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:imagData name:@"1"];
        /*
         第一个参数: 需要上传的文件二进制
         第二个参数: 服务器对应的参数名称
         第三个参数: 文件的名称
         第四个参数: 文件的MIME类型
         */
        //        [formData appendPartWithFileData:data name:@"file" fileName:@"abc.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        uploadblock(task,responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        uploadblock(task,nil,error);
    }];
}
/*
 AFNetworkRequest *request = [[AFNetworkRequest alloc] init];
 request.datasource = self;
 NSString *urlStr = [NSString stringWithFormat:@"s?command=ST_H&access_token=%@",[request getToken]];
 NSData *imgData = UIImagePNGRepresentation(image);
 [request uploadImage:urlStr imgData:imgData resultBlock:^(id responseObject, NSError *error) {
 STLog(@"%@",responseObject);
 [MBProgressHUD showSuccess:responseObject[@"info"]];
 }];
 
 */
+ (void)requestHomeCity:(void (^)(id result))callbackBlock RequestUrl:(NSString *)stringUrl params:(NSDictionary *)params{
    AFNetWorkRequest__ *requestPackage = [AFNetWorkRequest__ new];
    [requestPackage requestUrl:stringUrl requestType:RequestPostType parameters:params requestblock:^(id responseobject, NSError *error) {
        
    }];
}
@end
