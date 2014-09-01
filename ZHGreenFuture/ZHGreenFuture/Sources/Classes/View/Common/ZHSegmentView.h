//
//  ZHSegmentView.h
//  ZHGreenFuture
//
//  Created by elvis on 9/1/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SEGMENT_TAG_START   -100
@class ZHSegmentView;

@protocol ZHSegmentViewDelegate

-(void)segment:(ZHSegmentView*)segment selectAtIndex:(NSInteger)index;

@end

@interface ZHSegmentView : UIScrollView

@property (nonatomic,assign)NSInteger   selectedIndex;
@property (nonatomic,assign) id         segmentDelegate;

- (id)initWithFrame:(CGRect)frame segments:(NSArray*)segments;

-(void)itemSelected:(id)sender;

-(void)performAnimationWithCur:(UIButton*)curSelectItem nextItem:(UIButton*)next;
@end
