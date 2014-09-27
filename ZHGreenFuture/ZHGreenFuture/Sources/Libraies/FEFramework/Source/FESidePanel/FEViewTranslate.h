//
//  FEViewTranslate.h
//  FETestAnimation
//
//  Created by administrator on 13-7-31.
//  Copyright (c) 2013年 xxx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FETranslateAnimationType){
    FETranslateAnimationTypeNone,
    FETranslateAnimationTypeSlide,
    FETranslateAnimationTypeSlideScale,
    FETranslateAnimationTypeSwingingDoor,
    FETranslateAnimationTypeParallax,
    FETranslateAnimationTypeDragIn,
    FETranslateAnimationTypeFade,
    FETranslateAnimationTypePage,
};

typedef NS_ENUM(NSInteger, FETranslateDirection) {
    FETranslateDirectionLeft,
    FETranslateDirectionRight,
};

typedef void(^translateBlock)(UIView* view,FETranslateDirection type, CGFloat maxWidth,CGFloat percent);

@interface FEViewTranslate : NSObject

+ (FEViewTranslate*)sharedIntance;
- (translateBlock)translateBlockWithType:(FETranslateAnimationType)type;

@end
