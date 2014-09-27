//
//  FEEasingFunctions.h
//  FEEasingFunctions
//
//  Created by xxx on 13-9-29.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FEEasingFunctions.h"
#import "FEMacroDefine.h"

typedef NS_ENUM(NSInteger, FEKeyframeAnimationType)
{
    FEAnimationTypeEaseInQuad = 0,
    FEAnimationTypeEaseOutQuad,
    FEAnimationTypeEaseInOutQuad,
    FEAnimationTypeEaseInCubic,
    FEAnimationTypeEaseOutCubic,
    FEAnimationTypeEaseInOutCubic,
    FEAnimationTypeEaseInQuart,
    FEAnimationTypeEaseOutQuart,
    FEAnimationTypeEaseInOutQuart,
    FEAnimationTypeEaseInQuint,
    FEAnimationTypeEaseOutQuint,
    FEAnimationTypeEaseInOutQuint,
    FEAnimationTypeEaseInSine,
    FEAnimationTypeEaseOutSine,
    FEAnimationTypeEaseInOutSine,
    FEAnimationTypeEaseInExpo,
    FEAnimationTypeEaseOutExpo,
    FEAnimationTypeEaseInOutExpo,
    FEAnimationTypeEaseInCirc,
    FEAnimationTypeEaseOutCirc,
    FEAnimationTypeEaseInOutCirc,
    FEAnimationTypeEaseInElastic,
    FEAnimationTypeEaseOutElastic,
    FEAnimationTypeEaseInOutElastic,
    FEAnimationTypeEaseInBack,
    FEAnimationTypeEaseOutBack,
    FEAnimationTypeEaseInOutBack,
    FEAnimationTypeEaseInBounce,
    FEAnimationTypeEaseOutBounce,
    FEAnimationTypeEaseInOutBounce,
    FEAnimationTypeAll,
    FEAnimationTypeCount
} ;



#define enumStrEx(op)  op(FEAnimationTypeEaseInQuad), op(FEAnimationTypeEaseOutQuad),op(FEAnimationTypeEaseInOutQuad),op(FEAnimationTypeEaseInCubic), op(FEAnimationTypeEaseOutCubic), \
 op(FEAnimationTypeEaseInOutCubic),      \
 op(FEAnimationTypeEaseInQuart),      \
 op(FEAnimationTypeEaseOutQuart),      \
 op(FEAnimationTypeEaseInOutQuart),      \
 op(FEAnimationTypeEaseInQuint),      \
 op(FEAnimationTypeEaseOutQuint),      \
 op(FEAnimationTypeEaseInOutQuint),      \
 op(FEAnimationTypeEaseInSine),      \
 op(FEAnimationTypeEaseOutSine),      \
 op(FEAnimationTypeEaseInOutSine),      \
 op(FEAnimationTypeEaseInExpo),      \
 op(FEAnimationTypeEaseOutExpo),      \
 op(FEAnimationTypeEaseInOutExpo),      \
 op(FEAnimationTypeEaseInCirc),      \
 op(FEAnimationTypeEaseOutCirc),      \
 op(FEAnimationTypeEaseInOutCirc),      \
 op(FEAnimationTypeEaseInElastic),      \
 op(FEAnimationTypeEaseOutElastic),      \
 op(FEAnimationTypeEaseInOutElastic),      \
 op(FEAnimationTypeEaseInBack),      \
 op(FEAnimationTypeEaseOutBack),      \
 op(FEAnimationTypeEaseInOutBack),      \
 op(FEAnimationTypeEaseInBounce),      \
 op(FEAnimationTypeEaseOutBounce),      \
 op(FEAnimationTypeEaseInOutBounce)

FEDefineEnumToStrArray(FEKeyframeAnimationType, enumStrEx);

@interface CAKeyframeAnimation (FEEasing)

// Factory method to create a keyframe animation for animating a scalar value , with kFPS = 60
+ (id)animationWithKeyPath:(NSString *)path functionType:(FEKeyframeAnimationType)type fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue keyframeCount:(size_t)keyframeCount;

// Factory method to create a keyframe animation for animating a scalar value, with kFPS = 60
+ (id)animationWithKeyPath:(NSString *)path functionType:(FEKeyframeAnimationType)type fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue;

// Factory method to create a keyframe animation for animating between two points , with kFPS = 60
+ (id)animationWithKeyPath:(NSString *)path functionType:(FEKeyframeAnimationType)type fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint keyframeCount:(size_t)keyframeCount;

// Factory method to create a keyframe animation for animating between two points,  with kFPS = 60
+ (id)animationWithKeyPath:(NSString *)path functionType:(FEKeyframeAnimationType)type fromPoint:(CGPoint)fromValue toPoint:(CGPoint)toValue;

// Factory method to create a keyframe animation for animating between two sizes,  with kFPS = 60
+ (id)animationWithKeyPath:(NSString *)path functionType:(FEKeyframeAnimationType)type fromSize:(CGSize)fromSize toSize:(CGSize)toSize keyframeCount:(size_t)keyframeCount;

// Factory method to create a keyframe animation for animating between two sizes,  with kFPS = 60
+ (id)animationWithKeyPath:(NSString *)path functionType:(FEKeyframeAnimationType)type fromSize:(CGSize)fromValue toSize:(CGSize)toValue;

/**
	返回CAKeyframeAnimation的values 构建的path，值归约到[0,1]
	@returns 贝塞尔曲线
 */
- (UIBezierPath *)animationPath;

@end
