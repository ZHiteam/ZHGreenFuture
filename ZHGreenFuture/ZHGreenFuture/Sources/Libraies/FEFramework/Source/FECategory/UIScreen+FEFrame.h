//
//  UIScreen+FEFrame.h
//  FETestCategory
//
//  Created by xxx on 13-9-16.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (FEFrame)


/**
	除去状态栏,导航条的高度
    @returns 除去状态栏,导航条的高度
 */
+ (CGFloat)bodyHeight;


/**
    整个手机屏幕的宽度
	@returns 整个手机屏幕的宽度
 */
+ (CGFloat)screenWidth;

/**
	整个手机屏幕的高度
	@returns 整个手机屏幕的高度
 */
+ (CGFloat)screenHeight;


/**
	状态栏高度
	@returns 状态栏高度
 */
+ (CGFloat)statusBarHeight;

/**
	是否是视网膜屏
	@returns YES，视网膜屏，NO，非视网膜屏
 */
+ (BOOL)isRetina;

@end
