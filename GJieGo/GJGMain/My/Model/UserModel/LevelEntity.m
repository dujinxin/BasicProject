//
//  LevelEntity.m
//  GJieGo
//
//  Created by dujinxin on 16/6/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LevelEntity.h"

@implementation LevelEntity

@end


@implementation LevelObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
//            object =  @[
//                        @{
//                            @"LevelId": @1, //级别编号
//                            @"Points": @100,//级别要求点数
//                            @"LevelName": @"lv.1",//级别名称
//                            },
//                        @{
//                            @"LevelId": @2, //级别编号
//                            @"Points": @200,//级别要求点数
//                            @"LevelName": @"lv.2",//级别名称
//                            },
//                        @{
//                            @"LevelId": @3, //级别编号
//                            @"Points": @400,//级别要求点数
//                            @"LevelName": @"lv.3",//级别名称
//                            },
//                        @{
//                            @"LevelId": @4, //级别编号
//                            @"Points": @800,//级别要求点数
//                            @"LevelName": @"lv.4",//级别名称
//                            },
//                        @{
//                            @"LevelId": @5, //级别编号
//                            @"Points": @1600,//级别要求点数
//                            @"LevelName": @"lv.5",//级别名称
//                            },
//                        @{
//                            @"LevelId": @6, //级别编号
//                            @"Points": @3200,//级别要求点数
//                            @"LevelName": @"lv.6",//级别名称
//                            },
//                        @{
//                            @"LevelId": @7, //级别编号
//                            @"Points": @6400,//级别要求点数
//                            @"LevelName": @"lv.7",//级别名称
//                            },
//                        @{
//                            @"LevelId": @8, //级别编号
//                            @"Points": @12800,//级别要求点数
//                            @"LevelName": @"lv.8",//级别名称
//                            }
//                        ];
            
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray * array = (NSArray *)object;
                NSMutableArray * dataArray = [NSMutableArray array];
                for (NSDictionary * dict in array) {
                    // JSON -> User
                    LevelEntity * entity = [LevelEntity mj_objectWithKeyValues:dict];
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

@implementation TaskEntity

@end

@implementation TaskObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
//            object =  @[
//                        @{
//                            @"TaskType": @1, //任务类型编号
//                            @"TaskName": @"注册",//任务名称
//                            @"TaskPoint": @"2",	//任务+成长值
//                            @"IsComplete": @true,//是否已完成
//                            },
//                        @{
//                            @"TaskType": @1, //任务类型编号
//                            @"TaskName": @"完善资料",//任务名称
//                            @"TaskPoint": @"5",	//任务+成长值
//                            @"IsComplete": @false,//是否已完成
//                            },
//                        @{
//                            @"TaskType": @1, //任务类型编号
//                            @"TaskName": @"粉丝数量超过10",//任务名称
//                            @"TaskPoint": @"10",	//任务+成长值
//                            @"IsComplete": @false,//是否已完成
//                            },
//                        @{
//                            @"TaskType": @1, //任务类型编号
//                            @"TaskName": @"粉丝数量超过50",//任务名称
//                            @"TaskPoint": @"50",	//任务+成长值
//                            @"IsComplete": @false,//是否已完成
//                            },
//                        @{
//                            @"TaskType": @1, //任务类型编号
//                            @"TaskName": @"粉丝数量超过100",//任务名称
//                            @"TaskPoint": @"100",	//任务+成长值
//                            @"IsComplete": @false,//是否已完成
//                            },
//                        ];
            
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray * array = (NSArray *)object;
                NSMutableArray * dataArray = [NSMutableArray array];
                for (NSDictionary * dict in array) {
                    // JSON -> User
                    TaskEntity * entity = [TaskEntity mj_objectWithKeyValues:dict];
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


@implementation UserLevelEntity

@end

@implementation UserLevelObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
            
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = (NSDictionary *)object;
                UserLevelEntity * entity = [UserLevelEntity mj_objectWithKeyValues:dict];
                self.success(entity,message);
            }else{
                self.success(object,message);
            }
        }
    }else{
        if (self.failure) {
            self.failure(object,message);
        }
    }
};

@end
