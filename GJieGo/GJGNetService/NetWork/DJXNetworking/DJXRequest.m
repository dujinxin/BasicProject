//
//  DJXRequest.m
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "DJXRequest.h"
#import <CommonCrypto/CommonDigest.h>


@interface DJXRequest()

@property (strong, nonatomic) id cacheJson;

@end

@implementation DJXRequest {
    BOOL _dataFromCache;
}

- (BOOL)useCache{
    return NO;
}
- (NSInteger)cacheTimeInSeconds {
    return -1;
}

- (long long)cacheVersion {
    return 0;
}

- (id)cacheSensitiveData {
    return nil;
}

- (void)checkDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}

- (void)createBaseDirectoryAtPath:(NSString *)path {
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                               attributes:nil error:&error];
    if (error) {
        NSLog(@"create cache directory failed, error = %@", error);
    } else {//......
        [self addDoNotBackupAttribute:path];
    }
}

- (NSString *)cacheBasePath {
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"LazyRequestCache"];
    //清除缓存用。。。
    //    [DJXFileManager defaultManager ].folderPath = path;
    
    
    // filter cache base path
    //    NSArray *filters = [[YTKNetworkConfig sharedInstance] cacheDirPathFilters];
    //    if (filters.count > 0) {
    //        for (id<YTKCacheDirPathFilterProtocol> f in filters) {
    //            path = [f filterCacheDirPath:path withRequest:self];
    //        }
    //    }
    
    [self checkDirectory:path];
    return path;
}
#pragma mark - cache file name
- (NSString *)cacheFileName {
    NSString *requestUrl = self.requestUrl;
    id  param = self.requestDictionary;
    
    NSString * requestInfo = [NSString stringWithFormat:@"url:%@ param:%@",requestUrl,param];
    NSLog(@"requestInfo:%@",requestInfo);
    NSString *cacheFileName = [self md5StringFromString:requestInfo];
    return cacheFileName;
}
#pragma mark - cache file path
- (NSString *)cacheFilePath {
    NSString *cacheFileName = [self cacheFileName];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheFileName];
    return path;
}
#pragma mark - cache time
- (int)cacheFileDuration:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // get file attribute
    NSError *attributesRetrievalError = nil;
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path
                                                             error:&attributesRetrievalError];
    if (!attributes) {
        NSLog(@"Error get attributes for file at %@: %@", path, attributesRetrievalError);
        return -1;
    }
    NSLog(@"fileDictionary:%@",attributes);
    int seconds = -[[attributes fileModificationDate] timeIntervalSinceNow];
    return seconds;
}
#pragma mark - CacheVersion
- (NSString *)cacheVersionFilePath {
    NSString *cacheVersionFileName = [NSString stringWithFormat:@"%@.version", [self cacheFileName]];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheVersionFileName];
    return path;
}

- (long long)cacheVersionFileContent {
    NSString *path = [self cacheVersionFilePath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
        NSNumber *version = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        return [version longLongValue];
    } else {
        return 0;
    }
}
- (BOOL)isCacheVersionExpired {
    // check cache version
    long long cacheVersionFileContent = [self cacheVersionFileContent];
    if (cacheVersionFileContent != [self cacheVersion]) {
        return YES;
    } else {
        return NO;
    }
}
#pragma mark - Request
- (void)startAsynchronous{
    if ( ![self useCache]) {
        [super startAsynchronous];
        return;
    }
    // check cache version
    long long cacheVersionFileContent = [self cacheVersionFileContent];
    if (cacheVersionFileContent != [self cacheVersion]) {
        [super startAsynchronous];
        return;
    }
    
    // check cache time
    if ([self cacheTimeInSeconds] <= 0) {
        [super startAsynchronous];
        return;
    }
    
    // check cache existance
    NSString *path = [self cacheFilePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path isDirectory:nil]) {
        [super startAsynchronous];
        return;
    }
    
    // check cache time
    NSInteger seconds = [self cacheFileDuration:path];
    if (seconds < 0) {
        [super startAsynchronous];
        return;
    }
    if (seconds > [self cacheTimeInSeconds]) {
        NSLog(@"Cache file overtime:%ld seconds",seconds - (long)[self cacheTimeInSeconds]);
        NSError * error = nil;
        //        [fileManager removeItemAtPath:path error:&error];
        //        [fileManager removeItemAtPath:pathVersion error:&error];
        if (error) {
            NSLog(@"Remove cache file error: %@",error.description);
        }
        [super startAsynchronous];
        return;
    }
    
    // load cache
    _cacheJson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (_cacheJson == nil) {
        [super startAsynchronous];
        return;
    }
    
    _dataFromCache = YES;
    [self requestCompleteFilter];
    DJXRequest *strongSelf = self;
    [strongSelf requestSuccess:strongSelf.responseJSONObject];
    //    if (strongSelf.success) {
    //        strongSelf.success(strongSelf);
    //    }
    [strongSelf clearCompletionBlock];
}

- (void)startWithoutCache {
    [super startAsynchronous];
}

- (id)cacheJson {
    if (_cacheJson) {
        return _cacheJson;
    } else {
        NSString *path = [self cacheFilePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path isDirectory:nil] == YES) {
            _cacheJson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        }
        return _cacheJson;
    }
}

- (BOOL)isDataFromCache {
    return _dataFromCache;
}

#pragma mark - Network Request Delegate

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if ([self useCache]) {
        [self saveJsonResponseToCacheFile:[super responseJSONObject]];
    }
}
- (id)responseJSONObject {
    if (_cacheJson) {
        return _cacheJson;
    } else {
        return [super responseJSONObject];
    }
}
// 手动将其他请求的JsonResponse写入该请求的缓存
// 比如AddNoteApi, UpdateNoteApi都会获得Note，且其与GetNoteApi共享缓存，可以通过这个接口写入GetNoteApi缓存
- (void)saveJsonResponseToCacheFile:(id)jsonResponse {
    if ([self cacheTimeInSeconds] > 0 && ![self isDataFromCache]) {
        NSDictionary *json = jsonResponse;
        if (json != nil) {
            [NSKeyedArchiver archiveRootObject:json toFile:[self cacheFilePath]];
            //            [NSKeyedArchiver archiveRootObject:@([self cacheVersion]) toFile:[self cacheVersionFilePath]];
        }
    }
}

#pragma mark - Other

- (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        NSLog(@"error to set do not backup attribute, error = %@", error);
    }
}

- (NSString *)md5StringFromString:(NSString *)string {
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
- (NSString *)baseUrl{
    return kHostUrl;
}
-(BOOL)isUseFormat{
    return YES;
}
-(DJXRequestMethod)requestMethod{
    return kRequestMethodPost;
}
-(NSSet *)acceptableContentTypes{
    return [NSSet setWithObject:@"text/html"];
}

- (BOOL)requestFailed:(id)responseData{
    
    BOOL isFailed = [super requestFailed:responseData];
    if (isFailed) {
        if ([self isUseFormat]) {
            isFailed = [self handleResultData:responseData];
        }
    }
    return isFailed;
}

- (BOOL)requestSuccess:(id)responseData{
    BOOL isSuccess = [super requestSuccess:responseData];
    if (isSuccess) {
        NSError * error = nil;
        BOOL isResult = YES;
        id result = [NSJSONSerialization JSONObjectWithData:responseData  options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            NSLog(@"Data analyzing error!");
            isResult = [self handleResultData:error];
        }else{
            if (_dataFromCache){
                NSLog(@"Data from cache path:%@\n%@",[self cacheFilePath],[self requestUrl]);
            } else{
                NSLog(@"Data from url:%@",[self requestUrl]);
            }
            NSLog(@"%@",@{
                           @"requestUrl":self.requestUrl,
                           @"requestParam":self.requestDictionary?self.requestDictionary:@"null",
                           @"responseData":result});
            if ([self isUseFormat]) {
                //返回YES则在model里单独处理数据，返回NO则统一处理
                isResult = [self handleResultData:result];
                return isResult;
            }else{
                return isResult;
            }
        }
        
    }else{
        return NO;
    }
    return YES;
}

- (BOOL)handleResultData:(id)result{
    
    BOOL isSuccess = YES;
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = (NSDictionary *)result;
        kResponseStatus status = (kResponseStatus)[[dict objectForKey:@"status"] integerValue];
        NSString * message = [dict objectForKey:@"message"];

        id data;
        switch (status) {
            case kResponseSuccess:
            {
                if ([dict objectForKey:@"data"]) {//公共返回字段，有大写有小写
                    data = [dict objectForKey:@"data"];
                }else if ([dict objectForKey:@"Data"]){
                    data = [dict objectForKey:@"Data"];
                }
                if ([data isKindOfClass:[NSNull class]]){
                    data = nil;
                }
                [self responseResult:data message:message isSuccess:isSuccess];
            }
                break;
            case kResponseFailed:
            {
                isSuccess = NO;
                [self responseResult:data message:message isSuccess:isSuccess];
            }
                break;
            case kResponseShortTokenDisabled://token失效
            {
                [[UserRequest shareManager] userLongToken:kApiUserLongToken param:@{@"RToken":[[UserDBManager shareManager] getRefreshToken]} success:^(id object,NSString *msg) {
                    //重发
                    [[DJXRequestManager sharedInstance] addRequests];
                } failure:^(id object,NSString *msg) {
                    //
                }];
                isSuccess = NO;
                return NO;
            }
                break;
            case kResponseLongTokenDisabled://RefreshToken失效，（已登录）用户退出
            {
                //取消refreshToken request
                [[DJXRequestManager sharedInstance] cancelRequest:self];
                AppDelegate * appDelegate = [AppDelegate appDelegate];
                
                if ([[EMClient sharedClient]isLoggedIn]) {
                    EMError *error = [[EMClient sharedClient] logout:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error != nil) {
                            NSLog(@"");
                        }else{
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginInfomationUnavailble", "Your login information is out of date,please log in again") delegate:appDelegate cancelButtonTitle:NSLocalizedString(@"ok", @"OK")  otherButtonTitles:nil, nil];
                            alertView.tag = 3001;
                            [alertView show];
                        }
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginInfomationUnavailble", "Your login information is out of date,please log in again") delegate:appDelegate cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                        alertView.tag = 3001;
                        [alertView show];
                    });
                }
                

                isSuccess = NO;
            }
                break;
                
            default:{
                isSuccess = NO;
                [self responseResult:data message:message isSuccess:isSuccess];
            }
                break;
        }
        
    }else if ([result isKindOfClass:[NSArray class]]){
        NSArray * array = (NSArray *)result;
        for (id object in array) {
            //NSString * message = [dict objectForKey:@"message"];
            //NSLog(@"%@",message);
            if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
            }
        }
    }else if ([result isKindOfClass:[NSString class]]){
        NSString * errorStr = (NSString *)result;
        [self responseResult:nil message:errorStr isSuccess:NO];
    }else if ([result isKindOfClass:[NSError class]]){
        isSuccess = NO;
        NSString * errorStr;
        NSError * error = (NSError *)result;
        kResponseStatus status = (kResponseStatus)error.code;
        switch (status) {
            case kRequestErrorCannotConnectToHost:
            case kRequestErrorCannotFindHost:
            case kRequestErrorNotConnectedToInternet:
            case kRequestErrorNetworkConnectionLost:
            case kRequestErrorUnknown:
                errorStr = kRequestNotConnectedDomain;
                break;
            case kRequestErrorTimedOut:
                errorStr = kRequestTimeOutDomain;
                break;
            case kRequestErrorResourceUnavailable:
                errorStr = kRequestResourceUnavailableDomain;
                break;
            case kResponseDataError:
                errorStr = kRequestResourceDataErrorDomain;
                break;
            default:
                errorStr = error.localizedDescription;
                break;
        }
        NSLog(@"error:%ld  %@  url:%@",(long)error.code,error.localizedDescription,self.requestUrl);
        [self responseResult:nil message:errorStr isSuccess:NO];
    }else{
        isSuccess = NO;
        NSString * errorStr = @"Error with unsupport data format (neither NSDictionary nor NSArray )";
        NSLog(@"%@",errorStr);
        [self responseResult:nil message:errorStr isSuccess:NO];
    }
    return YES;
}
/*
 *子类继承，重写
 */
- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    BOOL isDJXRequst = [NSStringFromClass(self.class) isEqualToString:NSStringFromClass([DJXRequest class])];
    [[DJXRequestManager sharedInstance] removeOperation:self];
    //NSLog(@"request:\n success = %d,\n requestObj = %@,\n object = %@,\n message = %@",isSuccess,[self class],object,message);
    //如果以基类来请求，那么直接在此处理
    if (isDJXRequst) {
        if (isSuccess) {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(responseSuccessObj:tag:)]) {
                if (object) {
                    [self.delegate responseSuccessObj:object tag:self.tag];
                }else{
                    [self.delegate responseSuccessObj:message tag:self.tag];
                }
            }
            if (self.success) {
                self.success(object,message);
            }
        }else{
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(responseFailed:message:)]) {
                [self.delegate responseFailed:self.tag message:message];
            }
            if (self.failure) {
                self.failure(object,message);
            }
        }
    }
}

#pragma mark - custom private
@end
