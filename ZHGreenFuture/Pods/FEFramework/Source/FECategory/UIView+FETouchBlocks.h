//
//  UIView+FETouchBlocks.h
//  FETestCategory
//
//  Created by xxx on 13-9-16.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^FETouchBlock)(NSSet* touches , UIEvent* event);
typedef void (^FEGestureBlock)();

@interface UIView (FETouchBlocks)<UIGestureRecognizerDelegate>
//重写touchesBegan等,实现block回调,无需继承UIVIew满足简单的事件处理
- (void)touchBeganBlock:(FETouchBlock)block;
- (void)touchEndedBlock:(FETouchBlock)block;
- (void)touchMovedBlock:(FETouchBlock)block;
- (void)touchCancelledBlock:(FETouchBlock)block;


/**
	实现点击的block回调，内部使用UITapGestureRecognizer手势
	@param block 回调block
	@param taps 点击次数
	@param touches 手指数
 */
- (void)tapGestureBlock:(FEGestureBlock)block
              tapNumber:(NSUInteger)taps
           toucheNumber:(NSUInteger)touches;


/**
	实现长按的block回调，内部使用UILongPressGestureRecognizer手势
	@param block 回调block
	@param taps 点击次数
	@param touches 手指数
	@param minDuration 最短持续时间
	@param allowableMovement 允许移动的范围
 */
- (void)longPressGestureBlock:(FEGestureBlock)block
                    tapNumber:(NSUInteger)taps
                 toucheNumber:(NSUInteger)touches
                  minDuration:(CGFloat)minDuration
            allowableMovement:(CGFloat)allowableMovement;



@end
