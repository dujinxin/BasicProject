//
//  DJXRequestManager.h
//  JXView
//
//  Created by dujinxin on 15-3-26.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "DJXApiTag.h"
#import "DJXApiError.h"


#ifndef DJXApiTag_h
#define DJXApiTag_h

#endif

#ifndef JX_APITAG
#ifdef DJXApiTag_h
#define JX_APITAG DJXApiTag
#else
#define JX_APITAG NSInteger
#endif
#endif


typedef enum{
    kRequestMethodGet = 0,
    kRequestMethodPost,
    kRequestMethodHead,
    kRequestMethodPut,
    kRequestMethodDelete,
}DJXRequestMethod;

typedef enum {
    DJXRequestSerializerTypeHTTP = 0,
    DJXRequestSerializerTypeJSON,
}DJXRequestSerializerType;


@class DJXBasicRequest;

@protocol DJXRequestManagerDelegate <NSObject>

@optional

-(void)requestSuccess:(DJXBasicRequest *)request;
-(void)requestFailed:(DJXBasicRequest *)request;

@end

@class DJXRequestDelegate;

@interface DJXRequestManager : NSObject<DJXRequestManagerDelegate>

@property (nonatomic, strong) NSMutableDictionary       * requestDictionary;

@property (nonatomic, strong) UIView                    * view;
@property (nonatomic, assign,getter=isShowLoadView) BOOL  showLoadView;
@property (nonatomic, copy)  NSString                   * loadText;

@property (nonatomic, strong) AFNetworkReachabilityManager * reachbilityManager;

+ (DJXRequestManager *)sharedInstance;

- (void)addRequest:(DJXBasicRequest *)request;
- (void)addRequests;

- (void)cancelRequest:(DJXBasicRequest *)request;
- (void)cancelRequests;
- (void)cancelRequestByViewController:(id)vc;

- (void)addOperation:(DJXBasicRequest *)request;
- (void)removeOperation:(DJXBasicRequest *)request;

- (NSString *)requestHashKey:(NSURLSessionTask *)sessionTask;

- (void)showLoadView:(UIView *)view animated:(BOOL)animated;
- (void)hideLoadView:(UIView *)view animated:(BOOL)animated;


#pragma mark

@end
