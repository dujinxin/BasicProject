
//
//  DJXApiError.h
//  FJ_Project
//
//  Created by dujinxin on 15/10/21.
//  Copyright © 2015年 BLW. All rights reserved.
//

#ifndef DJXApiError_h
#define DJXApiError_h


typedef enum {
    kResponseSuccess  = 0,        /*请求成功*/
    kResponseFailed    ,          /*请求失败*/
    kResponseShortTokenDisabled = 3,  /*短token失效*/
    kResponseLongTokenDisabled  = 4,  /*长token失效*/
    
    
    kResponseDataError = 3840,    /*数据有误*/
    
    // Error codes for CFURLConnection and CFURLProtocol
    kRequestErrorUnknown = -998,                                  /*请求超时*/
    kRequestErrorCancelled = -999,
    kRequestErrorBadURL = -1000,
    kRequestErrorTimedOut = -1001,                                /*请求超时*/
    kRequestErrorUnsupportedURL = -1002,
    kRequestErrorCannotFindHost = -1003,                          /*未能找到服务器*/
    kRequestErrorCannotConnectToHost = -1004,                     /*未能连接到服务器*/
    kRequestErrorNetworkConnectionLost = -1005,
    kRequestErrorDNSLookupFailed = -1006,
    kRequestErrorHTTPTooManyRedirects = -1007,
    kRequestErrorResourceUnavailable = -1008,
    kRequestErrorNotConnectedToInternet = -1009,                  /*网络连接断开*/
    
    
}kResponseStatus;

static NSString * kRequestTimeOutDomain =      @"网络请求超时";
static NSString * kRequestNetworkLostDomain  = @"网络连接断开";
static NSString * kRequestNotConnectedDomain = @"网络连接异常";
static NSString * kRequestResourceUnavailableDomain  = @"网络数据异常";
static NSString * kRequestResourceDataErrorDomain = @"HT数据异常";



#endif /* DJXApiError_h */
