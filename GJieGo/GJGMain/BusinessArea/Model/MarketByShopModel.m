//
//  MarketByShopModel.m
//  GJieGo
//
//  Created by apple on 16/7/7.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "MarketByShopModel.h"

@implementation MarketByShopModel
- (void)setData:(NSMutableArray *)Data{
    if (_Data == nil) {
        _Data = [NSMutableArray array];
    }
    if (_Data != Data) {
        for (MarketByShopItem *item in Data) {
            [_Data addObject:item];
        }
    }
}
@end

@implementation MarketByShopItem

@end