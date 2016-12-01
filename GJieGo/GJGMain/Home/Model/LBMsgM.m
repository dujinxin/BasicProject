//
//  LBMsgM.m
//  GJieGo
//
//  Created by liubei on 16/6/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBMsgM.h"
#import "LBUserM.h"

@implementation LBMsgM

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"CommentUser"]) {
        self.user = [LBUserM modelWithDict:value];
    }
}

@end
