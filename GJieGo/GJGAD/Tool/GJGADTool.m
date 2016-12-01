//
//  GJGADTool.m
//  GJieGo
//
//  Created by gjg on 16/7/5.
//  Copyright © 2016年 yangzx. All rights reserved.
//


#import "GJGADTool.h"
#import "UserRequest.h"
@implementation GJGADTool
static GJGADTool *instance;
+ (instancetype)sharedManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GJGADTool alloc] init];
    });
    
    return instance;
}


- (void)sendADRequest{
    
    [[UserRequest shareManager] getADView:kAD success:^(ADViewEntity * object,NSString *msg) {
        
        if (object) {// 有数据 保存并显示
            [self preserveADEntity:object];
        }else{ // 没有数据 不显示
            [self anyAD];
        }
        
    } failure:^(id object,NSString *msg) {
        
        [self isHaveADEntity]; // 失败 去判断缓存中是否有数据
        
    }];
}

#pragma mark - 有数据 保存并显示
- (BOOL)preserveADEntity:(ADViewEntity *)entity{
    ADViewEntity *oldEntity = [NSKeyedUnarchiver unarchiveObjectWithFile:GJGADFile];
    self.entity = entity;
    BOOL isSameAD;
    if (oldEntity.ADId != entity.ADId ) {
         [NSKeyedArchiver archiveRootObject:entity toFile:GJGADFile];
        isSameAD = NO;
    }else{
        isSameAD = YES;
    }
    return isSameAD;
}

#pragma mark - 没有数据 不显示
- (void)anyAD{
    
    self.entity = nil;
    
}

#pragma mark - 失败的回调
- (void)isHaveADEntity{
    
    ADViewEntity *entity = [NSKeyedUnarchiver unarchiveObjectWithFile:GJGADFile];
    
    if (entity) { // 有数据 显示
        
        self.entity = entity;
    }else{ // 没有数据不显示
        
        self.entity = nil;
    }
}







@end
