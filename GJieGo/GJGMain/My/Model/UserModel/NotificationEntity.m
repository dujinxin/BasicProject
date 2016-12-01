//
//  NotificationEntity.m
//  GJieGo
//
//  Created by dujinxin on 16/9/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "NotificationEntity.h"

@implementation NotificationEntity

@end


@implementation NotificationObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
            NSMutableArray * dataArray = [NSMutableArray array];
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray * array = (NSArray *)object;
                
                for (NSDictionary * dict in array) {
                    // JSON -> User
                    //NotificationEntity * entity = [NotificationEntity mj_objectWithKeyValues:dict];
                    //[dataArray addObject:entity];
                    [dataArray addObject:dict];
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
