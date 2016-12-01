//
//  VerificationCodeEntity.m
//  GJieGo
//
//  Created by dujinxin on 16/6/2.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "VerificationCodeEntity.h"

@implementation VerificationCodeEntity

@end


@implementation VerificationCodeObj

+ (void)post:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [VerificationCodeObj requestWithBlock:url param:param success:success failure:failure];
}


@end