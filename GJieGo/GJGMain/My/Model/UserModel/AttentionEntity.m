//
//  AttentionEntity.m
//  GJieGo
//
//  Created by dujinxin on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "AttentionEntity.h"

@implementation AttentionEntity

@end


@implementation AttentionGuiderEntity


@end


@implementation AttentionObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
            
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray * array = (NSArray *)object;
                NSMutableArray * dataArray = [NSMutableArray array];
                for (NSDictionary * dict in array) {
                    // JSON -> User
                    AttentionEntity * entity = [AttentionEntity mj_objectWithKeyValues:dict];
                    [dataArray addObject:entity];
                }
                self.success(dataArray,message);
            }
        }
    }else{
        //block
        if (self.failure) {
            self.failure(object,message);
        }
    }
};

@end

@implementation AttentionGuiderObj
- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
            NSMutableArray * dataArray = [NSMutableArray array];
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray * array = (NSArray *)object;
                
                for (NSDictionary * dict in array) {
                    // JSON -> User
                    AttentionGuiderEntity * entity = [AttentionGuiderEntity mj_objectWithKeyValues:dict];
                    [dataArray addObject:entity];
                }
            }
            self.success(dataArray,message);
        }
    }else{
        //block
        if (self.failure) {
            self.failure(object,message);
        }
    }
};

@end
