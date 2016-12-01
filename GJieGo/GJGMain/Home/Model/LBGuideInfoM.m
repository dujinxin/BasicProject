//
//  LBGuideInfoM.m
//  GJieGo
//
//  Created by liubei on 16/6/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBGuideInfoM.h"

@implementation LBGuideInfoM

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"User"]) {
        
        self.guider = [LBGuideDetailM modelWithDict:value];
    }else if ([key isEqualToString:@"Images"]) {
        NSMutableArray *strs = [NSMutableArray arrayWithArray:[(NSString *)value componentsSeparatedByString:@","]];
        for (NSString *str in strs) {
            if (![str hasPrefix:@"http"]) {
                [strs removeObject:str];
            }
        }
        self.imgUrls = [strs copy];
    }
}

@end
