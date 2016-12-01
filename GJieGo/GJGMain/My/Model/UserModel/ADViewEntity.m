//
//  ADViewEntity.m
//  GJieGo
//
//  Created by gjg on 16/6/21.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "ADViewEntity.h"

@implementation ADViewEntity
#pragma mark - <NSCoding>
MJCodingImplementation
@end

@implementation ADObj

#pragma mark - 子类的重写
- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if(self.success){

            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary* dict = (NSDictionary*)object;
                    ADViewEntity *entity = [ADViewEntity mj_objectWithKeyValues:dict];
                self.success(entity,message);
            }else{
                ADViewEntity *entity = nil;
                self.success(entity,message);
            }
        }
    }else{
        if (self.failure) {
            self.failure(object,message);
        }
    }
    
}

@end
