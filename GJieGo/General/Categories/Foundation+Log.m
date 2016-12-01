//
//  NSDictionary+Log.m
//
//  系统扩展类.用于NSLog输出中文字体
//
//  Created by 刘贝
//

#import <Foundation/Foundation.h>

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *string = [NSMutableString string];
    
    // 在开头添加'{'
    [string appendString:@"{\n"];
    
    // 遍历字典的所有键值对, 将其一一添加到string中
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        [string appendFormat:@"\t%@", key];
        [string appendString:@" : "];
        [string appendFormat:@"%@,\n", obj];
    }];
    
    // 在结尾添加'}'
    [string appendString:@"}"];
    
    // 查找最后一个逗号并删除
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    
    if (range.location != NSNotFound) {
        
        [string deleteCharactersInRange:range];
    }
    return string;
}
@end

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *string = [NSMutableString string];
    
    // 在开头添加'['
    [string appendString:@"[\n"];
    
    // 遍历数组中所有的元素, 添加进string
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [string appendFormat:@"\t%@,\n", obj];
    }];
    
    // 在结尾添加']'
    [string appendString:@"]"];
    
    // 查找最后一个逗号并删除
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    
    if (range.location != NSNotFound) {
     
        [string deleteCharactersInRange:range];
    }
    return string;
}

@end
