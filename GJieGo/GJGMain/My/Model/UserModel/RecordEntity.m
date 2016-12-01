//
//  RecordEntity.m
//  GJieGo
//
//  Created by dujinxin on 16/6/5.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "RecordEntity.h"

@implementation RecordEntity

@end

@implementation RecordGuiderEntity

@end

@implementation RecordObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
            
            NSMutableArray * dataArray = [NSMutableArray array];
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray * array = (NSArray *)object;
                for (NSDictionary * dict in array) {
                    // JSON -> User
                    RecordEntity * entity = [RecordEntity mj_objectWithKeyValues:dict];
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

@implementation RecordGuiderObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
            NSMutableArray * dataArray = [NSMutableArray array];
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray * array = (NSArray *)object;
                
                for (NSDictionary * dict in array) {
                    // JSON -> User
                    RecordGuiderEntity * entity = [RecordGuiderEntity mj_objectWithKeyValues:dict];
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
