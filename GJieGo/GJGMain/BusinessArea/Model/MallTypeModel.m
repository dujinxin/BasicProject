//
//  MallTypeModel.m
//  GJieGo
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "MallTypeModel.h"

@implementation MallTypeModel
- (void)setMallList:(NSMutableArray *)MallList{
    if (_MallList != MallList) {
        for (MallTypeItem * item in MallList) {
            [_MallList addObject:item];
        }
    }
}
@end
