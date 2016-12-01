//
//  CouponEntity.m
//  GJieGo
//
//  Created by dujinxin on 16/6/5.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "CouponEntity.h"

@implementation CouponEntity

@end

@implementation CouponShopEntity

@end

@implementation CouponDetailEntity

@end

@implementation CouponObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
//            object = @[
//                       @{
//                           @"CouponID": @012,
//                           @"ShopID": @212,
//                           @"CouponName": @"满10减2",
//                           @"ShopName": @"国瑞城",
//                           @"DiscountDesc": @"仅限于端午节当天使用",
//                           @"AvailableTime": @"2016-06-09",
//                           @"QuantityLimit": @"1",
//                           @"ShopDesc": @"国瑞城鸭血粉丝汤",
//                           @"ShopAddress": @"崇文门外大街",
//                           @"Distance": @"1000",
//                           @"Discount":@"5元",
//                           @"TypeName":@"折扣券",
//                           @"Status":@2
//                           }
//                       ];
            NSMutableArray * dataArray = [NSMutableArray array];
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray * array = (NSArray *)object;
                
                for (NSDictionary * dict in array) {
                    // JSON -> User
                    CouponEntity * entity = [CouponEntity mj_objectWithKeyValues:dict];
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

@implementation CouponShopObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (!isSuccess) {
        if (self.success) {
            object = @[
                       @{
                           @"CouponID": @012,
                           @"ShopID": @212,
                           @"CouponName": @"满10减2",
                           @"ShopName": @"国瑞城",
                           @"DiscountDesc": @"仅限于端午节当天使用",
                           @"AvailableTime": @"2016-06-09",
                           }
                       ];
            
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray * array = (NSArray *)object;
                NSMutableArray * dataArray = [NSMutableArray array];
                for (NSDictionary * dict in array) {
                    // JSON -> User
                    CouponShopEntity * entity = [CouponShopEntity mj_objectWithKeyValues:dict];
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

@implementation CouponDetailObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
//            object = @{
//                           @"CouponID": @012,
//                           @"ShopID": @212,
//                           @"CouponName": @"满10减2",
//                           @"ShopName": @"国瑞城",
//                           @"DiscountDesc": @"仅限于端午节当天使用",
//                           @"AvailableTime": @"2016-06-09",
//                           @"QuantityLimit": @"1",
//                           @"ShopDesc": @"国瑞城鸭血粉丝汤",
//                           @"ShopAddress": @"崇文门外大街",
//                           @"Distance": @"1000",
//                           @"Discount":@"5元",
//                           @"TypeName":@"折扣券",
//                           @"Status":@2
//                    };

            
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = (NSDictionary *)object;
                CouponDetailEntity * entity = [CouponDetailEntity mj_objectWithKeyValues:dict];
                self.success(entity,message);
            }
        }
    }else{
        if (self.failure) {
            self.failure(object,message);
        }
    }
};

@end
