//
//  HotPushMallModel.m
//  GJieGo
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "HotPushMallModel.h"

@implementation HotPushMallModel

- (void)setData:(NSMutableArray *)Data{
    if (_Data == nil) {
        _Data = [NSMutableArray array];
    }
    if (_Data != Data) {
        for (HotPushMallItem *item in Data) {
            [_Data addObject:item];
        }
    }
}
@end

@implementation HotPushMallItem

@end