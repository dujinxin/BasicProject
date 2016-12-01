//
//  LBBaseModel.m
//  GJieGo
//
//  Created by liubei on 16/6/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBBaseModel.h"

@implementation LBBaseModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)objectsWithArray:(NSArray *)array {
    
    NSMutableArray *tmpArr = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        
        [tmpArr addObject:[[self alloc] initWithDict:dict]];
    }
    
    return tmpArr;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (id)valueForUndefinedKey:(NSString *)key {
    
    return nil;
}
@end
