//
//  DEBUG.h
//  jinliyu
//
//  Created by QFish on 8/27/12.
//  Copyright (c) 2012 ilvu.me. All rights reserved.
//
	
#import <Foundation/Foundation.h>


#pragma mark - FELOG FEPO FEPI FEPF FEPS FEPR

#define  __DEBUG__          //控制是否开启log
#define FE_LOG_LEVEL_MAX   FE_LOG_LEVEL_INFO   //控制log级别

//打印所有函数
#define FE_LOG_LEVEL_ALL      10
//打印一般函数内信息
#define FE_LOG_LEVEL_INFO     8
//打印警告
#define FE_LOG_LEVEL_WARNING  3
//严重错误信息
#define FE_LOG_LEVEL_ERROR    1

#ifndef FE_LOG_LEVEL_MAX
#define FE_LOG_LEVEL_MAX FE_LOG_LEVEL_ERROR
#endif

// Log-level based logging macros.
#if FE_LOG_LEVEL_ERROR <= FE_LOG_LEVEL_MAX
#define FEERROR(xx, ...)  FELOG(xx, ##__VA_ARGS__)
#else
#define FEERROR(xx, ...)  ((void)0)
#endif // #if FE_LOG_LEVEL_ERROR <= FE_LOG_LEVEL_MAX

#if FE_LOG_LEVEL_WARNING <= FE_LOG_LEVEL_MAX
#define FEWARNING(xx, ...)  FELOG(xx, ##__VA_ARGS__)
#else
#define FEWARNING(xx, ...)  ((void)0)
#endif // #if FE_LOG_LEVEL_WARNING <= FE_LOG_LEVEL_MAX

#if FE_LOG_LEVEL_INFO <= FE_LOG_LEVEL_MAX
#define FEINFO(xx, ...)  FELOG(xx, ##__VA_ARGS__)
#else
#define FEINFO(xx, ...)  ((void)0)
#endif // #if FE_LOG_LEVEL_INFO <= FE_LOG_LEVEL_MAX

#ifdef __DEBUG__


#define FELOG(format, ...)                   \
        NSLog(@"%s:%d >>>%@",               \
        __PRETTY_FUNCTION__, __LINE__,       \
        [NSString stringWithFormat:format, ## __VA_ARGS__])

#define FEPO(o) FELOG(@"%@", (o))
#define FEPI(o) FELOG(@"%d", (o))
#define FEPF(o) FELOG(@"%f", (o))
#define FEPS(o) FELOG(@"CGSize: {%.0f, %.0f}", (o).width, (o).height)
#define FEPR(o) FELOG(@"NSRect: {{%.0f, %.0f}, {%.0f, %.0f}}", (o).origin.x, (o).origin.x, (o).size.width, (o).size.height)


#define FESTART                \
        NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
#define FEEND(msg)              \
        FELOG([NSString stringWithFormat:"%@ Time = %f", msg, \
        [NSDate timeIntervalSinceReferenceDate]-start]);
#else

#define FELOG
#define FEPO
#define FEPI
#define FEPF
#define FEPS
#define FEPR

#endif


#pragma mark - FELOGFILE 记录log到文件
#define __LOG_FILE__       //控制是否写log到文件
#define LOG_PATH    [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FerrariLog.log"] UTF8String]

//控制是否写log到文件
#ifdef __LOG_FILE__

#define FELOGFILE(format, ...)  do\
{\
FILE * pFELog = NULL; \
if((pFELog = fopen(LOG_PATH, "a+")))\
{\
printf(format, ##__VA_ARGS__);\
printf("\n");\
fprintf(pFELog, format, ##__VA_ARGS__);\
fprintf(pFELog, "\n"); \
fclose(pFELog);\
}\
}while(0)

#endif


