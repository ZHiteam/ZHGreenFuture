//
//  ZHView.m
//  ZHGreenFuture
//
//  Created by elvis on 9/1/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHView.h"

@implementation ZHView

-(void)addSubview:(UIView *)view{
    [super addSubview:view];
    if ([self.moniter respondsToSelector:@selector(subViewAdded:)]){
        [self.moniter subViewAdded:view];
    }
}

@end
