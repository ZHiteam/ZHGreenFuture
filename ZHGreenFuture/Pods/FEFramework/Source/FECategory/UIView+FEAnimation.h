//
//  UIView+FEAnimation.h
//  FETestCategory
//
//  Created by xxx on 13-9-11.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//
//https://github.com/inamiy/ViewUtils
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (FEAnimation)

//#优先实现UIViewAnimationWithBlocks类别的动画实现，不能实现的可以添加到此处
#pragma mark - Appear Animation
/**
 类似于系统alert弹出动画
 @param view container view
 */
- (void)appearWithAlertAnimationDuration:(CGFloat)duration;

#pragma mark - Disappear Animation
/**
	从左侧翻转出去
 */
-(void)removeWithAnimationFlipLeft;

/**
	从右侧翻转出去
 */
-(void)removeWithAnimationFlipRight;

/**
	从右侧平滑退出
 */
-(void)removeWithAnimationSlideRight;

/**
	从左侧平滑退出屏幕
 */
-(void)removeWithAnimationSlideLeft;


#pragma mark - Rotation

/**
 旋转动画
 @param start 起始弧度值
 @param end   结束弧度值
 @param duration 持续时间，默认0.25
 @param repeatCount 循环次数，若为0，则使用默认HUGE_VALF
 @param timingFunction 时间函数，默认为Linear
 */
- (void)rotateAnimationWithRadianStart:(CGFloat)start
                                   end:(CGFloat)end
                              duration:(NSTimeInterval)duration
                           repeatCount:(CGFloat)repeatCount
                        timingFunction:(CAMediaTimingFunction*)timingFunction;


#pragma mark - Bounce Animation
- (void)bounceAnimationDuration:(CGFloat)duration;

#pragma mark - HeartBeat Animation
- (void)heartBeatAnimationDuration:(CGFloat)duration fromeValue:(CGFloat)fromeValue toValue:(CGFloat)toValue;

#pragma mark - Transition

/**
 过渡动画，封装了CATransition
 @param type 动画类型，公开的有 kCATransitionFade,kCATransitionMoveIn,kCATransitionPush,kCATransitionReveal  \
 苹果私有的 @"cameraIris",@"cameraIrisHollowOpen",@"cameraIrisHollowClose", @"cube",@"alignedCube",@"flip",@"alignedFlip",@"oglFlip", \
 @"rotate",@"pageCurl",@"pageUnCurl",@"rippleEffect",@"suckEffect",@"tubey",@"spewEffect",@"genieEffect",@"unGenieEffect",@"twist",
 @"swirl",@"charminUltra",@"reflection",@"zoomyIn",@"zoomyOut",@"mapCurl",@"mapUnCurl",@"oglApplicationSuspend",
 @param subType 动画的方向kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom,
 @param duration 持续时间
 */
- (void)transitionWithType:(NSString*)type
                   subType:(NSString*)subType
                  duration:(NSTimeInterval)duration;


/**
 过渡动画，封装了CATransition
 @param type 动画类型，公开的有 kCATransitionFade,kCATransitionMoveIn,kCATransitionPush,kCATransitionReveal  \
 苹果私有的 @"cameraIris",@"cameraIrisHollowOpen",@"cameraIrisHollowClose", @"cube",@"alignedCube",@"flip",@"alignedFlip",@"oglFlip", \
 @"rotate",@"pageCurl",@"pageUnCurl",@"rippleEffect",@"suckEffect",@"tubey",@"spewEffect",@"genieEffect",@"unGenieEffect",@"twist",
 @"swirl",@"charminUltra",@"reflection",@"zoomyIn",@"zoomyOut",@"mapCurl",@"mapUnCurl",@"oglApplicationSuspend",
 @param subType 动画的方向kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom,
 @param duration 持续时间
 @param 动画开始的回调block
 @param 动画结束的回调block
 */

- (void)transitionWithType:(NSString*)type
                   subType:(NSString*)subType
                  duration:(NSTimeInterval)duration
          animationStarted:(void (^)())animationStarted
            animationEnded:(void(^)())animationEnd;


/**
	过渡动画，封装了CATransition
    @param type 动画类型，公开的有 kCATransitionFade,kCATransitionMoveIn,kCATransitionPush,kCATransitionReveal  \
            苹果私有的 @"cameraIris",@"cameraIrisHollowOpen",@"cameraIrisHollowClose", @"cube",@"alignedCube",@"flip",@"alignedFlip",@"oglFlip", \
            @"rotate",@"pageCurl",@"pageUnCurl",@"rippleEffect",@"suckEffect",@"tubey",@"spewEffect",@"genieEffect",@"unGenieEffect",@"twist",
            @"swirl",@"charminUltra",@"reflection",@"zoomyIn",@"zoomyOut",@"mapCurl",@"mapUnCurl",@"oglApplicationSuspend",
    @param subType 动画的方向kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom,
	@param duration 持续时间
	@param timingFunction 时间函数，kCAMediaTimingFunctionLinear，kCAMediaTimingFunctionEaseIn，kCAMediaTimingFunctionEaseOut，kCAMediaTimingFunctionEaseInEaseOut，kCAMediaTimingFunctionDefault
	@param startProgress 动画的开始阶段，默认为0，取值[0~1.0]
	@param endProgress 动画的结束阶段，默认为1.0，取值[0~1.0]
    @param 动画开始的回调block
    @param 动画结束的回调block
 */
- (void)transitionWithType:(NSString*)type
                   subType:(NSString*)subType
                  duration:(NSTimeInterval)duration
            timingFunction:(CAMediaTimingFunction*)timingFunction
             startProgress:(CGFloat)startProgress
               endPorgress:(CGFloat)endProgress
          animationStarted:(void (^)())animationStarted
            animationEnded:(void(^)())animationEnd;

@end
