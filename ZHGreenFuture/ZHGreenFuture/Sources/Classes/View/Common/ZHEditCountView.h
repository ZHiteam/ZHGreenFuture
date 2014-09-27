//
//  ZHEditCountView.h
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHEditCountDelegate<NSObject>
-(void)countChange:(NSString*)count;
@end

@interface ZHEditCountView : UIView
@property (nonatomic,assign) NSString* count;
@property (nonatomic,assign) NSInteger maxCount;
@property (nonatomic,assign) NSInteger minCount;

@property (nonatomic,assign) id delegate;

@end
