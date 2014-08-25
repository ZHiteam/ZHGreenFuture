//
//  FEMacroDefine.h
//  FETestCategory
//
//  Created by xxx on 13-9-16.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEEnumToString.h"
#import "FEDebug.h"

/**
 * Add this macro before each category implementation, so we don't have to use
 * -all_load or -force_load to load object files from static libraries that only contain
 * categories and no classes.
 * See http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html for more info.
 */
#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

//屏幕宽度，支持横竖屏
#define FEScreenWidth (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
//屏幕高度，支持横竖屏
#define FEScreenHeight (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

//角度值转弧度值
#define FEDEGREES_TO_RADIANS(x)         (x)/180.0*M_PI
//弧度值转角度值
#define FERADIANS_TO_DEGREES(x)         (x)/M_PI*180.0
//测试index是否是NSArray的有效索引
#define FEValidateIndex(array,index)    (index>=0)&&(index<[array count])
//安全访问NSArray对应的index，索引判断
#define FEObjectAtIndex(array,index)    ((array!=nil)&&(index>=0)&&(index<[array count])) ? [array objectAtIndex:index] : nil
//安全的插入一个object
#define FEAddObject(mutArray,object)    (mutArray&&object) ? [mutArray addObject:object] : nil;
//CGSize 的拉伸
#define CGSizeScale(size, scale) CGSizeMake(size.width * scale, size.height * scale)
//CGRect 的拉伸
#define CGRectScale(rect, scale) CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale)
//对CGRect 元素取整
#define CGRectRoundf(CGRect)     CGRectMake(roundf(rect.origin.x), roundf(rect.origin.y), roundf(rect.size.width), roundf(rect.size.height))

#pragma  mark - 方便编程

#define FEInteger(n)        [NSNumber numberWithInteger:n]
//构建NSString
#define FEString(fmt, ...) \
[NSString stringWithFormat:(fmt), ## __VA_ARGS__]
//构建NSDictionary
#define FEDict(key, ...) \
[NSDictionary dictionaryWithKeysAndObjectsMaybeNil: key, ## __VA_ARGS__, nil]

//CGRect转为NSString
#define FECGRectToString(rect)   NSStringFromRect(NSRectFromCGRect(rect))
//CGSize转为NSString
#define FECGSizeToString(size)   NSStringFromSize(NSSizeFromCGSize(size))
//CGPoint转为NSString
#define FECGPointToString(point) NSStringFromPoint(NSPointFromCGPoint(point))


#pragma  mark - 实现枚举值转为字符串，反之不行（见FEEnumToString.h）
//实现枚举值转为字符串，反之不行
/** 说明如下：
 1）对于如下枚举
 typedef NS_ENUM(NSInteger, FEKeyframeAnimationType)
 {
 FEAnimationTypeEaseInQuad = 0,
 FEAnimationTypeEaseOutQuad,
 };
 
 2）添加如下内容，enumStrEx 和op 都可以是任意的
 #define enumStrEx(op)  op(FEAnimationTypeEaseInQuad), op(FEAnimationTypeEaseOutQuad)
 FEEnumStringArray(FEKeyframeAnimationType, enumStrEx);
 
 3）使用时，使用如下宏，FEAnimationTypeEaseInQuad 表示索引，若超出范围则会有warning
 FEEnumString(FEKeyframeAnimationType, FEAnimationTypeEaseInQuad)
 */
#define FEToString(VALUE)                     @ # VALUE
#define FEDefineEnumToStrArray(enumType, xxxx)  static NSString* array##enumType[] ={xxxx(FEToString)}
#define FEEnumString(enumType,index)            array##enumType[index]


#define FEALERTVIEW(TARGET,TITLE,MESSAGE,CANCELBUTTON,OTHERBUTTONS...) {UIAlertView *av =[[UIAlertView alloc] initWithTitle:TITLE message:MESSAGE delegate:TARGET cancelButtonTitle:CANCELBUTTON otherButtonTitles:OTHERBUTTONS];[av show];av=nil;}
