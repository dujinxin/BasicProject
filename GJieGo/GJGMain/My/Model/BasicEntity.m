//
//  BasicEntity.m
//  GJieGo
//
//  Created by dujinxin on 16/6/2.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicEntity.h"

@implementation BasicEntity
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"BasicEntity: value:%@  key:%@",value,key);
}
@end


@implementation BasicObj
/*
 *@param get request
 */
+ (void)get:(NSString *)url target:(id<DJXRequestDelegate>)target tag:(NSInteger)tag{
    [BasicObj requestWithDelegate:target nApiTag:tag url:url param:nil];
}
+ (void)get:(NSString *)url success:(completion)success failure:(completion)failure{
    [BasicObj requestWithBlock:url param:nil success:success failure:failure];
}
/*
 *@param post request
 */
+ (void)post:(NSString *)url param:(NSDictionary *)param target:(id<DJXRequestDelegate>)target tag:(NSInteger)tag{
    [BasicObj requestWithDelegate:target nApiTag:tag url:url param:param];
}
+ (void)post:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [BasicObj requestWithBlock:url param:param success:success failure:failure];
}

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
};
@end