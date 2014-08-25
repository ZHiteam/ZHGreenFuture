//
//  UIButton+FEExtension.m
//  FETestCategory
//
//  Created by xxx on 14-1-6.
//  Copyright (c) 2014年 Ferrari. All rights reserved.
//

#import "UIButton+FEExtension.h"
#import <objc/message.h>

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

@implementation UIButton (FEExtension)
@dynamic hitTestEdgeInsets;


-(void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

//扩大响应点击的区域
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    CGRect hitFrame = UIEdgeInsetsInsetRect(self.bounds, self.hitTestEdgeInsets);
    return CGRectContainsPoint(hitFrame, point);
}

@end
