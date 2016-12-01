//
//  ByCityModel.m
//  GJieGo
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "ByCityModel.h"


@implementation ByCityItem

@end
@implementation ByCityModel

- (void)setData:(NSMutableArray *)Data{
    if (_Data == nil) {
        _Data = [NSMutableArray array];
    }
    if (_Data != Data) {
        for (ByCityItem *item in Data) {
            [_Data addObject:item];
        }
    }
    
}
@end
