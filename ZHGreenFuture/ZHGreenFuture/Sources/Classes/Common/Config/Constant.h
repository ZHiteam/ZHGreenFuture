//
//  Constant.h
//  GreenFuture
//
//  Created by elvis on 8/27/14.
//  Copyright (c) 2014 HKWF. All rights reserved.
//

#ifndef GreenFuture_Constant_h
#define GreenFuture_Constant_h

/******************** 程序信息 **************************************************/
/// 版本号
#define VERSION         [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]
#define BUILD           [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey]
#define VERSION_KEY     @"versionKey"
#define CLIENT_IPHONE   @"2"

#define CURRENT_LANG    [[NSLocale preferredLanguages]objectAtIndex:0]

/// 屏幕方向
#define INTERFACE_ORIENTATIONS  UIInterfaceOrientationMaskPortrait

/// iPhone5
#define IS_IPHONE5  CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136))

/// iOS版本判断
#define IOS_VERSION_6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IOS_VERSION_5 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IOS_VERSION_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

/// 配置文件
#define ROOT_FLODER             @"ZHiteam"
#define SYS_CONFIG_PATH         @"system.config"
#define USER_CONFIG_PATH        @"user.config"
#define SSL_CERT                @"client.encrypt"
#define SERVER_CONFIG           @"server.config"

/// AES加密key和密文
#define DATA_SEC_KEY            @"ZHiteam4GreenFuture"

/******************** 宏函数 **************************************************/
#define FONT(fontsize)          [UIFont systemFontOfSize : fontsize]
#define BOLD_FONT(fontsize)     [UIFont fontWithName : @"HelveticaNeue-Bold" size : fontsize]

#define RGBA(r, g, b, a)   [UIColor colorWithRed : r / 255.0f green : g / 255.0f blue : b / 255.0f alpha : a]
#define RGB(r, g, b)       RGBA(r, g, b, 1.0f)

#define trim(str) [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
#define isEmptyString(str) ([str isKindOfClass:[NSNull class]] || !str || [trim(str) isEqualToString:@""] || [str isEqualToString:@"<null>"])

#define ADDOBJECT(object,key,dic) (object==nil)?(0==0):[dic setObject:object forKey:key];

#ifdef DEBUG
#define ZHLOG NSLog
#else
#define ZHLOG (void)
#endif


/******************** key值配置 **************************************************/
#define k_ROOT_PATH         @"rootpath"                     /// 程序数据根路径
#define HTTP_SERVER         @"httpserver"                   /// http服务器地址

/******************** 常量值配置 **************************************************/

///UI常量////////////////////////////////////////////////////////////////////////////////////////
#define ANIMATE_DURATION_NOTICE  1.5f
#define ANIMATE_DURATION     0.3f

#define STATUS_BAR_HEIGHT       ((IOS_VERSION_7)?20.0f:0)
#define NAVIGATION_ITEM_HEIGHT  44.0f
#define NAVIGATION_BAR_HEIGHT   ((IOS_VERSION_7)?(STATUS_BAR_HEIGHT + NAVIGATION_ITEM_HEIGHT):44.0f)


#define TAB_BAR_HEIGHT          44.0f
#define FULL_FRAME          [UIScreen mainScreen].applicationFrame
#define FULL_WIDTH          FULL_FRAME.size.width
#define FULL_HEIGHT         FULL_FRAME.size.height

#define k_BASE_THEME_PATH   @"baseThemePath"                /// 主题路径

#endif
