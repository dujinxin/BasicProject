//
//  BasicEntity.h
//  GJieGo
//
//  Created by dujinxin on 16/6/2.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJXRequest.h"
#import "MJExtension.h"

typedef void(^completion)(id object,NSString *msg);

@interface BasicEntity : NSObject

@end


@interface BasicObj : DJXRequest

+ (void)get:(NSString *)url target:(id<DJXRequestDelegate>)target tag:(NSInteger)tag;
+ (void)get:(NSString *)url success:(completion)success failure:(completion)failure;

+ (void)post:(NSString *)url param:(NSDictionary *)param target:(id<DJXRequestDelegate>)target tag:(NSInteger)tag;
+ (void)post:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;

@end
