//
//  BaseModel.h
//  GJieGo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGSettingUtil.h"

@interface BaseModel : NSObject


- (instancetype)initWithDic:(NSDictionary *)dict;
+ (instancetype)operationWithDic:(NSDictionary *)dict;
+ (NSArray *)objectsWithArray:(NSArray *)array;
//- (BOOL) isBlankString:(NSString *)string;
//- (BOOL) isBlankDictionary:(NSDictionary *)dic;
//- (BOOL) isBlankArray:(NSArray *)array;
@end
