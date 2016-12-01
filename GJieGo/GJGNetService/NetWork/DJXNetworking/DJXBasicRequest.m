//
//  DJXBasicRequest.m
//  JXView
//
//  Created by dujinxin on 15-3-26.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXBasicRequest.h"



@implementation DJXBasicRequest
@synthesize tag = _tag;
@synthesize delegate = _delegate;
@synthesize requestDictionary = _requestDictionary;
@synthesize manager = _manager;
@synthesize requestUrl = _requestUrl;


#pragma mark - initMethods
-(JX_INSTANCETYPE)init{
    self = [super init];
    if (self) {
        //
    }
    return self;
}
- (JX_INSTANCETYPE)initWithDelegate:(id)vc nApiTag:(JX_APITAG)tag{
    return [self initWithDelegate:vc action:nil success:nil failure:nil nApiTag:tag];
}
- (JX_INSTANCETYPE)initWithTarget:(id)vc action:(SEL)selector{
    return [self initWithDelegate:vc action:selector success:nil failure:nil nApiTag:-1];
}
- (JX_INSTANCETYPE)initWithBlock:(requestCompletionBlock)success failure:(requestCompletionBlock)failure{
    return [self initWithDelegate:nil action:nil success:success failure:failure nApiTag:-1];
}

- (JX_INSTANCETYPE)initWithDelegate:(id)vc action:(SEL)selector success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure nApiTag:(JX_APITAG)tag{
    self = [super init];
    if (self) {
        if (vc)
            self.delegate = vc;
        if (selector)
            self.action = selector;
        if (success)
            self.success = [success copy];
        if (failure)
            self.failure = [failure copy];
        if (tag >=0) {
            self.tag = tag;
        }
    }
    return self;
}
- (JX_INSTANCETYPE)initWithTarget:(id<DJXRequestDelegate>)vc url:(NSString *)url param:(NSDictionary *)param requestMethod:(DJXRequestMethod)method success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure action:(SEL)action nApiTag:(DJXApiTag)tag showInView:(UIView *)view animated:(BOOL)animated loadText:(NSString *)text{
    self = [super init];
    if (self) {
        if (vc){
            self.delegate = vc;
            UIViewController * viewController = (UIViewController *)vc;
            self.view = viewController.view;
        }
        if (action)
            self.action = action;
        if (success)
            self.success = [success copy];
        if (failure)
            self.failure = [failure copy];
        if (param) {
            self.requestDictionary = [NSMutableDictionary dictionaryWithDictionary:param];
        }else{
            self.requestDictionary = [self requestDictionary];
        }
        if ([self requestUrl]) {
            self.requestUrl = [self requestUrl];
        }else{
            self.requestUrl = url;
        }
        if (tag >=0) {
            self.tag = tag;
        }
        if (method) {
            self.requestMethod = method;
        }else{
            self.requestMethod = [self requestMethod];
        }
        self.showLoadView = animated;
        if (view) {
            self.view = view;
        }
        if (text) {
            self.loadText = text;
        }
        
        _reachbilityManager = [AFNetworkReachabilityManager sharedManager];
        [_reachbilityManager startMonitoring];
    }
    return self;
}

- (JX_INSTANCETYPE)initWithBasic:(NSString *)url param:(NSDictionary *)param success:(requestBasicCompletionBlock)success failure:(requestBasicCompletionBlock)failure{
    self = [super init];
    if (self) {
        if (success)
            self.success = [success copy];
        if (failure)
            self.failure = [failure copy];
        if (param) {
            self.requestDictionary = [NSMutableDictionary dictionaryWithDictionary:param];
        }else{
            self.requestDictionary = [self requestDictionary];
        }
        if ([self requestUrl]) {
            self.requestUrl = [self requestUrl];
        }else{
            self.requestUrl = url;
        }

        self.requestMethod = [self requestMethod];

    }
    return self;
}
#pragma mark - RequestMethods
/*简便请求*/
#pragma mark -
+ (void)requestWithDelegate:(id)vc nApiTag:(DJXApiTag)tag{
    [self requestWithDelegate:vc nApiTag:tag url:nil param:nil];
}
+ (void)requestWithDelegate:(id)vc nApiTag:(DJXApiTag)tag url:(NSString *)url param:(NSDictionary *)param{
    [self requestWithDelegate:vc nApiTag:tag url:url param:param animated:NO];
}
+ (void)requestWithDelegate:(id)vc nApiTag:(DJXApiTag)tag url:(NSString *)url param:(NSDictionary *)param animated:(BOOL)animated{
    DJXRequestMethod method = kRequestMethodGet;
    if(param)
        method = kRequestMethodPost;
    [self requestWithTarget:vc url:url param:param requestMethod:method success:nil failure:nil action:nil nApiTag:tag showInView:nil animated:NO loadText:nil];
}
#pragma mark -
+ (void)requestWithTarget:(id)vc action:(SEL)selector{
    [self requestWithTarget:vc action:selector url:nil param:nil];
}
+ (void)requestWithTarget:(id)vc action:(SEL)selector url:(NSString *)url param:(NSDictionary *)param{
    [self requestWithTarget:vc action:selector url:url param:param animated:NO];
}
+ (void)requestWithTarget:(id)vc action:(SEL)selector url:(NSString *)url param:(NSDictionary *)param animated:(BOOL)animated{
    DJXRequestMethod method = kRequestMethodGet;
    if(param)
        method = kRequestMethodPost;
    [self requestWithTarget:vc url:url param:param requestMethod:method success:nil failure:nil action:selector nApiTag:-1 showInView:nil animated:NO loadText:nil];
}
#pragma mark -
+ (void)requestWithBlock:(requestCompletionBlock)success failure:(requestCompletionBlock)failure{
    [self requestWithBlock:nil param:nil success:success failure:failure];
}
+ (void)requestWithBlock:(NSString *)url param:(NSDictionary *)param success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure{
    [self requestWithBlock:url param:param success:success failure:failure showInView:nil animated:NO loadText:nil];
}
+ (void)requestWithBlock:(NSString *)url param:(NSDictionary *)param success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure animated:(BOOL)animated{
    [self requestWithBlock:url param:param success:success failure:failure showInView:nil animated:animated loadText:nil];
}
+ (void)requestWithBlock:(NSString *)url param:(NSDictionary *)param success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure showInView:(UIView *)view animated:(BOOL)animated loadText:(NSString *)text{
    DJXRequestMethod method = kRequestMethodGet;
    
    if(param)
        method = kRequestMethodPost;
    [self requestWithTarget:nil url:url param:param requestMethod:kRequestMethodPost success:success failure:failure action:nil nApiTag:-1 showInView:view animated:animated loadText:text];
}
+ (void)requestWithBasicBlock:(NSString *)url param:(NSDictionary *)param success:(requestBasicCompletionBlock)success failure:(requestBasicCompletionBlock)failure{
    DJXBasicRequest * request = [[self alloc] initWithBasic:url param:param success:success failure:failure];
    [request startAsynchronous];
}
#pragma mark -
+ (void)requestWithTarget:(id<DJXRequestDelegate>)vc url:(NSString *)url param:(NSDictionary *)param requestMethod:(DJXRequestMethod)method success:(requestCompletionBlock)success failure:(requestCompletionBlock)failure action:(SEL)action nApiTag:(DJXApiTag)tag showInView:(UIView *)view animated:(BOOL)animated loadText:(NSString *)text{
    
    DJXBasicRequest * request = [[self alloc] initWithTarget:vc url:url param:param requestMethod:method success:success failure:failure action:action nApiTag:tag showInView:view animated:animated loadText:text];
    
    [request startAsynchronous];
}
#pragma mark -
/*请求*/
- (void)startAsynchronous {
    [[DJXRequestManager sharedInstance] addRequest:self];
}
/*结束*/
- (void)stopAsynchronous{
    [[DJXRequestManager sharedInstance] cancelRequest:self];
}
// for subclasses to overwrite
#pragma mark - subClass need to overwrite
- (void)requestCompleteFilter {}
- (void)requestFailedFilter {}
- (BOOL)requestFailed:(id)responseData{
    return YES;
}
- (BOOL)requestSuccess:(id)responseData{
    return YES;
}
#pragma mark -

//- (NSString *)requestUrl {
//    return @"";
//}
- (NSString *)cdnUrl {
    return @"";
}
- (NSString *)baseUrl {
    return @"";
}
- (id)requestArgument {
    return nil;
}
- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    return argument;
}
- (DJXRequestMethod)requestMethod {
    return kRequestMethodGet;
}
- (NSSet *)acceptableContentTypes{
    return [NSSet setWithObject:@"application/json"];
}
- (DJXRequestSerializerType)requestSerializerType {
    return DJXRequestSerializerTypeHTTP;
}
- (NSArray *)requestAuthorizationHeaderFieldArray {
    return nil;
}
- (NSURLRequest *)buildCustomUrlRequest{
    return nil;
}
-(AFConstructingBlock)constructingBodyBlock{
    return nil;
}
- (BOOL)useCDN {
    return NO;
}
- (id)jsonValidator {
    return nil;
}

- (NSInteger)sessionTaskState {
    return self.sessionTask.state;
}
- (NSDictionary *)responseHeaders {
    NSHTTPURLResponse * response = (NSHTTPURLResponse *)self.sessionTask.response;
    return response.allHeaderFields;
}
- (NSInteger)responseStatusCode {
    NSHTTPURLResponse * response = (NSHTTPURLResponse *)self.sessionTask.response;
    return response.statusCode;
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode >= 200 && statusCode <=299) {
        return YES;
    } else {
        return NO;
    }
    return YES;
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.success = nil;
    self.failure = nil;
}

#pragma mark -
+ (NSString *)className{
    return NSStringFromClass(self.class);
}

#pragma mark -- description
- (NSString *)description {
    id requestParam;
    if (self.requestDictionary) {
        requestParam = self.requestDictionary;
    }else{
        requestParam = @"null";
    }
    
    return [NSString stringWithFormat:@"<%@: %p>\n properties:%@", NSStringFromClass([self class]), self,@{
            @"requestMethod":@(self.requestMethod)?@(self.requestMethod):@"null",
            @"apiTag":@(self.tag)?@(self.tag):@"null",
            @"delegate":self.delegate?self.delegate:(id)@"null",
            @"requestUrl":self.requestUrl?self.requestUrl:@"null",
            @"requestDictionary":requestParam
            }];
}
- (NSString *)debugDescription{
    id requestParam;
    if (self.requestDictionary) {
        requestParam = self.requestDictionary;
    }else{
        requestParam = @"null";
    }
    return [NSString stringWithFormat:@"<%@: %p>\n properties:%@", NSStringFromClass([self class]), self,@{
             @"requestMethod":@(self.requestMethod),
             @"apiTag":@(self.tag),
             @"delegate":self.delegate,
             @"requestUrl":self.requestUrl,
             @"requestDictionary":requestParam
             }];
}
@end
