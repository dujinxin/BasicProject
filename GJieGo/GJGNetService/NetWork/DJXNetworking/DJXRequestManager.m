//
//  DJXRequestManager.m
//  JXView
//
//  Created by dujinxin on 15-3-26.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXRequestManager.h"
#import "DJXBasicRequest.h"


@interface DJXRequestManager(){
    AFHTTPSessionManager * manager;
}

@end

@implementation DJXRequestManager

static DJXRequestManager * requestManager = nil;
+ (DJXRequestManager *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestManager = [[DJXRequestManager alloc] init];
        [requestManager initData];
    });
    return requestManager;
}


- (void)initData
{
    manager = [AFHTTPSessionManager manager];
    _requestDictionary = [NSMutableDictionary dictionary];
    manager.operationQueue.maxConcurrentOperationCount = 4;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//，任意类型的数据，自己解析
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", @"application/javascript", @"text/js", nil];
//    _reachbilityManager = [AFNetworkReachabilityManager sharedManager];
//    [_reachbilityManager startMonitoring];
}
- (NSString *)buildRequestUrl:(DJXBasicRequest *)request {

    //NSString *detailUrl = [request requestUrl];
    NSString *detailUrl = request.requestUrl;
    if ([detailUrl hasPrefix:@"http"]) {
        return detailUrl;
    }
    
    NSString *baseUrl;
    if ([request useCDN]) {
        if ([request cdnUrl].length > 0) {
            baseUrl = [request cdnUrl];
        }
    } else {
        if ([request baseUrl].length > 0) {
            baseUrl = [request baseUrl];
        }
    }
    NSString * url = [NSString stringWithFormat:@"%@/%@%@?%@",baseUrl,kApiVersion,detailUrl,[DJXNetworkConfig commonParameters]];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - OperationMethod
/*任务队列的操作*/
- (void)addOperation:(DJXBasicRequest *)request {
    if (request.sessionTask != nil) {
        NSString *key = [self requestHashKey:request.sessionTask];
        _requestDictionary[key] = request;
        NSLog(@"Add request: %@", request.requestUrl);
        NSLog(@"Request queue size = %lu", (unsigned long)[_requestDictionary count]);
    }
}
- (void)removeOperation:(DJXBasicRequest *)request {
    if (request.sessionTask != nil) {
        NSString *key = [self requestHashKey:request.sessionTask];
        [_requestDictionary removeObjectForKey:key];
        NSLog(@"Remove request: %@", request.requestUrl);
        NSLog(@"Request queue size = %lu", (unsigned long)[_requestDictionary count]);
    }
}
#pragma mark - RequestMethod
/*请求类的操作*/
- (id)getRequestByApiTag:(DJXApiTag)tag;
{
    return NULL;
}
- (id)getRequestByKey:(NSString *)key;
{
    NSDictionary *copyRecord = [_requestDictionary copy];
    DJXBasicRequest *request = copyRecord[key];
    if (request) {
        return request;
    }
    return NULL;
}

- (void)cancelRequestByViewController:(id)vc
{
    NSDictionary *copyRecord = [_requestDictionary copy];
    for (NSString * key in copyRecord) {
        DJXBasicRequest *request = copyRecord[key];
        if(request.delegate == vc)
            [self cancelRequest:request];
    }
}
- (void)cancelRequests {
    NSDictionary *copyRecord = [_requestDictionary copy];
    for (NSString * key in copyRecord) {
        DJXBasicRequest *request = copyRecord[key];
        [self cancelRequest:request];
    }
}
- (void)cancelRequest:(DJXBasicRequest *)request
{
    [request.sessionTask cancel];
    [self removeOperation:request];
    request.delegate = nil;
    [request clearCompletionBlock];
    //
    [self hideAllLoadView:self.view animated:YES];
}
- (void)addRequests {
    NSDictionary *copyRecord = [_requestDictionary copy];
    for (NSString * key in copyRecord) {
        DJXBasicRequest *request = copyRecord[key];
        if (![request.className isEqualToString:NSStringFromClass([UserTokenObj class])] || ![request.className isEqualToString:NSStringFromClass([RefreshTokenObj class])]) {
            [self removeOperation:request];
            [self addRequest:request];
        }else{
            [self removeOperation:request];
        }
    }
}
- (void)addRequest:(DJXBasicRequest *)request {
    
//    if (!request.reachbilityManager.isReachable) {
//        //[request requestFailed:@"网络连接断开，请检查网络后重试"];
//        [[JXViewManager sharedInstance] showJXNoticeMessage:@"网络连接断开，请检查网络后重试"];
//        return;
//    }
    
    
    
    [self showLoadView:request.view loadText:request.loadText animated:request.isShowLoadView];
    
    NSString *url = [self buildRequestUrl:request];
    id param = request.requestDictionary;
    
    NSAssert2((url || ![url hasPrefix:@"http"]), @"%@:request url can not be %@!", [self class],url);
    if (param) {
        NSAssert2(request.requestMethod != kRequestMethodGet, @"%@: Parameters will not be used with this requestMethod-(%@)!",[self class], @(request.requestMethod));
    }
    NSLog(@"Request Url: %@ \n Request param: %@",url,param);
    
    if (request.requestSerializerType == DJXRequestSerializerTypeHTTP) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == DJXRequestSerializerTypeJSON) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    // if api build custom url request
    NSURLRequest *customUrlRequest= [request buildCustomUrlRequest];
    if (customUrlRequest) {
        NSURLSessionDataTask * task = [manager dataTaskWithRequest:customUrlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            [self handleSuccessResult:task responseObject:responseObject error:error];
        }];
        request.sessionTask = task;
    } else {
        if(request.requestMethod == kRequestMethodGet) {
            request.sessionTask = [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                //
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleSuccessResult:task responseObject:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleSuccessResult:task responseObject:nil error:error];
            }];
            
        }else if (request.requestMethod == kRequestMethodPost) {
            AFConstructingBlock constructingBlock = [request constructingBodyBlock];
            if (constructingBlock) {
                request.sessionTask = [manager POST:url parameters:param constructingBodyWithBlock:constructingBlock progress:^(NSProgress * _Nonnull uploadProgress) {
                    //
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleSuccessResult:task responseObject:responseObject error:nil];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleSuccessResult:task responseObject:nil error:error];
                }];
            }else{
                request.sessionTask = [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
                    //
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleSuccessResult:task responseObject:responseObject error:nil];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleSuccessResult:task responseObject:nil error:error];
                }];
            }
        }else if (request.requestMethod == kRequestMethodHead) {
                request.sessionTask = [manager HEAD:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task) {
                    [self handleSuccessResult:task responseObject:nil error:nil];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleSuccessResult:task responseObject:nil error:error];
                }];
        }else if (request.requestMethod == kRequestMethodPut) {
                request.sessionTask = [manager PUT:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleSuccessResult:task responseObject:responseObject error:nil];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleSuccessResult:task responseObject:nil error:error];
                }];
        }else if (request.requestMethod == kRequestMethodDelete) {
                request.sessionTask = [manager DELETE:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleSuccessResult:task responseObject:responseObject error:nil];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleSuccessResult:task responseObject:nil error:error];
                }];
        }else {
            NSLog(@"Error, unsupport method type");
            return;
        }
    }
    
    [self addOperation:request];
}
#pragma mark - ResultMethod
/*请求结果的处理*/
- (void)handleSuccessResult:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error{
    NSString *key = [self requestHashKey:task];
    DJXBasicRequest *request = _requestDictionary[key];
    if (request) {
        NSLog(@"Finished Request: %@", request.requestUrl);
        BOOL succeed = [self checkResult:request];
        BOOL finished;
        
        if (succeed && !error) {
            NSLog(@"request success!");
            //    [request toggleAccessoriesWillStopCallBack];
            /*
             *可以返回到request类进行相关操作
             */
            [request requestCompleteFilter];
            if (request && [request respondsToSelector:@selector(requestSuccess:)]) {
                finished = [request requestSuccess:responseObject];
            }
            //    [request toggleAccessoriesWillStopCallBack];
        } else {
            NSLog(@"request fail");
            //   [request toggleAccessoriesWillStopCallBack];
            /*
             *可以返回到request类进行相关操作
             */
            [request requestFailedFilter];
            if (request && [request respondsToSelector:@selector(requestFailed:)]) {
                finished = [request requestFailed:error];
            }
            //   [request toggleAccessoriesDidStopCallBack];
        }
        if (finished) {
//            [self removeOperation:request];
            [self hideLoadView:self.view animated:YES];
            [request clearCompletionBlock];
        }
        
    }else{
        NSLog(@"Can not find Request in cache");
    }
    
}

- (NSString *)requestHashKey:(NSURLSessionTask *)sessionTask {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[sessionTask hash]];
    return key;
}
- (BOOL)checkResult:(DJXBasicRequest *)request {
    BOOL result = [request statusCodeValidator];
    if (!result) {
        return result;
    }
    id validator = [request jsonValidator];
    if (validator != nil) {
        //id json = [request responseJSONObject];
        //        result = [YTKNetworkPrivate checkJson:json withValidator:validator];
    }
//    id json = [request responseJSONObject];
//    if (json)
//        result = [NSJSONSerialization isValidJSONObject:json];
    return result;
}
- (void)showLoadView:(UIView *)view loadText:(NSString *)text animated:(BOOL)animated{
    if (animated) {
        requestManager.showLoadView = animated;

        if (!requestManager.view) {
            requestManager.view = view ? view:({
                (UIView*)[[[UIApplication sharedApplication]delegate]window];
            });
            if (![MBProgressHUD HUDForView:requestManager.view]) {
                requestManager.loadText = text;
                MBProgressHUD * hud =  [MBProgressHUD showHUDAddedTo:requestManager.view animated:YES];
                hud.labelText = JXLocalizedString(requestManager.loadText);
            }
        }
    }
}
- (void)hideLoadView:(UIView *)view animated:(BOOL)animated{
    if (!requestManager.requestDictionary.count) {
        if (view && [MBProgressHUD HUDForView:view]) {
            [MBProgressHUD hideAllHUDsForView:view animated:YES];
            requestManager.view = nil;
            requestManager.loadText = nil;
        }
    }
}
- (void)hideAllLoadView:(UIView *)view animated:(BOOL)animated{
    if (view && [MBProgressHUD HUDForView:view]) {
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
        requestManager.view = nil;
        requestManager.loadText = nil;
    }
}
@end
