//
//  BaseModel.m
//  GJieGo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
- (instancetype)initWithDic:(NSDictionary *)dict{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)operationWithDic:(NSDictionary *)dict{
    return [[self alloc] initWithDic:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

//- (void)setValue:(id)value forKey:(NSString *)key{
//    
//}

+ (NSArray *)objectsWithArray:(NSArray *)array{
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [tmpArr addObject:[[self alloc]initWithDic:dict]];
    }
    return tmpArr;
}
//- (BOOL) isBlankString:(NSString *)string {
//    if (string == nil || string == NULL) {
//        return YES;
//    }
//    if ([string isKindOfClass:[NSNull class]]) {
//        return YES;
//    }
//    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
//        return YES;
//    }
//    return NO;
//}
//
//- (BOOL) isBlankDictionary:(NSDictionary *)dic {
//    if (dic == nil || dic == NULL) {
//        return YES;
//    }
//    if ([dic isKindOfClass:[NSNull class]]) {
//        return YES;
//    }
//    return NO;
//}
//
//- (BOOL) isBlankArray:(NSArray *)array {
//    if (array == nil || array == NULL) {
//        return YES;
//    }
//    if ([array isKindOfClass:[NSNull class]]) {
//        return YES;
//    }
//    if (array.count == 0) {
//        return YES;
//    }
//    return NO;
//}

@end
