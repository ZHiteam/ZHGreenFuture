//
//  UIScreen+FEFrame.m
//  FETestCategory
//
//  Created by xxx on 13-9-16.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import "UIScreen+FEFrame.h"

@implementation UIScreen (FEFrame)

+ (CGFloat)bodyHeight{
    static UINavigationController *kNavigationController = nil;
    if(kNavigationController == nil)
        kNavigationController = [[UINavigationController alloc] init];
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    return height - [UIApplication sharedApplication].statusBarFrame.size.height - kNavigationController.navigationBar.frame.size.height;
}

+ (CGFloat)bodyWidth{
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)screenWidth{
    //BOOL isLandscape = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)screenHeight{
    //BOOL isLandscape = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)statusBarHeight{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

+ (BOOL)isRetina{
    return [[UIScreen mainScreen] scale]>1.0;
}

@end
