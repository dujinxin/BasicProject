
//
//  BusinessTypeModel.m
//  GJieGo
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BusinessTypeModel.h"

@implementation BusinessTypeModel

- (void)setData:(NSMutableArray *)Data{
    if (_Data == nil) {
        _Data = [NSMutableArray array];
    }
    if (_Data != Data) {
        for (BusinessTypeItem *item in Data) {
            [_Data addObject:item];
        }
    }
}
@end

@implementation BusinessTypeItem

@end