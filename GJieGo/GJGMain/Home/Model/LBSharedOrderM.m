//
//  LBSharedOrderM.m
//  GJieGo
//
//  Created by liubei on 16/6/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBSharedOrderM.h"
#import "LBUserM.h"
#import "ShareActivityModel.h"

@implementation LBSharedOrderM

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"User"]) {
        self.userM = [LBUserM modelWithDict:value];
    }else if ([key isEqualToString:@"Img"]) {
        self.image = [[value componentsSeparatedByString:@","] firstObject];
    }else if ([key isEqualToString:@"ActivityInfo"]) {
        if (value) {
            self.activityM = [ShareActivityModel modelWithDict:value];
        }
    }
}

@end
