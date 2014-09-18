//
//  ZHCheckbox.h
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHCheckbox : UIButton

@property (nonatomic,copy)      ZHCompletionBlock   checkBlock;
@property (nonatomic,assign)    BOOL                checked;
@end
