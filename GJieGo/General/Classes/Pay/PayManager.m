//
//  PayManager.m
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "PayManager.h"

@implementation PayManager

static PayManager * manager = nil;
+(PayManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PayManager alloc]init ];
        
        
    });
    return manager;
}

@end
