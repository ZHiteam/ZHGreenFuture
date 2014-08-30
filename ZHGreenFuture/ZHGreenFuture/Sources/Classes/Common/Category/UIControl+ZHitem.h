//
//  UIControl+HKWF.h
//  Stock4HKWF
//
//  Created by elvis on 9/10/13.
//  Copyright (c) 2013 HKWF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchEventBLock)(UIControl* ctl);

@interface UIControl (ZHitem)

-(void)setTouchUpInsideBlock:(TouchEventBLock)block;

@end
