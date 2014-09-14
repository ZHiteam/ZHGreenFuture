//
//  ZHButton.h
//  ZHGreenFuture
//
//  Created by admin on 14-9-14.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHButton;
typedef void(^ZHButtonClickedBlock)(ZHButton *button);

typedef NS_ENUM(NSInteger, ZHButtonType) {
    ZHButtonTypeDefault,
    ZHButtonTypeStyle1,
};

@interface ZHButton : UIButton
+(instancetype)buttonWithType:(ZHButtonType)type text:(NSString*)text clickedBlock:(ZHButtonClickedBlock)block;
@end
