//
//  ZHAuthorizationVC.h
//  ZHGreenFuture
//
//  Created by admin on 14-9-20.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHAuthorizationManager.h"

@interface ZHAuthorizationVC : UIViewController
@property(nonatomic, assign) BOOL isRunning;
@property(nonatomic, readonly)ZHAuthorizationManager *authManager;
+ (instancetype)shareInstance;
+ (void)showLoginVCWithCompletionBlock:(ZHAuthCompletionBlock)block;
+ (void)dismissLoginVC;
@end
