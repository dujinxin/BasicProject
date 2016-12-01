//
//  UserEntity.m
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "UserEntity.h"

@implementation UserEntity

@end

@implementation UserObj


- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    if (isSuccess) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(responseSuccessObj:tag:)]) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = (NSDictionary *)object;

                // JSON -> User
                UserEntity * entity = [UserEntity mj_objectWithKeyValues:dict];
                [self.delegate responseSuccessObj:entity tag:self.tag];
            }
        }
    }else{
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(responseFailed:message:)]) {
            [self.delegate responseFailed:self.tag message:message];
        }
    }
}
@end