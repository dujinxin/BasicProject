//
//  MallDetailModel.m
//  GJieGo
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "MallDetailModel.h"

@implementation MallDetailModel

@end

@implementation MallDetailItem

- (void)setServices:(NSMutableArray *)Services{
    if (_Services == nil) {
        _Services = [NSMutableArray array];
    }
    if (_Services != Services) {
        for (MallDetailServicesItem *item in Services) {
            [_Services addObject:item];
        }
    }
}
@end

@implementation MallDetailServicesItem

@end