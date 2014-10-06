//
//  NSDate+FEExtension.m
//  FETestCategory
//
//  Created by xxx on 13-10-9.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import "NSDate+FEExtension.h"

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (FEExtension)
+ (long long)millisecondsSince1970 {
	NSTimeInterval secondsSince1970 = [[NSDate date] timeIntervalSince1970];
	return (long long)round(secondsSince1970 * 1000);
}

+ (long long)secondsSince1970 {
	NSTimeInterval secondsSince1970 = [[NSDate date] timeIntervalSince1970];
	return (long long)round(secondsSince1970);
}

/// modify by kongkong
+ (NSString*)dateWithDateFormatStyle:(NSDateFormatterStyle)dateFormatStyle
{
    NSDate* now = [NSDate date];
     NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
     fmt.dateStyle = dateFormatStyle;
     fmt.timeStyle = dateFormatStyle;
     fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
     return [fmt stringFromDate:now];
}

+ (NSString*)dateWithCustomFormat{
    NSDate* now = [NSDate date];
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd a HH:mm:ss EEEE";
    return [fmt stringFromDate:now];
}

#pragma mark Decomposing Dates
//https://github.com/erica/NSDate-Extensions/blob/master/NSDate-Utilities.h
+ (NSInteger)seconds{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
	return components.second;
}

+ (NSInteger)minute{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
	return components.minute;
}

+ (NSInteger)hour{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
	return components.hour;
}

+ (NSInteger)nearestHour{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents *components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
	return components.hour;
}

+ (NSInteger)day{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
	return components.day;
}

+ (NSInteger)week{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
	return components.week;
}

+ (NSInteger)weekDay{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
	return components.weekday;
}

+ (NSInteger)month{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
	return components.month;
}

+ (NSInteger)year{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
	return components.year;
}

#pragma mark - Relative dates from the current date
+ (NSDate *) dateTomorrow{
	return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday{
	return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days{
	return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days{
	return [[NSDate date] dateByAddingDays:(days * -1)];
}
- (NSDate *) dateByAddingDays: (NSInteger) dDays{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}


@end
