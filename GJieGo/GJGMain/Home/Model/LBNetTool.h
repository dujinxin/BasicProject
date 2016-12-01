//
//  LBNetTool.h
//  GJieGo
//
//  Created by liubei on 16/6/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBNetTool : NSObject

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

@end
