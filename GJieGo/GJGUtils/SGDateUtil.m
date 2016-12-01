//
//  SGDateUtil.m
//  SGShow
//
//  Created by fanshijian on 15-3-10.
//  Copyright (c) 2015年 fanshijian. All rights reserved.
//

#import "SGDateUtil.h"

@implementation SGDateUtil

+ (NSString *)getStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

// 根据日期字符串计算年龄
+ (NSInteger)getAgeFromBirthday:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 10:08:33"];
    NSDate *birDate = [formatter dateFromString:string];
    NSTimeInterval dateDiff = [birDate timeIntervalSinceNow];
    NSInteger age = -trunc(dateDiff/(60*60*24))/365;
    return age;
}

// 根据完整的日期字符串计算年龄
+ (NSInteger)getAgeFromCompleteBirthday:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *birDate = [formatter dateFromString:string];
    NSTimeInterval dateDiff = [birDate timeIntervalSinceNow];
    NSInteger age = -trunc(dateDiff/(60*60*24))/365;
    return age;
}

// 根据日期字符串得到对应时间戳
+ (NSString *)getTimeStampFromDate:(NSString *)string {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *date = [formatter dateFromString:string];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]*1000];
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    
    return timeSp;
}

// 根据分钟数 显示天或小时或分前
+ (NSString *)getTimeFromTimeSpan:(NSString *)time {
    NSString *str = @"";
    int seconds = [time intValue];
    if (seconds <= 0) {
       str = @"刚刚";
    }else {
        if (seconds / (60*24) > 0 ) {
            str = [NSString stringWithFormat:@"%d天前",seconds / (60*24)];
        }else if (seconds / 60 > 0) {
            str = [NSString stringWithFormat:@"%d小时前",seconds / 60];
        }else {
            str = [NSString stringWithFormat:@"%ld分钟前",(long)seconds];
        }
    }
    return str;
}

+ (NSString *)getTimeFromTimeStamp:(NSString *)time {
    NSTimeInterval stamp = [time longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
    NSTimeInterval todayTime = [[NSDate date] timeIntervalSinceDate:date];
    
    return [self getTimeFromTimeSpan:[NSString stringWithFormat:@"%f",todayTime/60.0]];
}

// 根据时间戳 显示MM-dd HH:mm
+ (NSString *)getDateMinuteFromTimeStamp:(NSString *)time {
    NSTimeInterval stamp = [time longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

/*
 NSTimeInterval  timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
 stamp -= timeZoneOffset; 转换时要减去时差
 */
// 根据时间戳 显示yyyy-MM-dd
+ (NSString *)getDateDayFromTimeStamp:(NSString *)time {
    
    NSTimeInterval stamp = [time longLongValue]/1000;
    NSTimeInterval  timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
    stamp -= timeZoneOffset;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

// 根据时间戳 显示yyyy-MM-dd HH:mm:ss
+ (NSString *)getDateSecondFromTimeStamp:(NSString *)time {
    NSTimeInterval stamp = [time longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

// 根据分钟数 显示天或小时或分前，超过3天显示 MM-dd HH:mm
+ (NSString *)getDateTimeFromTimeStamp:(NSString *)time {
    NSTimeInterval stamp = [time longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
    NSTimeInterval todayTime = [[NSDate date] timeIntervalSinceDate:date];
    if (todayTime < 3*24*60*60) {
        // 少于3天
        return [self getTimeFromTimeSpan:[NSString stringWithFormat:@"%f",todayTime/60.0]];
    }else {
        // 大于等于3天
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        NSString *dateStr = [formatter stringFromDate:date];
        return dateStr;
    }
}

// 根据时间戳 根据dateFormatter 显示日期，
+ (NSString *)getDateDayFromTimeStamp:(NSString *)time dateFormatter:(NSString *)dateFormatter {
    NSTimeInterval stamp = [time longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateFormatter];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}


// 根据时间戳 dateFormatter 获取日期对象
+ (NSDate *)getDateFromTimeStamp:(NSString *)time dateFormatter:(NSString *)dateFormatter {
    NSTimeInterval stamp = [time longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateFormatter];
    NSString *dateStr = [formatter stringFromDate:date];
    NSDate *tDate = [formatter dateFromString:dateStr];
    return tDate;
}


// 获取当前的时间戳
+ (NSString *)getCurrentTimeStamp {
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f",time*1000];
}

// 获取当前的时间yyyy-MM-dd HH:mm:ss
+ (NSString *)getCurrentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

// 获取当前的时间通过日期格式yyyy-MM-dd
+ (NSString *)getCurrentDateByFormat:(NSString *)format {
    NSDate *date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

// 根据date转化为时间戳
+ (NSString *)getTimeStampByDate:(NSDate *)date {
    NSTimeInterval time = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f",time*1000];
}

// 时间戳转化为yyyy-MM-dd HH:mm:ss 格式字符串
+ (NSString *)getDetailTimeStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

// 根据返回的时间戳字符串转化为yyyy-MM-dd HH:mm 格式字符串
+ (NSString *)getDetailTimeStringFromDateString:(NSString *)dateString {
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[dateString longLongValue]/1000];
    return [self getDetailTimeStringFromDate:timeDate];
}

// 活动的时间显示
+ (NSString *)getActTimeToStartStamp:(NSString *)startTime toEndStamp:(NSString *)endTime {
    NSTimeInterval startInt = [startTime longLongValue]/1000;
    NSTimeInterval endInt = [endTime longLongValue]/1000;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startInt];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endInt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([self isSameDay:startDate date2:endDate]) {
        // 同一天
        [formatter setDateFormat:@"MM-dd"];
        NSString *startD = [formatter stringFromDate:startDate];
        [formatter setDateFormat:@"HH:mm"];
        NSString *startHM = [formatter stringFromDate:startDate];
        NSString *endHM = [formatter stringFromDate:endDate];
        NSString *week = [self getWeekDay:startDate];
        return [NSString stringWithFormat:@"%@ (%@) %@-%@",startD,week,startHM,endHM];
    }else {
        // 非同一天
        [formatter setDateFormat:@"MM-dd HH:mm"];
        NSString *startD = [formatter stringFromDate:startDate];
        NSString *endD = [formatter stringFromDate:endDate];
        return [NSString stringWithFormat:@"%@ ~ %@",startD,endD];
    }
    return @"";
}

// 活动报名的时间显示
+ (NSString *)getActApplyEndTimeStamp:(NSString *)endTime {
    NSTimeInterval endInt = [endTime longLongValue]/1000;
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endInt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"MM-dd"];
    NSString *endD = [formatter stringFromDate:endDate];
    [formatter setDateFormat:@"HH:mm"];
    NSString *endHM = [formatter stringFromDate:endDate];
    NSString *week = [self getWeekDay:endDate];
    return [NSString stringWithFormat:@"%@ (%@) %@",endD,week,endHM];
}

// 两个NSDate之间差多少天
+ (NSString *)getDaysForStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    if (startTime == nil) {
        return @"";
    }
    if (endTime == nil) {
        return @"";
    }
    NSTimeInterval startInt = [startTime longLongValue]/1000;
    NSTimeInterval endInt = [endTime longLongValue]/1000;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startInt];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endInt];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
    NSInteger days = [components day];
    NSInteger hours = [components hour];
    
    NSInteger count = days;
    if (days >= 0) {
        if (hours > 0) {
            count += 1;
        }
    }
    if (count > 0) {
        return [NSString stringWithFormat:@"%ld天后",(long)count];
    }
    return @"";
}

// 根据索引(1-7) 显示星期
+ (NSString *)getWeekForIndex:(NSInteger)index {
    NSString *str = @"";
    switch (index) {
        case 0:
            str = @"星期日";
            break;
        case 1:
            str = @"星期一";
            break;
        case 2:
            str = @"星期二";
            break;
        case 3:
            str = @"星期三";
            break;
        case 4:
            str = @"星期四";
            break;
        case 5:
            str = @"星期五";
            break;
        case 6:
            str = @"星期六";
            break;
        case 7:
            str = @"星期日";
            break;
            
        default:
            break;
    }
    return str;
}

// 根据索引(1-7)日历 显示星期
+ (NSString *)getCalendarWeekForIndex:(NSInteger)index {
    NSString *str = @"";
    switch (index) {
        case 1:
            str = @"周日";
            break;
        case 2:
            str = @"周一";
            break;
        case 3:
            str = @"周二";
            break;
        case 4:
            str = @"周三";
            break;
        case 5:
            str = @"周四";
            break;
        case 6:
            str = @"周五";
            break;
        case 7:
            str = @"周六";
            break;
            
        default:
            break;
    }
    return str;
}

// 根据返回的时间戳字符串转化为dd/MM 格式字符串
+ (NSString *)getMonthAndDayTimeStringFromDateString:(NSString *)dateString {
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[dateString longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM"];
    NSString *resultString = [formatter stringFromDate:timeDate];
    NSArray *resultArray = [resultString componentsSeparatedByString:@"/"];
    
    NSString *daysString = [resultArray objectAtIndex:0];
    NSString *dayFirstStr = [daysString substringToIndex:1];
    if ([dayFirstStr intValue] == 0) {
        daysString = [daysString substringWithRange:NSMakeRange(1, 1)];
    }
    
    NSString *monthString = [resultArray objectAtIndex:1];
    NSString *monthFirstStr = [monthString substringToIndex:1];
    if ([monthFirstStr intValue] == 0) {
        monthString = [monthString substringWithRange:NSMakeRange(1, 1)];
    }
    
    NSString *finalString = [NSString stringWithFormat:@"%@/%@月",daysString,monthString];
    return finalString;
}

// chat
// 根据时间戳 转化 yyy-MM-dd HH:mm:ss.SSS
+ (NSString *)getChatDateFromTimeStamp:(NSString *)time {
    NSTimeInterval stamp = [time longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

// 判断是否是同一天
+ (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
}

// 根据时间戳获取星期几的值(1:星期一 7:星期日)
+ (NSString *)getWeekDayValue:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents *comp = [calendar components:unitFlag fromDate:date];
    NSInteger week = comp.weekday;
    switch (week) {
        case 1:
            return @"7";
            break;
        case 2:
            return @"1";
            break;
        case 3:
            return @"2";
            break;
        case 4:
            return @"3";
            break;
        case 5:
            return @"4";
            break;
        case 6:
            return @"5";
            break;
        case 7:
            return @"6";
            break;
        default:
            break;
    }
    return @"";
}

// 根据NSDate处理发布活动的开始时间(按天设置)
+ (NSString *)getEventStartTimeByDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 00:00"];
    NSString *dateString = [formatter stringFromDate:date];
    
    NSDateFormatter *tempformatter = [[NSDateFormatter alloc] init];
    [tempformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *resultDate = [tempformatter dateFromString:dateString];
    NSString *resultString = [self getTimeStampByDate:resultDate];
    return resultString;
}

// 根据NSDate处理发布活动的结束时间(按天设置)
+ (NSString *)getEventEndTimeByDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 23:59"];
    NSString *dateString = [formatter stringFromDate:date];
    
    NSDateFormatter *tempformatter = [[NSDateFormatter alloc] init];
    [tempformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *resultDate = [tempformatter dateFromString:dateString];
    NSString *resultString = [self getTimeStampByDate:resultDate];
    return resultString;
}

// 获取当前时间的年\月\日返回数组
+ (NSMutableArray *)getCurrentYearMonthDay {
    NSString *dateString = [self getStringFromDate:[NSDate date]];
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    NSString *year = [NSString stringWithFormat:@"%@年",[dateArray objectAtIndex:0]];
    [resultArray addObject:year];
    
    // 几月几日星期几
    NSString *month = [NSString stringWithFormat:@"%@月",[dateArray objectAtIndex:1]];
    NSString *day = [NSString stringWithFormat:@"%@日",[dateArray objectAtIndex:2]];
    NSString *week = [self getWeekDay:[NSDate date]];
    NSString *monthDayWeekStr = [[month stringByAppendingString:day] stringByAppendingString:week];
    [resultArray addObject:monthDayWeekStr];
    
    return resultArray;
}

// 根据年月日日期获取当前星期几(2015-09-16)
+ (NSString *)getweekDayStringByDateString:(NSString *)dateString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年-MM月-dd日"];
    
    NSDate *date = [formatter dateFromString:dateString];
    NSString *resultString = [self getWeekDay:date];
    return resultString;
}

// 根据选择的日期获取对应的date
+ (NSDate *)getDateFromTimeString:(NSString *)timeString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年-MM月-dd日 EEEE"];
    
    NSDate *date = [formatter dateFromString:timeString];
    return date;
}

#pragma mark - 内部方法
+ (NSString *)getWeekDay:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents *comp = [calendar components:unitFlag fromDate:date];
    NSInteger week = comp.weekday;
    switch (week) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            break;
    }
    return @"";
}

// 计算星座
+ (NSString *)getAstroWithDate:(NSDate *)date {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM"];
    NSString *mStr = [formatter stringFromDate:date];
    [formatter setDateFormat:@"dd"];
    NSString *dStr = [formatter stringFromDate:date];
    
    int m = [mStr intValue];
    int d = [dStr intValue];
    NSString *astroFormat = @"101122344432";
    
    NSString *str1 = [astroFormat substringWithRange:NSMakeRange(m-1, 1)];
    NSString *str2 = [NSString stringWithFormat:@"2%@",str1];
    int xzIndex = 1;
    if (m > 3) {
        if (d >= [str2 intValue]) {
            xzIndex = m-2;
        }else {
            xzIndex = m-3;
        }
    }else if (m==3) {
        if (d >= [str2 intValue]) {
            xzIndex = m-2;
        }else {
            xzIndex = 12;
        }
    }else {
        if (d >= [str2 intValue]) {
            xzIndex = (m+12)-2;
        }else {
            xzIndex = (m+12)-3;
        }
    }
    return [NSString stringWithFormat:@"%d",xzIndex];
}

@end
