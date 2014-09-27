//
//  UIView+FETouchBlocks.m
//  FETestCategory
//
//  Created by xxx on 13-9-16.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import "UIView+FETouchBlocks.h"
#import <objc/runtime.h>
#import <objc/message.h>



typedef NS_ENUM(NSInteger, FETouchtype){
    FETouchBegan,
    FETouchMoved,
    FETouchEnded,
    FETouchCanceled,
};

typedef NS_ENUM(NSInteger, FEGestureType){
    FEGestureNone,
    FEGestureTap,
    FEGestureLongPress,
    FEGestureDrag,
    FEGesturePinch,
    FEGestureSwipe,
    FEGestureRotation,
};

static char touchBlockKey[10];
static char gestureBlockKey[10];

@implementation UIView (FETouchBlocks)
#pragma mark - Public  Method
- (void)touchBeganBlock:(FETouchBlock)block{
    [self setTouchBlock:block forKey:&touchBlockKey[FETouchBegan]];
}

- (void)touchMovedBlock:(FETouchBlock)block{
    [self setTouchBlock:block forKey:&touchBlockKey[FETouchMoved]];
}

- (void)touchEndedBlock:(FETouchBlock)block{
    [self setTouchBlock:block forKey:&touchBlockKey[FETouchEnded]];
}

- (void)touchCancelledBlock:(FETouchBlock)block{
    [self setTouchBlock:block forKey:&touchBlockKey[FETouchCanceled]];
}

- (void)tapGestureBlock:(FEGestureBlock)block
              tapNumber:(NSUInteger)taps
           toucheNumber:(NSUInteger)touches{
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerGesture:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired    = taps;
    tapGesture.numberOfTouchesRequired = touches;
    [self addGestureRecognizer:tapGesture];
    [self setGestureBlock:block forKey:&gestureBlockKey[FEGestureTap]];
}

- (void)longPressGestureBlock:(FEGestureBlock)block
                    tapNumber:(NSUInteger)taps
                 toucheNumber:(NSUInteger)touches
                  minDuration:(CGFloat)minDuration
            allowableMovement:(CGFloat)allowableMovement
{
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlerGesture:)];
    gesture.delegate = self;
    gesture.numberOfTapsRequired   = taps;
    gesture.numberOfTouchesRequired = touches;
    gesture.minimumPressDuration    = minDuration;
    gesture.allowableMovement       = allowableMovement;
    [self addGestureRecognizer:gesture];
    [self setGestureBlock:block forKey:&gestureBlockKey[FEGestureLongPress]];
}


#pragma mark - Override
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self runTouchBlockForKey:&touchBlockKey[FETouchBegan] touches:touches event:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    [self runTouchBlockForKey:&touchBlockKey[FETouchMoved] touches:touches event:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self runTouchBlockForKey:&touchBlockKey[FETouchEnded] touches:touches event:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    [self runTouchBlockForKey:&touchBlockKey[FETouchCanceled] touches:touches event:event];
}

#pragma mark - Private Method
- (void)runTouchBlockForKey:(void *)blockKey touches:(NSSet*)touches event:(UIEvent *)event  {
    FETouchBlock block = objc_getAssociatedObject(self, blockKey);
    if (block) block(touches,event);
}

- (void)setTouchBlock:(FETouchBlock)block forKey:(void *)blockKey {
    if (block) {
        self.userInteractionEnabled = YES;
        objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void)setGestureBlock:(FEGestureBlock)block   forKey:(void *)blockKey{
    if (block) {
        objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void)handlerGesture:(UIGestureRecognizer*)gesture{
    FEGestureType type = FEGestureNone;
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        type = FEGestureTap;
    }else if([gesture isKindOfClass:[UILongPressGestureRecognizer class]]){
        type = FEGestureLongPress;
    }
    if (type != FEGestureNone) {
        FEGestureBlock block = objc_getAssociatedObject(self, &gestureBlockKey[FEGestureTap]);
        if (block) block();
    }
}

@end
