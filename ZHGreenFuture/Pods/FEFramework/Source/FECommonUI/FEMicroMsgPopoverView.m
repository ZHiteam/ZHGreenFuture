//
//  FEMicroMsgPopoverView.m
//
//
//  Created by xxx on 14-5-22.
//  Copyright (c) 2014年 xxx. All rights reserved.
//

#import "FEMicroMsgPopoverView.h"

@implementation FEMicroMsgPopoverItem

- (id)initWithImage:(UIImage *)imageN
              title:(NSString*)title
       clickedBlock:(FEItemClickedBlock)block{
    self = [super init];
    if (self) {
        self.imageN = imageN;
        self.title  = title;
        self.clickedBlock = block;
    }
    return self;
}

@end

////////////////////////////////////////////////////////////////////////////////////////
@interface FEMicroMsgPopoverItemButton : UIButton
@end

@implementation FEMicroMsgPopoverItemButton

- (void)layoutSubviews {
    [super layoutSubviews];
    UIImageView *imageView = [self imageView];
    UILabel *titleLabel = [self titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:12.0];
    CGSize titleSize = [titleLabel.text sizeWithFont:titleLabel.font];
    
    CGRect imageFrame = imageView.frame;
    imageFrame.origin.x = (int)((self.frame.size.width - imageFrame.size.width - titleSize.width -6)/ 2);
    imageFrame.origin.x = imageFrame.origin.x < 0 ? 0 : imageFrame.origin.x;
    imageFrame.origin.y = imageFrame.origin.y;
    imageView.frame = imageFrame;
    
    titleLabel.textAlignment = UITextAlignmentLeft;
    //titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    CGRect labelRect = titleLabel.frame;
    labelRect.origin = CGPointMake(imageFrame.origin.x + imageFrame.size.width + 3 , titleLabel.frame.origin.y);
    titleLabel.frame = labelRect;
}

//高亮
- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self showHighlighted:highlighted];
}

#pragma mark - Private Method
- (void)showHighlighted:(BOOL)isHighlighted{
    if (isHighlighted) {
        [[self imageView]  setAlpha:0.3];
        [[self titleLabel] setAlpha:0.3];
    }else{
        [[self imageView]  setAlpha:1.0];
        [[self titleLabel] setAlpha:1.0];
    }
}

@end
////////////////////////////////////////////////////////////////////////////////////////


#define kPopoverViewWidth           200.0
#define kPopoverViewHeight          44.0
#define kPopoverViewItemWidth       60.0
#define kPopoverViewItemHeight      32.0
#define kPopoverViewItemMargin      3.0

#define kPopoverViewItemTopMargin    roundf((kPopoverViewHeight-kPopoverViewItemHeight)/2.0)
#define FESCREEN_SIZE               [[UIScreen mainScreen] bounds].size

@interface FEMicroMsgPopoverView ()
@property (nonatomic, strong) UIView  *containerView;//做动画用
@property (nonatomic, strong) UIView  *contentView;
@property (nonatomic, strong) NSArray *items;

@end
@implementation FEMicroMsgPopoverView

- (id)initWithItems:(NSArray *)items{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel:)];
        [self addGestureRecognizer:tapGesture];
        
        self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.containerView.clipsToBounds   = YES;//动画用
        self.containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.containerView];
        
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
        self.contentView.backgroundColor = [UIColor colorWithRed:62/255.0 green:62/255.0 blue:62/255.0 alpha:1.0];
        self.contentView.layer.borderColor  = [UIColor colorWithRed:62/255.0 green:62/255.0 blue:62/255.0 alpha:1.0].CGColor;
        self.contentView.layer.cornerRadius = 6.0;
        self.contentView.layer.borderWidth  = 0.5;
        [self.containerView addSubview:self.contentView];
        
        self.items = items;
        [self initItems];
    }
    return self;
}


- (void)showAtPosition:(CGPoint)position{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    self.containerView.frame = CGRectMake(position.x - self.containerView.frame.size.width, position.y, self.containerView.frame.size.width, self.containerView.frame.size.height);
    
    __block CGRect rect = self.contentView.frame;
    rect.origin.x = rect.size.width;
    self.contentView.frame = rect;
    [UIView animateWithDuration:0.3 animations:^{
        rect.origin.x = 0.0;
        self.contentView.frame = rect;
    }];
}


#pragma mark - Tap Gesture
- (void)tappedCancel:(UIGestureRecognizer*)gesture
{
    [UIView animateWithDuration:0.3 animations:^{
        __block CGRect rect = self.contentView.frame;
        rect.origin.x = rect.size.width;
        self.contentView.frame = rect;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


#pragma mark - Private Method
- (void)initItems{
    NSAssert([self.items count]<8, @"Error:Too many items");
    CGFloat width = self.items.count * kPopoverViewItemWidth + (self.items.count-1)*kPopoverViewItemMargin + kPopoverViewItemMargin*2;
    self.containerView.frame = CGRectMake(FESCREEN_SIZE.width - width, 0, width, kPopoverViewHeight);
    self.contentView.frame   = self.containerView.bounds;
    
    CGFloat posX = kPopoverViewItemMargin;
    for (FEMicroMsgPopoverItem *item in self.items) {
        if ([item  isKindOfClass:[FEMicroMsgPopoverItem class]]) {
            FEMicroMsgPopoverItemButton *button = [FEMicroMsgPopoverItemButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(posX, kPopoverViewItemTopMargin, kPopoverViewItemWidth, kPopoverViewItemHeight)];
            [button setImage:item.imageN forState:UIControlStateNormal];
            [button setTitle:item.title  forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0]];
            [button setTag:[self.items indexOfObject:item]];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.borderColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0].CGColor;
            button.layer.cornerRadius= 1.0;
            button.layer.borderWidth = 0.5;
            [self.contentView addSubview:button];
        }
        posX  = posX + kPopoverViewItemWidth + kPopoverViewItemMargin;
    }
}

- (void)buttonPressed:(UIButton*)sender{
    NSInteger index = sender.tag;
    if (index >=0 && index < self.items.count) {
        FEMicroMsgPopoverItem *item = [self.items objectAtIndex:index];
        if (item.clickedBlock) {
            item.clickedBlock(item);
        }
    }
    [self tappedCancel:nil];
}

@end
