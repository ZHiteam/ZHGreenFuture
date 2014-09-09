//
//  FEScrollPageView.h
//
//
//  Created by xxx on 14-5-18.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class FEImageItem;
typedef void(^FEScrollPageSelectedBlock)(FEImageItem* sender);

@protocol FEImageItemProtocol <NSObject>
- (NSString*)title;
- (NSString*)imageURL;
- (NSInteger)tag;
@optional
- (NSString*)placeholderImage;
@end

@interface FEImageItem : NSObject <FEImageItemProtocol>
//@property (nonatomic, retain)  NSString      *title;
//@property (nonatomic, retain)  NSString      *imageURL;
//@property (nonatomic, assign)  NSInteger     tag;

- (instancetype)initWithTitle:(NSString *)title imageURL:(NSString *)imageURL tag:(NSInteger)tag;
@end

@interface FEScrollPageView : UIView
@property(nonatomic, assign)BOOL                    isAutoPlay;
@property(nonatomic, copy)FEScrollPageSelectedBlock selectedBlock;
@property(nonatomic, assign)NSInteger               itemWidth;//default screen.width
@property(nonatomic, assign)BOOL                    isHiddenPageController;//default NO
@property(nonatomic, strong)NSString                *palceHoldImage;//默认图
@property(nonatomic, strong)UIPageControl           *pageControl;
@property(nonatomic, assign)UIEdgeInsets            edgeInsets; //左右起始的间距
@property(nonatomic, assign)CGFloat                 margin;     //item之间的间距
@property(nonatomic, assign)CGRect                  titleLabelRect;//每个item上的titleLabel的位置

- (instancetype)initWithFrame:(CGRect)frame
                   imageItems:(NSArray*)items
                selectedBlock:(FEScrollPageSelectedBlock)selectedBlock
                   isAutoPlay:(BOOL)isAutoPlay;

- (void)setImageItems:(NSArray*)items
        selectedBlock:(FEScrollPageSelectedBlock)selectedBlock
           isAutoPlay:(BOOL)isAutoPlay;

- (void)stopAutoPlay;

- (void)updateLayout;
@end
