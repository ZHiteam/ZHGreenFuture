//
//  ZHZbarVC.h
//  NewProject
//
//  Created by admin on 14-9-9.
//  Copyright (c) 2014年 Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZHScanCompletionBlock)(NSString *result);


@interface ZHZbarVC : UIViewController
+ (instancetype)sharedInstance;
- (void)startScanWithVC:(UIViewController*)containerVC completionBlock:(ZHScanCompletionBlock)block;
@end
