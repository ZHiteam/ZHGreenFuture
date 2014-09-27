//
//  UIColor+FEExtension.m
//  FETestCategory
//
//  Created by xxx on 13-9-22.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import "UIColor+FEExtension.h"
#import <QuartzCore/QuartzCore.h>

@implementation  UIColor (FEExtension)
#pragma mark - Private Method
- (CGColorSpaceModel)colorSpaceModel {
	return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}
- (BOOL)canProvideRGBComponents {
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelRGB:
		case kCGColorSpaceModelMonochrome:
			return YES;
		default:
			return NO;
	}
}

- (CGFloat)luminance {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use luminance");
    
	CGFloat r,g,b;
	if (![self red:&r green:&g blue:&b alpha:nil]) return 0.0f;
	
	// http://en.wikipedia.org/wiki/Luma_(video)
	// Y = 0.2126 R + 0.7152 G + 0.0722 B
	
	return r*0.2126f + g*0.7152f + b*0.0722f;
}

- (BOOL)red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
	const CGFloat *components = CGColorGetComponents(self.CGColor);
	
	CGFloat r,g,b,a;
	
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelMonochrome:
			r = g = b = components[0];
			a = components[1];
			break;
		case kCGColorSpaceModelRGB:
			r = components[0];
			g = components[1];
			b = components[2];
			a = components[3];
			break;
		default:	// We don't know how to handle this model
			return NO;
	}
	
	if (red) *red = r;
	if (green) *green = g;
	if (blue) *blue = b;
	if (alpha) *alpha = a;
	
	return YES;
}

- (BOOL)hue:(CGFloat *)hue saturation:(CGFloat *)saturation brightness:(CGFloat *)brightness alpha:(CGFloat *)alpha {
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return NO;
	
	[UIColor red:r green:g blue:b toHue:hue saturation:saturation brightness:brightness];
	
	if (alpha) *alpha = a;
	
	return YES;
}

+ (void)red:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b toHue:(CGFloat *)pH saturation:(CGFloat *)pS brightness:(CGFloat *)pV {
	CGFloat h,s,v;
	
	// From Foley and Van Dam
	
	CGFloat max = MAX(r, MAX(g, b));
	CGFloat min = MIN(r, MIN(g, b));
	
	// Brightness
	v = max;
	
	// Saturation
	s = (max != 0.0f) ? ((max - min) / max) : 0.0f;
	
	if (s == 0.0f) {
		// No saturation, so undefined hue
		h = 0.0f;
	} else {
		// Determine hue
		CGFloat rc = (max - r) / (max - min);		// Distance of color from red
		CGFloat gc = (max - g) / (max - min);		// Distance of color from green
		CGFloat bc = (max - b) / (max - min);		// Distance of color from blue
		
		if (r == max) h = bc - gc;					// resulting color between yellow and magenta
		else if (g == max) h = 2 + rc - bc;			// resulting color between cyan and yellow
		else /* if (b == max) */ h = 4 + gc - rc;	// resulting color between magenta and cyan
		
		h *= 60.0f;									// Convert to degrees
		if (h < 0.0f) h += 360.0f;					// Make non-negative
	}
	
	if (pH) *pH = h;
	if (pS) *pS = s;
	if (pV) *pV = v;
}

#pragma mark - Public  Method
- (CGFloat)red {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -red");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}

- (CGFloat)green {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -green");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
	return c[1];
}

- (CGFloat)blue {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blue");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
	return c[2];
}

- (CGFloat)alpha {
	return CGColorGetAlpha(self.CGColor);
}

- (CGFloat)white {
	NSAssert(self.colorSpaceModel == kCGColorSpaceModelMonochrome, @"Must be a Monochrome color to use -white");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}


#pragma mark Arithmetic operations

- (UIColor *)colorByLuminanceMapping {
	return [UIColor colorWithWhite:self.luminance alpha:1.0f];
}

- (UIColor *)colorByMultiplyingByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
    
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
    
	return [UIColor colorWithRed:MAX(0.0, MIN(1.0, r * red))
						   green:MAX(0.0, MIN(1.0, g * green))
							blue:MAX(0.0, MIN(1.0, b * blue))
						   alpha:MAX(0.0, MIN(1.0, a * alpha))];
}

- (UIColor *)colorByAddingRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [UIColor colorWithRed:MAX(0.0, MIN(1.0, r + red))
						   green:MAX(0.0, MIN(1.0, g + green))
							blue:MAX(0.0, MIN(1.0, b + blue))
						   alpha:MAX(0.0, MIN(1.0, a + alpha))];
}

- (UIColor *)colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
    
	return [UIColor colorWithRed:MAX(r, red)
						   green:MAX(g, green)
							blue:MAX(b, blue)
						   alpha:MAX(a, alpha)];
}

- (UIColor *)colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [UIColor colorWithRed:MIN(r, red)
						   green:MIN(g, green)
							blue:MIN(b, blue)
						   alpha:MIN(a, alpha)];
}

- (UIColor *)colorByMultiplyingBy:(CGFloat)f {
	return [self colorByMultiplyingByRed:f green:f blue:f alpha:1.0f];
}

- (UIColor *)colorByAdding:(CGFloat)f {
	return [self colorByMultiplyingByRed:f green:f blue:f alpha:0.0f];
}

- (UIColor *)colorByLighteningTo:(CGFloat)f {
	return [self colorByLighteningToRed:f green:f blue:f alpha:0.0f];
}

- (UIColor *)colorByDarkeningTo:(CGFloat)f {
	return [self colorByDarkeningToRed:f green:f blue:f alpha:1.0f];
}

- (UIColor *)colorByMultiplyingByColor:(UIColor *)color {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [self colorByMultiplyingByRed:r green:g blue:b alpha:1.0f];
}

- (UIColor *)colorByAddingColor:(UIColor *)color {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [self colorByAddingRed:r green:g blue:b alpha:0.0f];
}

- (UIColor *)colorByLighteningToColor:(UIColor *)color {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
    
	return [self colorByLighteningToRed:r green:g blue:b alpha:0.0f];
}

- (UIColor *)colorByDarkeningToColor:(UIColor *)color {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
	
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
	
	return [self colorByDarkeningToRed:r green:g blue:b alpha:1.0f];
}

#pragma mark Complementary Colors, etc

// Pick a color that is likely to contrast well with this color
- (UIColor *)contrastingColor {
	return (self.luminance > 0.5f) ? [UIColor blackColor] : [UIColor whiteColor];
}

// Pick the color that is 180 degrees away in hue
- (UIColor *)complementaryColor {
	
	// Convert to HSB
	CGFloat h,s,v,a;
	if (![self hue:&h saturation:&s brightness:&v alpha:&a]) return nil;
    
	// Pick color 180 degrees away
	h += 180.0f;
	if (h > 360.f) h -= 360.0f;
	
	// Create a color in RGB
	return [UIColor colorWithHue:h saturation:s brightness:v alpha:a];
}

// Pick two colors more colors such that all three are equidistant on the color wheel
// (120 degrees and 240 degress difference in hue from self)
- (NSArray*)triadicColors {
	return [self analogousColorsWithStepAngle:120.0f pairCount:1];
}

// Pick n pairs of colors, stepping in increasing steps away from this color around the wheel
- (NSArray*)analogousColorsWithStepAngle:(CGFloat)stepAngle pairCount:(int)pairs {
	// Convert to HSB
	CGFloat h,s,v,a;
	if (![self hue:&h saturation:&s brightness:&v alpha:&a]) return nil;
	
	NSMutableArray* colors = [NSMutableArray arrayWithCapacity:pairs * 2];
	
	if (stepAngle < 0.0f)
		stepAngle *= -1.0f;
	
	for (int i = 1; i <= pairs; ++i) {
		CGFloat a = fmodf(stepAngle * i, 360.0f);
		
		CGFloat h1 = fmodf(h + a, 360.0f);
		CGFloat h2 = fmodf(h + 360.0f - a, 360.0f);
		
		[colors addObject:[UIColor colorWithHue:h1 saturation:s brightness:v alpha:a]];
		[colors addObject:[UIColor colorWithHue:h2 saturation:s brightness:v alpha:a]];
	}
	
	return [colors copy];
}

#pragma mark - Darker & Lighter Color
- (UIColor *)lighterColor {
    CGFloat hue, saturation, brightness, alpha, white;
    
    UIColor *lighterColor = self;
    
    if ([self getHue:&hue
          saturation:&saturation
          brightness:&brightness
               alpha:&alpha]) {
        lighterColor = [UIColor colorWithHue:hue
                                  saturation:saturation * 0.5
                                  brightness:brightness
                                       alpha:alpha];
    }
    else if ([self getWhite:&white alpha:&alpha]) {
        lighterColor = [UIColor colorWithWhite:white * 1.5
                                         alpha:alpha];
    }
    else if ([self isEqual:[UIColor scrollViewTexturedBackgroundColor]]) {
        lighterColor = [UIColor underPageBackgroundColor];
    }
    
    return lighterColor;
}

- (UIColor *)darkerColor {
    CGFloat hue, saturation, brightness, alpha, white;
    
    UIColor *darkerColor = self;
    
    if ([self getHue:&hue
          saturation:&saturation
          brightness:&brightness
               alpha:&alpha]) {
        darkerColor = [UIColor colorWithHue:hue
                                 saturation:saturation
                                 brightness:brightness * 0.5
                                      alpha:alpha];
    }
    else if ([self getWhite:&white alpha:&alpha]) {
        darkerColor = [UIColor colorWithWhite:white * 0.5
                                        alpha:alpha];
    }
    else if ([self isEqual:[UIColor underPageBackgroundColor]]) {
        darkerColor = [UIColor scrollViewTexturedBackgroundColor];
    }
    
    return darkerColor;
}
@end

@implementation UIColor (FEiOS7Color)
#pragma mark - Plain Colors
+ (instancetype)iOS7redColor;
{
    return [UIColor colorWithRed:1.0f green:0.22f blue:0.22f alpha:1.0f];
}

+ (instancetype)iOS7orangeColor;
{
    return [UIColor colorWithRed:1.0f green:0.58f blue:0.21f alpha:1.0f];
}

+ (instancetype)iOS7yellowColor;
{
    return [UIColor colorWithRed:1.0f green:0.79f blue:0.28f alpha:1.0f];
}

+ (instancetype)iOS7greenColor;
{
    return [UIColor colorWithRed:0.27f green:0.85f blue:0.46f alpha:1.0f];
}

+ (instancetype)iOS7lightBlueColor;
{
    return [UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f];
}

+ (instancetype)iOS7darkBlueColor;
{
    return [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
}

+ (instancetype)iOS7purpleColor;
{
    return [UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f];
}

+ (instancetype)iOS7pinkColor;
{
    return [UIColor colorWithRed:1.0f green:0.17f blue:0.34f alpha:1.0f];
}

+ (instancetype)iOS7darkGrayColor;
{
    return [UIColor colorWithRed:0.56f green:0.56f blue:0.58f alpha:1.0f];
}

+ (instancetype)iOS7lightGrayColor;
{
    return [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f];
}

#pragma mark - Gradient Colors

+ (instancetype)iOS7redGradientStartColor;
{
    return [UIColor colorWithRed:1.0f green:0.37f blue:0.23f alpha:1.0f];
}

+ (instancetype)iOS7redGradientEndColor;
{
    return [UIColor colorWithRed:1.0f green:0.16f blue:0.41f alpha:1.0f];
}

+ (instancetype)iOS7orangeGradientStartColor;
{
    return [UIColor colorWithRed:1.0f green:0.58f blue:0.0f alpha:1.0f];
}

+ (instancetype)iOS7orangeGradientEndColor;
{
    return [UIColor colorWithRed:1.0f green:0.37f blue:0.23f alpha:1.0f];
}

+ (instancetype)iOS7yellowGradientStartColor;
{
    return [UIColor colorWithRed:1.0f green:0.86f blue:0.3f alpha:1.0f];
}

+ (instancetype)iOS7yellowGradientEndColor;
{
    return [UIColor colorWithRed:1.0f green:0.8f blue:0.01f alpha:1.0f];
}

+ (instancetype)iOS7greenGradientStartColor;
{
    return [UIColor colorWithRed:0.53f green:0.99f blue:0.44f alpha:1.0f];
}

+ (instancetype)iOS7greenGradientEndColor;
{
    return [UIColor colorWithRed:0.04f green:0.83f blue:0.09f alpha:1.0f];
}

+ (instancetype)iOS7tealGradientStartColor;
{
    return [UIColor colorWithRed:0.32f green:0.93f blue:0.78f alpha:1.0f];
}

+ (instancetype)iOS7tealGradientEndColor;
{
    return [UIColor colorWithRed:0.35f green:0.78f blue:0.98f alpha:1.0f];
}

+ (instancetype)iOS7blueGradientStartColor;
{
    return [UIColor colorWithRed:0.10f green:0.84f blue:0.99f alpha:1.0f];
}

+ (instancetype)iOS7blueGradientEndColor;
{
    return [UIColor colorWithRed:0.11f green:0.38f blue:0.94f alpha:1.0f];
}

+ (instancetype)iOS7violetGradientStartColor;
{
    return [UIColor colorWithRed:0.78f green:0.27f blue:0.99f alpha:1.0f];
}

+ (instancetype)iOS7violetGradientEndColor;
{
    return [UIColor colorWithRed:0.35f green:0.34f blue:0.84f alpha:1.0f];
}

+ (instancetype)iOS7magentaGradientStartColor;
{
    return [UIColor colorWithRed:0.94f green:0.30f blue:0.71f alpha:1.0f];
}

+ (instancetype)iOS7magentaGradientEndColor;
{
    return [UIColor colorWithRed:0.78f green:0.26f blue:0.99f alpha:1.0f];
}

+ (instancetype)iOS7blackGradientStartColor;
{
    return [UIColor colorWithRed:0.29f green:0.29f blue:0.29f alpha:1.0f];
}

+ (instancetype)iOS7blackGradientEndColor;
{
    return [UIColor colorWithRed:0.17f green:0.17f blue:0.17f alpha:1.0f];
}

+ (instancetype)iOS7silverGradientStartColor;
{
    return [UIColor colorWithRed:0.86f green:0.87f blue:0.87f alpha:1.0f];
}

+ (instancetype)iOS7silverGradientEndColor;
{
    return [UIColor colorWithRed:0.54f green:0.55f blue:0.56f alpha:1.0f];
}

@end

@implementation UIColor (FEHex)
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}
+ (UIColor*)colorWithHexString:(NSString*)hexString{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
        if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
            if ([cString length] != 6) return [UIColor grayColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
    
}
+ (UIColor*)colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

@end
