//
//  LBTimeTool.m
//  GJieGo
//
//  Created by liubei on 16/6/14.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBTimeTool.h"

@interface LBTimeTool ()

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation LBTimeTool
static LBTimeTool *_instance;

+ (instancetype)sharedTimeTool {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
        _instance.formatter = [[NSDateFormatter alloc] init];
        [_instance.formatter setDateStyle:NSDateFormatterMediumStyle];
        [_instance.formatter setTimeStyle:NSDateFormatterShortStyle];
        [_instance.formatter setDateFormat:@"yyyy-MM-dd HH:MM"];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [super allocWithZone:zone];
        
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    
    return _instance;
}

- (NSString *)stringWithInteger:(NSInteger)time {
    
    NSTimeInterval late = time * 1;
//    NSTimeInterval  timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
//    late -= timeZoneOffset;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970];
    
    NSTimeInterval cha = now - late;
    
    NSString * timeString = @"";
    
    if (cha <= 60) {
        timeString = @"刚刚";
    }
    if (cha > 60 && cha/3600 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    if (cha/3600 > 1 && cha/86400 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha/86400 > 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
        
    }
    
    return timeString;
//    return [_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
}

@end
