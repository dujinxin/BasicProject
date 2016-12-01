//
//  RunTypeMallModel.m
//  GJieGo
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "RunTypeMallModel.h"

@implementation RunTypeMallModel

- (void)setData:(NSMutableArray *)Data
{
    if (_Data == nil) {
        _Data = [NSMutableArray array];
    }
    if (_Data != Data) {
        for (RunTypeMallItem *item in Data) {
            [_Data addObject:item];
        }
    }
}
@end

@implementation RunTypeMallItem

@end