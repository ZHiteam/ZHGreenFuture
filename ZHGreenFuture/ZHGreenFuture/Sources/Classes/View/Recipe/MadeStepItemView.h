//
//  MadeStepItemView.h
//  ZHGreenFuture
//
//  Created by elvis on 9/16/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MadeStepModel.h"

#define STEP_BOTTOM_SPAN    10
#define STEP_LEFT_SPAN      40

@interface MadeStepItemView : UIView

-(void)setModel:(MadeStepModel*)model index:(NSInteger)index;

+(CGFloat)viewHeightWithContent:(MadeStepModel*)made;
@end
