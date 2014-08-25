//
//  CAKeyframeAnimation+AHEasing.m
//
//  Copyright (c) 2011, Auerhaus Development, LLC
//
//  This program is free software. It comes without any warranty, to
//  the extent permitted by applicable law. You can redistribute it
//  and/or modify it under the terms of the Do What The Fuck You Want
//  To Public License, Version 2, as published by Sam Hocevar. See
//  http://sam.zoy.org/wtfpl/COPYING for more details.
//

#import "CAKeyframeAnimation+FEEasing.H"

#if !defined(kFPS)
// The larger this number, the smoother the animation
#define kFPS 60
#endif

FEEasingFunction easingFunctionWithType(FEKeyframeAnimationType type)
{
        switch (type)
        {
            case FEAnimationTypeEaseInQuad:
                return QuadraticEaseIn;
            case FEAnimationTypeEaseOutQuad:
                return QuadraticEaseOut;
            case FEAnimationTypeEaseInOutQuad:
                return QuadraticEaseInOut;
            case FEAnimationTypeEaseInCubic:
                return CubicEaseIn;
            case FEAnimationTypeEaseOutCubic:
                return CubicEaseOut;
            case FEAnimationTypeEaseInOutCubic:
                return CubicEaseInOut;
            case FEAnimationTypeEaseInQuart:
                return QuarticEaseIn;
            case FEAnimationTypeEaseOutQuart:
                return QuarticEaseOut;
            case FEAnimationTypeEaseInOutQuart:
                return QuarticEaseInOut;
            case FEAnimationTypeEaseInQuint:
                return QuinticEaseIn;
            case FEAnimationTypeEaseOutQuint:
                return QuinticEaseOut;
            case FEAnimationTypeEaseInOutQuint:
                return QuinticEaseInOut;
            case FEAnimationTypeEaseInSine:
                return SineEaseIn;
            case FEAnimationTypeEaseOutSine:
                return SineEaseOut;
            case FEAnimationTypeEaseInOutSine:
                return SineEaseInOut;
            case FEAnimationTypeEaseInExpo:
                return ExponentialEaseOut;
            case FEAnimationTypeEaseOutExpo:
                return ExponentialEaseOut;
            case FEAnimationTypeEaseInOutExpo:
                return ExponentialEaseInOut;
            case FEAnimationTypeEaseInCirc:
                return CircularEaseIn;
            case FEAnimationTypeEaseOutCirc:
                return CircularEaseOut;
            case FEAnimationTypeEaseInOutCirc:
                return CircularEaseInOut;
            case FEAnimationTypeEaseInElastic:
                return ElasticEaseIn;
            case FEAnimationTypeEaseOutElastic:
                return ElasticEaseOut;
            case FEAnimationTypeEaseInOutElastic:
                return ElasticEaseInOut;
            case FEAnimationTypeEaseInBack:
                return BackEaseIn;
            case FEAnimationTypeEaseOutBack:
                return BackEaseOut;
            case FEAnimationTypeEaseInOutBack:
                return BackEaseInOut;
            case FEAnimationTypeEaseInBounce:
                return BounceEaseIn;
            case FEAnimationTypeEaseOutBounce:
                return BounceEaseOut;
            case FEAnimationTypeEaseInOutBounce:
                return BounceEaseInOut;
            default:
                return NULL;
        }
        
        return NULL;
}

@implementation CAKeyframeAnimation (AHEasing)

+ (id)animationWithKeyPath:(NSString *)path functionType:(FEKeyframeAnimationType)type fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue keyframeCount:(size_t)keyframeCount
{
    FEEasingFunction function = easingFunctionWithType(type);
    if (function) {
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:keyframeCount];
        CGFloat t = 0.0;
        CGFloat dt = 1.0 / (keyframeCount - 1);
        for(size_t frame = 0; frame < keyframeCount; ++frame, t += dt)
        {
            float value = fromValue + function(MIN(t, 1.0)) * (toValue - fromValue);
            [values addObject:[NSNumber numberWithDouble:(float)value]];
        }
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:path];
        [animation setValues:values];
        return animation;
    }
    return nil;
}

+ (id)animationWithKeyPath:(NSString *)path functionType:(FEKeyframeAnimationType)type fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{
    return [self animationWithKeyPath:path functionType:type fromValue:fromValue toValue:toValue keyframeCount:kFPS];
}

+ (id)animationWithKeyPath:(NSString *)path functionType:(FEKeyframeAnimationType)type fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint keyframeCount:(size_t)keyframeCount
{
    FEEasingFunction function = easingFunctionWithType(type);
    if (function) {
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:keyframeCount];
        CGFloat t = 0.0;
        CGFloat dt = 1.0 / (keyframeCount - 1);
        for(size_t frame = 0; frame < keyframeCount; ++frame, t += dt)
        {
            CGFloat x = fromPoint.x + function(MIN(t, 1.0)) * (toPoint.x - fromPoint.x);
            CGFloat y = fromPoint.y + function(MIN(t, 1.0)) * (toPoint.y - fromPoint.y);
    #if TARGET_OS_IPHONE
            [values addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    #else
            [values addObject:[NSValue valueWithPoint:NSMakePoint(x, y)]];
    #endif
        }
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:path];
        [animation setValues:values];
        return animation;
    }
    return nil;
}

+ (id)animationWithKeyPath:(NSString *)path functionType:(FEKeyframeAnimationType)type fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    return [self animationWithKeyPath:path functionType:type fromPoint:fromPoint toPoint:toPoint keyframeCount:kFPS];
}

+ (id)animationWithKeyPath:(NSString *)path functionType:(FEKeyframeAnimationType)type fromSize:(CGSize)fromSize toSize:(CGSize)toSize keyframeCount:(size_t)keyframeCount
{
    FEEasingFunction function = easingFunctionWithType(type);
    if (function) {
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:keyframeCount];
        CGFloat t = 0.0;
        CGFloat dt = 1.0 / (keyframeCount - 1);
        for(size_t frame = 0; frame < keyframeCount; ++frame, t += dt)
        {
            CGFloat w = fromSize.width + function(MIN(t, 1.0)) * (toSize.width - fromSize.width);
            CGFloat h = fromSize.height + function(MIN(t, 1.0)) * (toSize.height - fromSize.height);
    #if TARGET_OS_IPHONE
            [values addObject:[NSValue valueWithCGSize:CGSizeMake(w, h)]];
    #else
            [values addObject:[NSValue valueWithSize:NSMakeSize(w, h)]];
    #endif
        }
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:path];
        [animation setValues:values];
        return animation;
    }
    return nil;
}

+ (id)animationWithKeyPath:(NSString *)path functionType:(FEKeyframeAnimationType)type fromSize:(CGSize)fromSize toSize:(CGSize)toSize
{
    return [self animationWithKeyPath:path functionType:type fromSize:fromSize toSize:toSize keyframeCount:kFPS];
}

#pragma mark - AnimationPath


- (UIBezierPath *)animationPath
{
    NSArray *values = self.values;
    const double numValues = values.count;
    double minValue = HUGE_VALF, maxValue = 0;
    for (NSNumber *number in values)
    {
        const double v = [number doubleValue];
        if (v < minValue)
            minValue = v;
        else if (v > maxValue)
            maxValue = v;
    }
    // normalize everything to [0, 1]
    const double difference = maxValue - minValue,
    xDelta = 1 / numValues;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSUInteger i = 0;
    for (NSNumber *number in values){
        const double v = [number doubleValue];
        CGPoint p = CGPointMake(i * xDelta, (v - minValue) / difference);
        if (i == 0)
            [path moveToPoint:p];
        else
            [path addLineToPoint:p];
        i++;
    }
    return path;
}

@end
