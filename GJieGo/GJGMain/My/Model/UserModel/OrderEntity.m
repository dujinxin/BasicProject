//
//  OrderEntity.m
//  GJieGo
//
//  Created by dujinxin on 16/6/5.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "OrderEntity.h"

@implementation OrderEntity

@end

@implementation OrderDetailEntity

@end

@implementation OrderObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
            object = @[
                       @{
                           @"OrderID": @4,  //订单ID
                           @"ShopID": @212, //店铺ID
                           @"ShopName": @"天使丽人",//店铺名称
                           @"PayDate": @232323423, //支付时间
                           @"Cost": @22,//金额
                           @"Discount": @3,//折扣
                           @"State": @"已支付	", //点单状态
                           @"GuideID": @23,
                           @"GuideName": @"阿朵",
                           @"GuideImage": @"http://images.gjg.com/test.jpg",
                           @"OrderNumber": @2323234234234//订单号
                           }
                       ];
            NSMutableArray * dataArray = [NSMutableArray array];
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray * array = (NSArray *)object;
                
                for (NSDictionary * dict in array) {
                    // JSON -> User
                    OrderEntity * entity = [OrderEntity mj_objectWithKeyValues:dict];
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

@implementation OrderDetailObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
            object = @{
                       @"OrderID": @4,  //订单ID
                       @"ShopID": @212, //店铺ID
                       @"ShopName": @"天使丽人",//店铺名称
                       @"PayDate": @232323423, //支付时间
                       @"Cost": @22,//金额
                       @"Discount": @3,//折扣
                       @"State": @"已支付	", //点单状态
                       @"GuideID": @23,
                       @"GuideName": @"阿朵",
                       @"GuideImage": @"http://images.gjg.com/test.jpg",
                       @"FollowNumber": @2323,//粉丝被关注的次数（粉丝的粉丝数）
                       @"OrderNumber": @2323234234234//订单号
                       };
            
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = (NSDictionary *)object;
                OrderDetailEntity * entity = [OrderDetailEntity mj_objectWithKeyValues:dict];
                self.success(entity,message);
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
