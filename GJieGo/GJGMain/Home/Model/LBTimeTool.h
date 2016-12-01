//
//  LBTimeTool.h
//  GJieGo
//
//  Created by liubei on 16/6/14.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBTimeTool : NSObject

+ (instancetype)sharedTimeTool;

- (NSString *)stringWithInteger:(NSInteger)time;

@end
