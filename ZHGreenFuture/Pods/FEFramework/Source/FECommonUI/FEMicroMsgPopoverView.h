//
//  FEMicroMsgPopoverView.h
//  
//
//  Created by xxx on 14-5-22.
//  Copyright (c) 2014年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FEItemClickedBlock)(id sender);

@interface FEMicroMsgPopoverItem : NSObject
@property (nonatomic, strong) UIImage           *imageN;
@property (nonatomic, strong) NSString          *title;
@property (nonatomic, copy) FEItemClickedBlock clickedBlock;

- (id)initWithImage:(UIImage *)imageN
              title:(NSString*)title
       clickedBlock:(FEItemClickedBlock)block;
@end


@interface FEMicroMsgPopoverView : UIView
- (id)initWithItems:(NSArray *)items;
- (void)showAtPosition:(CGPoint)position;
@end
