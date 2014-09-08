//
//  ZHDetailProductHeadView.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-8.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHDetailProductHeadView.h"

@implementation ZHDetailProductHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Public Method
+ (instancetype)headView{
    id obj =  [self instanceWithNibName:@"ZHDetailProductHeadView" bundle:nil owner:nil];
    if ([obj isKindOfClass:[ZHDetailProductHeadView class]]) {
        ZHDetailProductHeadView *view = obj;
        return view;
    }
    return nil;
}

+ (CGFloat)height{
    return 48.0;
}

@end
