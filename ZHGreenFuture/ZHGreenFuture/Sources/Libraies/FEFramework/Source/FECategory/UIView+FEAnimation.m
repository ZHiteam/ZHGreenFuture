//
//  UIView+FEAnimation.m
//  FETestCategory
//
//  Created by xxx on 13-9-11.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import "UIView+FEAnimation.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <QuartzCore/QuartzCore.h>

static char kAnimationStartedBlockKey;
static char kAnimationEndedBlockKey;

#define  kScaleAnimationKey             @"ScaleAnimationKey"
#define  kBounceAnimationKey            @"BounceAnimationKey"

@implementation UIView (FEAnimation)


#pragma mark - Appear Animation

/**
 类似于系统alert弹出动画
 @param view container view
 */
- (void)appearWithAlertAnimationDuration:(CGFloat)duration{
    self.alpha = 0.0f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:duration delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.f;
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}


#pragma mark - Disappear Animation

-(void)setPosition:(CGPoint)point{
    self.frame=CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
}

-(void)removeWithAnimationFlipLeft{
    CGPoint anchorPoint  = self.layer.anchorPoint;
    CGPoint position     = self.layer.position;
    CGRect  frame        = self.frame;
    self.layer.anchorPoint=CGPointMake(0.0f, 0.5f);
    self.layer.position = CGPointMake(self.layer.position.x - self.bounds.size.width/2.0f, self.layer.position.y);
    [UIView animateWithDuration:1.5
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setPosition:CGPointMake(-50, self.frame.origin.y)];
                         self.layer.transform=CATransform3DMakeRotation((M_PI * 90.0) / 180.0f, 0.0f, 1.0f, 0.0f);
                         [self setAlpha:0.1];
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             [self removeFromSuperview];
                             [self setAlpha:1.0];
                             [self setFrame:frame];
                             self.layer.anchorPoint = anchorPoint;
                             self.layer.position  = position;
                             self.layer.transform = CATransform3DIdentity;
                         }
                     }
     ];
    
}
-(void)removeWithAnimationFlipRight{
    CGPoint anchorPoint  = self.layer.anchorPoint;
    CGPoint position     = self.layer.position;
    CGRect  frame        = self.frame;
    self.layer.anchorPoint=CGPointMake(1.0f, 0.5f);
    self.layer.position = CGPointMake(self.layer.position.x + self.bounds.size.width/2.0f, self.layer.position.y);
    [UIView animateWithDuration:1.5
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setPosition:CGPointMake(30,  self.frame.origin.y)];
                         self.layer.transform=CATransform3DMakeRotation((M_PI * 90.0) / 180.0f, 0.0f, 1.0f, 0.0f);
                         [self setAlpha:0.1];
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             [self removeFromSuperview];
                             [self setAlpha:1.0];
                             [self setFrame:frame];
                             self.layer.anchorPoint = anchorPoint;
                             self.layer.position  = position;
                             self.layer.transform = CATransform3DIdentity;
                         }
                     }
     ];
}

-(void)removeWithAnimationSlideRight{
    CGRect  frame = self.frame;
    [UIView transitionWithView:self duration:1.5
                       options:UIViewAnimationOptionCurveEaseInOut animations:^{
                           [self setPosition:CGPointMake(320.0f, self.frame.origin.y)];
                           [self setAlpha:0.1];
                       }
                    completion:^(BOOL finished){
                        [self removeFromSuperview];
                        [self setAlpha:1.0];
                        [self setFrame:frame];
                    }];
}

-(void)removeWithAnimationSlideLeft{
    CGRect  frame = self.frame;
    [UIView transitionWithView:self duration:1.5
                       options:UIViewAnimationOptionCurveEaseInOut animations:^{
                           [self setPosition:CGPointMake(-320.0f, self.frame.origin.y)];
                           [self setAlpha:0.1];
                       }
                    completion:^(BOOL finished){
                        [self removeFromSuperview];
                        [self setAlpha:1.0];
                        [self setFrame:frame];
                    }];
}


#pragma mark - Rotate
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
                        timingFunction:(CAMediaTimingFunction*)timingFunction
{
    CABasicAnimation* rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.timingFunction = timingFunction ? timingFunction : [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotateAnimation.repeatCount = repeatCount > 0 ? repeatCount : HUGE_VALF;
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.fromValue = [NSNumber numberWithFloat:start];
    rotateAnimation.toValue   = [NSNumber numberWithFloat:end];
    rotateAnimation.duration  = duration > 0 ? duration : 0.25;
    [self.layer addAnimation:rotateAnimation forKey:@"rotate"];
    
}

#pragma mark - Bounce Animation
- (void)bounceAnimationDuration:(CGFloat)duration
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef positionPath = CGPathCreateMutable();
    CGPoint pos = self.center;
    CGPathMoveToPoint(positionPath, NULL, pos.x, 0);
    //CGPathAddQuadCurveToPoint(positionPath, NULL, pos.x, pos.y -70, pos.x,pos.y);
    CGPathAddQuadCurveToPoint(positionPath, NULL, pos.x, pos.y -30, pos.x,pos.y);
    CGPathAddQuadCurveToPoint(positionPath, NULL, pos.x, pos.y -15, pos.x,pos.y);
    CGPathAddQuadCurveToPoint(positionPath, NULL, pos.x, pos.y -5, pos.x,pos.y);
    
    positionAnimation.duration = duration;
    positionAnimation.path = positionPath;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //positionAnimation.delegate = self;
    [self.layer addAnimation:positionAnimation forKey:kScaleAnimationKey];
    CGPathRelease(positionPath);
    positionPath = NULL;
}

#pragma mark - HeartBeat Animation
- (void)heartBeatAnimationDuration:(CGFloat)duration fromeValue:(CGFloat)fromeValue toValue:(CGFloat)toValue
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSNumber numberWithFloat:fromeValue];
    animation.toValue   = [NSNumber numberWithFloat:toValue];
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF;
    [self.layer addAnimation:animation forKey:kScaleAnimationKey];
}

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
                  duration:(NSTimeInterval)duration
{
    [self transitionWithType:type subType:subType duration:duration timingFunction:nil startProgress:0 endPorgress:1.0 animationStarted:nil animationEnded:nil];
}


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
            animationEnded:(void(^)())animationEnd
{
    [self transitionWithType:type subType:subType duration:duration timingFunction:nil startProgress:0 endPorgress:1.0 animationStarted:animationStarted animationEnded:animationEnd];
}


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
            animationEnded:(void(^)())animationEnd
{
    
    CATransition *transition = [CATransition animation];
	transition.type     = [type length]>0 ? type : kCATransitionFade;
	transition.subtype  = [subType length]>0 ? subType : kCATransitionFromTop;
    transition.duration = duration;
    transition.timingFunction = timingFunction; //[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.startProgress  = startProgress;
    transition.endProgress    = endProgress;
    transition.delegate       = self;
    if (animationStarted) {
        objc_setAssociatedObject(self, &kAnimationStartedBlockKey, animationStarted, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    if (animationEnd) {
        objc_setAssociatedObject(self, &kAnimationEndedBlockKey, animationEnd, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    [self.layer addAnimation:transition forKey:@"transition"];
    
}

#pragma mark - Private Method
/* Called when the animation begins its active duration. */
- (void)animationDidStart:(CAAnimation *)anim
{
   void (^animationStartedBlock)() = objc_getAssociatedObject(self, &kAnimationStartedBlockKey);
    if (animationStartedBlock) {
        animationStartedBlock();
    }
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    void (^animationEndedBlock)() = objc_getAssociatedObject(self, &kAnimationEndedBlockKey);
    if (animationEndedBlock) {
        animationEndedBlock();
    }
}


@end
