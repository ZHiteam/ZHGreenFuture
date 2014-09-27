//
//  UIColor+FEExtension.h
//  FETestCategory
//
//  Created by xxx on 13-9-22.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FEExtension)
- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)alpha;
- (CGFloat)white;
// Arithmetic operations on the color
- (UIColor *)colorByMultiplyingByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)       colorByAddingRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *) colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)  colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (UIColor *)colorByMultiplyingBy:(CGFloat)f;
- (UIColor *)       colorByAdding:(CGFloat)f;
- (UIColor *) colorByLighteningTo:(CGFloat)f;
- (UIColor *)  colorByDarkeningTo:(CGFloat)f;

- (UIColor *)colorByMultiplyingByColor:(UIColor *)color;
- (UIColor *)       colorByAddingColor:(UIColor *)color;
- (UIColor *) colorByLighteningToColor:(UIColor *)color;
- (UIColor *)  colorByDarkeningToColor:(UIColor *)color;

// Related colors
- (UIColor *)contrastingColor;			// A good contrasting color: will be either black or white
- (UIColor *)complementaryColor;		// A complementary color that should look good with this color
- (NSArray*)triadicColors;				// Two colors that should look good with this color
- (NSArray*)analogousColorsWithStepAngle:(CGFloat)stepAngle pairCount:(int)pairs;	// Multiple pairs of colors

- (UIColor *)lighterColor;
- (UIColor *)darkerColor;

@end

@interface UIColor (FEiOS7Color)
// Plain Colors
+ (instancetype)iOS7redColor;
+ (instancetype)iOS7orangeColor;
+ (instancetype)iOS7yellowColor;
+ (instancetype)iOS7greenColor;
+ (instancetype)iOS7lightBlueColor;
+ (instancetype)iOS7darkBlueColor;
+ (instancetype)iOS7purpleColor;
+ (instancetype)iOS7pinkColor;
+ (instancetype)iOS7darkGrayColor;
+ (instancetype)iOS7lightGrayColor;

// Gradient Colors
+ (instancetype)iOS7redGradientStartColor;
+ (instancetype)iOS7redGradientEndColor;

+ (instancetype)iOS7orangeGradientStartColor;
+ (instancetype)iOS7orangeGradientEndColor;

+ (instancetype)iOS7yellowGradientStartColor;
+ (instancetype)iOS7yellowGradientEndColor;

+ (instancetype)iOS7greenGradientStartColor;
+ (instancetype)iOS7greenGradientEndColor;

+ (instancetype)iOS7tealGradientStartColor;
+ (instancetype)iOS7tealGradientEndColor;

+ (instancetype)iOS7blueGradientStartColor;
+ (instancetype)iOS7blueGradientEndColor;

+ (instancetype)iOS7violetGradientStartColor;
+ (instancetype)iOS7violetGradientEndColor;

+ (instancetype)iOS7magentaGradientStartColor;
+ (instancetype)iOS7magentaGradientEndColor;

+ (instancetype)iOS7blackGradientStartColor;
+ (instancetype)iOS7blackGradientEndColor;

+ (instancetype)iOS7silverGradientStartColor;
+ (instancetype)iOS7silverGradientEndColor;
@end

@interface UIColor (FEHex)
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*)colorWithHex:(NSInteger)hexValue;
+ (UIColor*)colorWithHexString:(NSString*)hexString;
@end



