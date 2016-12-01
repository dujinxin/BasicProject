//
//  FansEntity.m
//  GJieGo
//
//  Created by dujinxin on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "FansEntity.h"

@implementation FansEntity

@end

@implementation FansObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
            NSMutableArray * dataArray = [NSMutableArray array];
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray * array = (NSArray *)object;
                
                for (NSDictionary * dict in array) {
                    // JSON -> User
                    FansEntity * entity = [FansEntity mj_objectWithKeyValues:dict];
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

@implementation FansNumberObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
            self.success(object,message);
        }
    }else{
        //block
        if (self.failure) {
            self.failure(object,message);
        }
    }
};

@end
