//
//  SGDateUtil.h
//  SGShow
//
//  Created by fanshijian on 15-3-10.
//  Copyright (c) 2015年 fanshijian. All rights reserved.
//  时间转化类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SGDateUtil : NSObject

+ (NSString *)getStringFromDate:(NSDate *)date;

// 根据日期字符串计算年龄
+ (NSInteger)getAgeFromBirthday:(NSString *)string;

// 根据完整的日期字符串计算年龄
+ (NSInteger)getAgeFromCompleteBirthday:(NSString *)string;

// 根据日期字符串得到对应时间戳
+ (NSString *)getTimeStampFromDate:(NSString *)string;

// 根据分钟数 显示天或小时或分前
+ (NSString *)getTimeFromTimeSpan:(NSString *)time;
+ (NSString *)getTimeFromTimeStamp:(NSString *)time;
// 根据时间戳 显示MM-dd HH:mm
+ (NSString *)getDateMinuteFromTimeStamp:(NSString *)time;
// 根据时间戳 显示yyyy-MM-dd
+ (NSString *)getDateDayFromTimeStamp:(NSString *)time;
// 根据时间戳 显示yyyy-MM-dd HH:mm:ss
+ (NSString *)getDateSecondFromTimeStamp:(NSString *)time;
// 根据分钟数 显示天或小时或分前，超过3天显示 MM-dd HH:mm
+ (NSString *)getDateTimeFromTimeStamp:(NSString *)time;
// 根据时间戳 根据dateFormatter 显示日期，
+ (NSString *)getDateDayFromTimeStamp:(NSString *)time dateFormatter:(NSString *)dateFormatter;

// 根据时间戳 dateFormatter 获取日期对象
+ (NSDate *)getDateFromTimeStamp:(NSString *)time dateFormatter:(NSString *)dateFormatter;

// 获取当前的时间戳
+ (NSString *)getCurrentTimeStamp;
// 获取当前的时间yyyy-MM-dd HH:mm:ss
+ (NSString *)getCurrentDate;
// 获取当前的时间通过日期格式yyyy-MM-dd
+ (NSString *)getCurrentDateByFormat:(NSString *)format;

// 根据date转化为时间戳
+ (NSString *)getTimeStampByDate:(NSDate *)date;

// 时间戳转化为yyyy-MM-dd HH:mm:ss 格式字符串
+ (NSString *)getDetailTimeStringFromDate:(NSDate *)date;

// 根据返回的时间戳字符串转化为yyyy-MM-dd HH:mm 格式字符串
+ (NSString *)getDetailTimeStringFromDateString:(NSString *)dateString;

// 根据返回的时间戳字符串转化为dd/MM 格式字符串
+ (NSString *)getMonthAndDayTimeStringFromDateString:(NSString *)dateString;

// 活动的时间显示
+ (NSString *)getActTimeToStartStamp:(NSString *)startTime toEndStamp:(NSString *)endTime;
// 活动报名的时间显示
+ (NSString *)getActApplyEndTimeStamp:(NSString *)endTime;
// 两个NSDate之间差多少天
+ (NSString *)getDaysForStartTime:(NSString *)startTime endTime:(NSString *)endTime;

// 根据索引(1-7) 显示星期
+ (NSString *)getWeekForIndex:(NSInteger)index;
// 根据索引(1-7)日历 显示星期
+ (NSString *)getCalendarWeekForIndex:(NSInteger)index;
// 判断是否是同一天
+ (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2;
// 根据时间戳获取星期几的值(1:星期一 7:星期日)
+ (NSString *)getWeekDayValue:(NSDate *)date;
// 根据NSDate处理发布活动的开始时间(按天设置)
+ (NSString *)getEventStartTimeByDate:(NSDate *)date;
// 根据NSDate处理发布活动的结束时间(按天设置)
+ (NSString *)getEventEndTimeByDate:(NSDate *)date;
// 获取当前时间的年\月\日返回数组
+ (NSMutableArray *)getCurrentYearMonthDay;
// 根据年月日日期获取当前星期几(2015-09-16)
+ (NSString *)getweekDayStringByDateString:(NSString *)dateString;

// chat
// 根据时间戳 转化 yyy-MM-dd HH:mm:ss.SSS
+ (NSString *)getChatDateFromTimeStamp:(NSString *)time;

+ (NSString *)getWeekDay:(NSDate *)date;

// 计算星座
+ (NSString *)getAstroWithDate:(NSDate *)date;

@end
