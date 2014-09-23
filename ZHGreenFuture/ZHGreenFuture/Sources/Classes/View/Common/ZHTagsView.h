//
//  ZHTagsView.h
//  ZHGreenFuture
//
//  Created by elvis on 9/3/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagModel.h"

@protocol ZHTagsViewDelegate<NSObject>
-(void)tagSelectWithId:(NSString*)tagId;
@end

@interface ZHTagsView : UIView

@property (nonatomic,assign) id delegate;
-(id)initWithFrame:(CGRect)frame tags:(NSArray*)tags;

-(void)loadContentWithTags:(NSArray*)tags;
@end
