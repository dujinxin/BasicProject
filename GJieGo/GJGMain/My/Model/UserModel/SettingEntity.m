//
//  SettingEntity.m
//  GJieGo
//
//  Created by dujinxin on 16/6/21.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "SettingEntity.h"

@implementation SettingEntity

@end

@implementation SettingObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray * array = (NSArray *)object;
                NSMutableArray * dataArray = [NSMutableArray array];
                for (NSDictionary * dict in array) {
                    SettingEntity * entity = [SettingEntity mj_objectWithKeyValues:dict];
                    [dataArray addObject:entity];
                }
                self.success(dataArray,message);
            }
        }
    }else{
        if (self.failure) {
            self.failure(object,message);
        }
    }
};

@end

@implementation NormalFAQEntity

@end

@implementation NormalFAQObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray * array = (NSArray *)object;
                NSMutableArray * dataArray = [NSMutableArray array];
                for (NSDictionary * dict in array) {
                    NormalFAQEntity * entity = [NormalFAQEntity mj_objectWithKeyValues:dict];
                    [dataArray addObject:entity];
                }
                self.success(dataArray,message);
            }
        }
    }else{
        if (self.failure) {
            self.failure(object,message);
        }
    }
};

@end
