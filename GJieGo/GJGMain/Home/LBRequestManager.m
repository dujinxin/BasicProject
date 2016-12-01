//
//  LBRequestManager.m
//  GJieGo
//
//  Created by liubei on 16/7/1.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBRequestManager.h"
#import "DJXRequest.h"
@class GJGShareInfo;

@interface LBRequestManager ()

@property (nonatomic, strong) AFNetWorkRequest__ *request;

@end

@implementation LBRequestManager

static LBRequestManager *_instance;

+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
        _instance.request = [[AFNetWorkRequest__ alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [super allocWithZone:zone];
        
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    
    return _instance;
}

- (void)getSharedInfoWithInfoId:(NSInteger)infoId infoType:(GJGShareInfoType)type result:(ResultBlock)resBlock {
    
    if (infoId < 1 || type < 1) {
        resBlock(nil,[NSError errorWithDomain:@"lb_get_ShareInfo_fail, infoId or type is wrong!" code:1 userInfo:nil]);
        return;
    }
    
    [DJXRequest requestWithBlock:kApiGetShareInfo
                           param:@{@"infoId" : [NSNumber numberWithInteger:infoId],
                                   @"infoType" : [NSNumber numberWithInteger:type]}
                         success:^(id object,NSString *msg)
    {
        if ([object isKindOfClass:[NSDictionary class]]) {
            GJGShareInfo *shareInfo = [GJGShareInfo modelWithDict:object];
            resBlock(shareInfo, nil);
        }
    } failure:^(id object,NSString *msg) {
        if ([msg isKindOfClass:[NSString class]]) {
            [MBProgressHUD showError:object toView:[UIApplication sharedApplication].keyWindow];
        }
        resBlock(nil, [NSError errorWithDomain:@"lb_get_ShareInfo_fail" code:2 userInfo:nil]);
    }];
    
//    [self.request requestUrl:kGJGRequestUrl(kApiGetShareInfo)
//                 requestType:RequestGetType
//                  parameters:@{@"infoId" : [NSNumber numberWithInteger:infoId],
//                               @"infoType" : [NSNumber numberWithInteger:type]}
//                requestblock:^(id responseobject, NSError *error)
//    {
//        if (!error) {
//            if ([[responseobject objectForKey:@"status"] isEqualToNumber:@0]) {
//                NSLog(@"lb_get_ShareInfo_success:%@",responseobject);
//                if ([[responseobject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
//                    GJGShareInfo *shareInfo = [GJGShareInfo modelWithDict:[responseobject objectForKey:@"data"]];
//                    resBlock(shareInfo, nil);
//                }
//            }else {
//                [MBProgressHUD showError:[responseobject objectForKey:@"message"]
//                                  toView:[UIApplication sharedApplication].keyWindow];
//            }
//        }else {
//            NSLog(@"lb_get_ShareInfo_fail:%@", error);
//            resBlock(nil, [NSError errorWithDomain:@"lb_get_ShareInfo_fail" code:2 userInfo:nil]);
//        }
//    }];
}

@end


@implementation GJGShareInfo

@end
