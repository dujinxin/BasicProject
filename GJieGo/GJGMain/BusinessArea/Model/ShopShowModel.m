//
//  ShopShowModel.m
//  GJieGo
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "ShopShowModel.h"

@implementation ShopShowModel

- (void)setData:(NSMutableArray *)Data{
    if (_Data == nil) {
        _Data = [NSMutableArray array];
    }
    if (_Data != Data) {
        for (ShopShowItem *item in Data) {
            [_Data addObject:item];
        }
    }
}
@end

@implementation ShopShowItem

@end