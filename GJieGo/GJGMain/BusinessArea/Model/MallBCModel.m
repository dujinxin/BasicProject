//
//  MallBCModel.m
//  GJieGo
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "MallBCModel.h"

@implementation MallBCListItem

@end

@implementation MallBCItem

- (void)setMallList:(NSMutableArray *)MallList{
    if (_MallList == nil) {
        _MallList = [NSMutableArray array];
    }
    if (_MallList != MallList) {
        
        for (MallBCListItem *item in MallList) {
            [_MallList addObject:item];
        }
    }
}
@end

@implementation MallBCModel

- (void)setData:(NSMutableArray *)Data{
    if (_Data == nil) {
        _Data = [NSMutableArray array];
    }
    if (_Data != Data) {
        
        for (MallBCItem *item in Data) {
            [_Data addObject:item];
        }
    }
}

@end
