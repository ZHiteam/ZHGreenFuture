//
//  ZHView.h
//  ZHGreenFuture
//
//  Created by elvis on 9/1/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHViewMoniter
@optional
-(void)subViewAdded:(UIView*)addedView;
@end

@interface ZHView : UIView

@property (nonatomic,assign)id moniter;
@end
