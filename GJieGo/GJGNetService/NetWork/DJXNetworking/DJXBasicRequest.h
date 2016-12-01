//
//  DJXBasicRequest.h
//  JXView
//
//  Created by dujinxin on 15-3-26.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJXRequestManager.h"
#import "AFNetworking.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#ifndef JX_INSTANCETYPE
#if __has_feature(objc_instancetype)
#define JX_INSTANCETYPE instancetype
#else
#define JX_INSTANCETYPE id
#endif
#endif


@protocol DJXRequestAccessory <NSObject>

@optional

- (void)requestWillStart:(id)request;
- (void)requestWillStop:(id)request;
- (void)requestDidStop:(id)request;

@end

@class DJXBasicRequest;
@protocol DJXRequestDelegate <NSObject>

@optional

-(void)responseSuccessObj:(id)responseObj tag:(JX_APITAG)tag;
-(void)responseSuccessStr:(NSString *)responseStr tag:(JX_APITAG)tag;
-(void)responseSuccessArr:(NSArray *)responseArr tag:(JX_APITAG)tag;
-(void)responseSuccessDict:(NSDictionary *)responseDict tag:(JX_APITAG)tag;

-(void)responseSuccessObj:(id)responseObj message:(NSString *)msg tag:(JX_APITAG)tag;

-(void)responseFailed:(JX_APITAG)tag message:(NSString*)errMsg;
-(void)responseFailed:(JX_APITAG)tag message:(NSString*)errMsg status:(NSString*)status;
-(void)responseFailed:(JX_APITAG)tag message:(NSString*)errMsg status:(NSString*)status obj:(id)object;
-(void)requestCancel:(JX_APITAG)tag;

-(void)setProgress:(float)newProgress;

-(void)clearRequest;

@end

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
typedef void (^requestCompletionBlock)(id object,NSString *msg);
typedef void (^requestBasicCompletionBlock)(id object,NSString *msg,kResponseStatus status,NSString * alertType);

@interface DJXBasicRequest : NSObject<DJXRequestDelegate>


@property (nonatomic, strong) AFHTTPSessionManager *manager;

/*
 *请求信息
 */

@property (nonatomic,   copy) NSString             *   className;
//Tag
@property (nonatomic, assign) NSInteger                tag;
//请求url
@property (nonatomic,   copy) NSString             *   baseUrl;
//请求url
@property (nonatomic,   copy) NSString             *   requestUrl;
//请求参数
@property (nonatomic, strong) NSMutableDictionary  *   requestDictionary;
//需要登录时，用户的信息
@property (nonatomic, strong) NSDictionary         *   userInfo;
//请求类型
@property (nonatomic, assign) DJXRequestMethod         requestMethod;
//请求的SerializerType
@property (nonatomic, assign) DJXRequestSerializerType requestSerializerType;
//请求队列
@property (nonatomic, strong) AFURLSessionManager  * sessionManager;
//请求队列
@property (nonatomic, strong) NSURLSessionTask     * sessionTask;
//请求代理 要用weak,使用assign当起所指的对象消失时，会crash
@property (nonatomic, weak)   id<DJXRequestDelegate>   delegate;
@property (nonatomic, assign) SEL                      action;

@property (nonatomic, strong) UIView                 * view;
@property (nonatomic, assign,getter=isShowLoadView) BOOL  showLoadView;
@property (nonatomic, copy)  NSString                * loadText;


/*
 *返回信息
 */

//返回头信息
@property (nonatomic, strong, readonly) NSDictionary * responseHeaders;
//返回的数据
@property (nonatomic, strong, readonly) NSString     * responseString;
@property (nonatomic, strong)           NSData       * responseData;
@property (nonatomic, strong, readonly) id             responseJSONObject;
//返回状态码
@property (nonatomic, assign, readonly) NSInteger      responseStatusCode;
//请求的回调
@property (nonatomic, copy)requestCompletionBlock      success;
@property (nonatomic, copy)requestCompletionBlock      failure;

//
@property (nonatomic, assign) BOOL                     isUseBasicBlock;
@property (nonatomic, copy)requestBasicCompletionBlock basicSuccess;
@property (nonatomic, copy)requestBasicCompletionBlock basicFailure;

@property (nonatomic, strong) AFNetworkReachabilityManager * reachbilityManager;

@property (nonatomic, strong) NSMutableArray         * requestAccessories;

+ (NSString *)className;
//init
- (JX_INSTANCETYPE)initWithDelegate:(id)vc nApiTag:(DJXApiTag)tag;
- (JX_INSTANCETYPE)initWithTarget:(id)vc action:(SEL)selector;
- (JX_INSTANCETYPE)initWithBlock:(requestCompletionBlock)success failure:(requestCompletionBlock)failure;
- (JX_INSTANCETYPE)initWithTarget:(id<DJXRequestDelegate>)vc url:(NSString *)url param:(NSDictionary *)param requestMethod:(DJXRequestMethod)method success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure action:(SEL)action nApiTag:(DJXApiTag)tag showInView:(UIView *)view animated:(BOOL)animated;


- (JX_INSTANCETYPE)initWithBasic:(NSString *)url param:(NSDictionary *)param success:(requestBasicCompletionBlock)success failure:(requestBasicCompletionBlock)failure;

- (BOOL)requestSuccess:(id)responseData;
- (BOOL)requestFailed:(id)responseData;
// append self to request queue
- (void)startAsynchronous;
// remove self from request queue
- (void)stopAsynchronous;

//- (BOOL)isExecuting;

// 把block置nil来打破循环引用
- (void)clearCompletionBlock;


/// 以下方法由子类继承来覆盖默认值

// 请求成功的回调
- (void)requestCompleteFilter;
// 请求失败的回调
- (void)requestFailedFilter;
// 请求的URL
- (NSString *)requestUrl;
// 请求的CdnURL
- (NSString *)cdnUrl;
// 请求的BaseURL
- (NSString *)baseUrl;
// 请求的参数列表
- (id)requestArgument;
//返回数据格式
- (NSSet *)acceptableContentTypes;
// 用于在cache结果，计算cache文件名时，忽略掉一些指定的参数
- (id)cacheFileNameFilterForRequestArgument:(id)argument;

// Http请求的方法
- (DJXRequestMethod)requestMethod;

// 请求的SerializerType
- (DJXRequestSerializerType)requestSerializerType;

// 请求的Server用户名和密码
- (NSArray *)requestAuthorizationHeaderFieldArray;

// 构建自定义的UrlRequest，
// 若这个方法返回非nil对象，会忽略requestUrl, requestArgument, requestMethod, requestSerializerType
- (NSURLRequest *)buildCustomUrlRequest;

// 是否使用CDN的host地址
- (BOOL)useCDN;

// 用于检查JSON是否合法的对象
- (id)jsonValidator;

// 用于检查Status Code是否正常的方法
- (BOOL)statusCodeValidator;

// 当POST的内容带有文件等富文本时使用(上传图片，文件，声音...)
- (AFConstructingBlock)constructingBodyBlock;

//// 当需要断点续传时，指定续传的地址
//- (NSString *)resumableDownloadPath;

// 当需要断点续传时，获得下载进度的回调
//- (AFDownloadProgressBlock)resumableDownloadProgressBlock;

#pragma mark --------------------- RequestMethods
/*简便请求*/
//子类调用
#pragma mark - requestWithDelegate
//request
+ (void)requestWithDelegate:(id)vc nApiTag:(DJXApiTag)tag;
+ (void)requestWithDelegate:(id)vc nApiTag:(DJXApiTag)tag url:(NSString *)url param:(NSDictionary *)param;
+ (void)requestWithDelegate:(id)vc nApiTag:(DJXApiTag)tag url:(NSString *)url param:(NSDictionary *)param animated:(BOOL)animated;
#pragma mark - requestWithTarget
+ (void)requestWithTarget:(id)vc action:(SEL)selector;
+ (void)requestWithTarget:(id)vc action:(SEL)selector url:(NSString *)url param:(NSDictionary *)param;
+ (void)requestWithTarget:(id)vc action:(SEL)selector url:(NSString *)url param:(NSDictionary *)param animated:(BOOL)animated;
#pragma mark - requestWithBlock
+ (void)requestWithBlock:(requestCompletionBlock)success failure:(requestCompletionBlock)failure;
+ (void)requestWithBlock:(NSString *)url param:(NSDictionary *)param success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure;
+ (void)requestWithBlock:(NSString *)url param:(NSDictionary *)param success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure animated:(BOOL)animated;
+ (void)requestWithBlock:(NSString *)url param:(NSDictionary *)param success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure showInView:(UIView *)view animated:(BOOL)animated loadText:(NSString *)text;


+ (void)requestWithBasicBlock:(NSString *)url param:(NSDictionary *)param success:(requestBasicCompletionBlock)success failure:(requestBasicCompletionBlock)failure;
@end
