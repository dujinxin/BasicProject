//
//  OpenedCityModel.m
//  GJieGo
//
//  Created by apple on 16/6/20.
//  Copyright © 2016年 yangzx. All rights reserved.
// 

#import "OpenedCityModel.h"

@implementation OpenedCityModel

- (void)setData:(NSMutableArray *)Data{
    if (_Data == nil) {
        _Data = [NSMutableArray array];
    }
    if (_Data != Data) {
        for (OpenedCityItem *item in Data) {
            [_Data addObject:item];
        }
    }
}
@end

@implementation OpenedCityItem

@end