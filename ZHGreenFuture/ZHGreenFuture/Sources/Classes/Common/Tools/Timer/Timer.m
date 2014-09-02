//
//  Timer.m
//  Stock4HKWF
//
//  Created by elvis on 13-9-4.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "Timer.h"
#import <objc/message.h>

/**
 * timer item
 */
@interface TimerItem : NSObject{
    NSTimeInterval      _submitTime;
}

@property(nonatomic, strong)id              target;
@property(nonatomic, assign)SEL             action;
@property(nonatomic, assign)BOOL            repart;
@property(nonatomic, assign)NSTimeInterval  fireTi;
@property(nonatomic, assign)NSTimeInterval  submitTime;

-(void)resetSubmitTime;

+(TimerItem*)timerItemWithTarget:(id)target action:(SEL)action timeInterval:(NSTimeInterval)ti;

+(TimerItem*)timerItemWithTarget:(id)target action:(SEL)action timeInterval:(NSTimeInterval)ti repart:(BOOL)repart;
@end

@implementation TimerItem

+(TimerItem*)timerItemWithTarget:(id)target action:(SEL)action timeInterval:(NSTimeInterval)ti{
    return [TimerItem timerItemWithTarget:target action:action timeInterval:ti repart:NO];
}

+(TimerItem*)timerItemWithTarget:(id)target action:(SEL)action timeInterval:(NSTimeInterval)ti repart:(BOOL)repart{
    TimerItem* item = [[TimerItem alloc]init];
    item.target = target;
    item.action = action;
    item.fireTi = ti;
    item.repart = repart;
    item.submitTime = [[NSDate date]timeIntervalSince1970];
    
    return item;
}

-(NSString *)description{
    return [self.target description];
}

-(void)resetSubmitTime{
    self.submitTime = [[NSDate date]timeIntervalSince1970];
}

@end
////////// Timer ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface Timer(){
    NSMutableDictionary*    _timerArray;
}

@property(nonatomic, strong)NSTimer  *timer;

-(void)timerFire;
@end

@implementation Timer

-(id)init{
    if (self = [super init]) {
        _timerArray = [[NSMutableDictionary alloc]init];
//        self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
        self.timer = [[NSTimer alloc]initWithFireDate:[NSDate date] interval:0.5f target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

-(void)timerFire{
    NSArray* allKey = [_timerArray allKeys];
    
    for (int keyIndex = [allKey count]-1; keyIndex >= 0; --keyIndex ) {
        
        NSString* key = allKey[keyIndex];
        
        NSMutableArray* array = _timerArray[key];
        
        for (int index = [array count]-1; index >= 0; --index) {
            TimerItem* item = array[index];
            NSTimeInterval diff = [[NSDate date]timeIntervalSince1970] - item.submitTime;
            /// fire
            if (diff >= item.fireTi) {
                if ([item.target respondsToSelector:item.action]) {
                    objc_msgSend(item.target, item.action);
                    
                    if (item.repart) {
                        [item resetSubmitTime];
                    }
                    else{
                        [array removeObject:item];
                    }
                }
            }
        }
        if (0 == [array count]) {
            [_timerArray removeObjectForKey:key];
        }
    }
}

+(Timer *)instance{
    return [Timer instanceWithCLass:[Timer class]];
}

-(void)fireAfter:(NSTimeInterval)ti target:(id)target action:(SEL)action{
    if (!target || !action) {
        return;
    }
    TimerItem* item = [TimerItem timerItemWithTarget:target action:action timeInterval:ti];
    NSMutableArray* arry = [_timerArray objectForKey:[target description]];
    
    if (!arry){
        arry = [[NSMutableArray alloc]initWithObjects:item, nil];
    }
    else{
        [arry insertObject:item atIndex:0];
    }
    [_timerArray setValue:arry forKey:[item description]];
}

-(void)removeTarget:(id)target action:(SEL)action{
    NSMutableArray* arry = [_timerArray objectForKey:[target description]];
    for (int index = [arry count]-1; index >= 0 ; --index) {
        TimerItem* item = arry[index];
        if (item.action == action) {
            [arry removeObject:item];
        }
    }
}

-(void)removeTarget:(id)target{
    [_timerArray removeObjectForKey:[target description]];
}

@end