//
//  UIControl+HKWF.m
//  Stock4HKWF
//
//  Created by elvis on 9/10/13.
//  Copyright (c) 2013 HKWF. All rights reserved.
//

#import "UIControl+ZHiteam.h"

@implementation UIControl (ZHiteam)

-(void)setTouchUpInsideBlock:(TouchEventBLock)block{
    
    [self addTarget:self action:@selector(_eventCall) forControlEvents:UIControlEventTouchUpInside];
    
    [MemoryStorage setValue:block forKey:[NSString stringWithFormat:@"%xtouchEvent",(int)self]];
//    _touchBlock = block;
}

-(void)_eventCall{
    TouchEventBLock touchBlock = [MemoryStorage valueForKey:[NSString stringWithFormat:@"%xtouchEvent",(int)self]];
    if (touchBlock) {
        touchBlock(self);
    }
}

@end
