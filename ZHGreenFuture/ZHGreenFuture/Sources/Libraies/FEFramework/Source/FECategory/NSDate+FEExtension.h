//
//  NSDate+FEExtension.h
//  FETestCategory
//
//  Created by xxx on 13-10-9.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FEExtension)
/**
	从1970年到现在的毫秒数
	@returns 毫秒数
 */
+ (long long)millisecondsSince1970;

/**
	从1970年到现在的秒数
	@returns 秒数
 */
+ (long long)secondsSince1970;

//kCFDateFormatterNoStyle = 0,       // 无输出
//kCFDateFormatterShortStyle = 1,    // 13-10-9 下午3:57
//kCFDateFormatterMediumStyle = 2,   // 2013年10月9日 下午3:57:48
//kCFDateFormatterLongStyle = 3,     // 2013年10月9日 GMT+8下午3:57:51
//kCFDateFormatterFullStyle = 4      // 2013年10月9日 星期三 中国标准时间下午3:59:42

/// modify by kongkong
+ (NSString*)dateWithDateFormatStyle:(NSDateFormatterStyle)dateFormatStyle;

//@"yyyy-MM-dd a HH:mm:ss EEEE";
+ (NSString*)dateWithCustomFormat;

#pragma mark - Decomposing Dates
//https://github.com/erica/NSDate-Extensions/blob/master/NSDate-Utilities.h
+ (NSInteger)seconds;
+ (NSInteger)minute;
+ (NSInteger)hour;
+ (NSInteger)nearestHour;
+ (NSInteger)day;
+ (NSInteger)week;
+ (NSInteger)weekDay;
+ (NSInteger)month;
+ (NSInteger)year;

#pragma mark - Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;

@end
