//
//  Timer.h
//  Stock4HKWF
//
//  Created by elvis on 13-9-4.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Instance.h"

@interface Timer : NSObject

+(Timer*)instance;

-(void)fireAfter:(NSTimeInterval)ti target:(id)target action:(SEL)action;

-(void)removeTarget:(id)target action:(SEL)action;

-(void)removeTarget:(id)target;

@end


