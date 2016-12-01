//
//  CollectionEntity.m
//  GJieGo
//
//  Created by dujinxin on 16/6/8.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "CollectionEntity.h"

@implementation CollectionEntity

@end

@implementation CollectionObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
//            object =  @[
//                        @{
//                            @"ShopID": @121,  	//晒单编号
//                            @"ShopName": @"天使丽人",//截取后
//                            @"Image": @"http://wewe.jpg",		//图片
//                            @"Floor": @122,		//晒单被赞的次数，
//                            @"Collection": @1221,		//评论数
//                            @"MallName": @"国瑞城",
//                            @"MallID": @10,		//晒单被赞的次数，
//                            @"Distance": @1221,		//评论数
//                            }
//                        ];
            NSMutableArray * dataArray = [NSMutableArray array];
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray * array = (NSArray *)object;
                
                for (NSDictionary * dict in array) {
                    // JSON -> User
                    CollectionEntity * entity = [CollectionEntity mj_objectWithKeyValues:dict];
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

@implementation CategoryEntity

@end

@implementation CategoryObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
//            object =  @[
//                        @{
//                            @"DicID":@88,
//                            @"DicKey":@"sdfsdf",
//                            @"DicName":@"时尚服装",
//                            @"DicExt":@"123.jpg",
//                            @"ShopID":@0
//                        },
//                        @{
//                            @"DicID":@88,
//                            @"DicKey":@"sdfsdf",
//                            @"DicName":@"时尚服装",
//                            @"DicExt":@"123.jpg",
//                            @"ShopID":@0
//                            },@{
//                            @"DicID":@88,
//                            @"DicKey":@"sdfsdf",
//                            @"DicName":@"时尚服装",
//                            @"DicExt":@"123.jpg",
//                            @"ShopID":@0
//                            },@{
//                            @"DicID":@88,
//                            @"DicKey":@"sdfsdf",
//                            @"DicName":@"时尚服装",
//                            @"DicExt":@"123.jpg",
//                            @"ShopID":@0
//                            }
//                        ];

            
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray * array = (NSArray *)object;
                NSMutableArray * dataArray = [NSMutableArray array];
                for (NSDictionary * dict in array) {
                    // JSON -> User
                    CategoryEntity * entity = [CategoryEntity mj_objectWithKeyValues:dict];
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
