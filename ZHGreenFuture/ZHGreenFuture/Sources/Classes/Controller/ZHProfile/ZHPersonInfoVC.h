//
//  ZHPersonInfoVC.h
//  ZHGreenFuture
//
//  Created by admin on 14-9-13.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHProfileModel;
@interface ZHPersonInfoVC : ZHViewController
@property(nonatomic, strong)NSString *avatarURL;
@property(nonatomic, strong)NSString *userName;
@property(nonatomic, weak)ZHProfileModel *profileModel;

@end
