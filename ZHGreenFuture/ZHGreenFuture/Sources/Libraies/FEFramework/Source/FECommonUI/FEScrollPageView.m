//
//  FEScrollPageView.m
//  
//
//  Created by xxx on 14-5-18.
//  Copyright (c) 2014年 All rights reserved.
//

#import "FEScrollPageView.h"
#import "UIImageView+WebCache.h"

@interface FEImageItem()
@property (nonatomic, retain)  NSString      *title;
@property (nonatomic, retain)  NSString      *imageURL;
@property (nonatomic, assign)  NSInteger     tag;
@end

@implementation FEImageItem
- (instancetype)initWithTitle:(NSString *)title imageURL:(NSString *)imageURL tag:(NSInteger)tag{
    self = [super init];
    if (self) {
        self.tag      = tag;
        self.title    = title;
        self.imageURL = imageURL;
    }
    return self;
}

@end

@interface FEScrollPageView()<UIScrollViewDelegate>
@property(nonatomic, strong)NSArray *imageItems;
@property(nonatomic, strong)UIScrollView*scrollView;
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, assign)CGPoint  startPoint;
@property(nonatomic, assign)CGFloat  directionOffset;
@property(nonatomic, assign)BOOL     isInvalidate;
@property(nonatomic, strong)UITapGestureRecognizer *tapGesture;

@end

@implementation FEScrollPageView

- (void)awakeFromNib{
    self.edgeInsets = UIEdgeInsetsZero;
    self.itemWidth =  [[UIScreen mainScreen] bounds].size.width;
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.edgeInsets = UIEdgeInsetsZero;
        self.itemWidth =  [[UIScreen mainScreen] bounds].size.width;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                   imageItems:(NSArray*)items
                selectedBlock:(FEScrollPageSelectedBlock)selectedBlock
                   isAutoPlay:(BOOL)isAutoPlay{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.edgeInsets = UIEdgeInsetsMake(0, 3, 0, 3);
        //_itemWidth= [[UIScreen mainScreen] bounds].size.width;
        self.isHiddenPageController = NO;
        self.imageItems    = items;
        self.selectedBlock = selectedBlock;
        self.isAutoPlay = isAutoPlay;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-10, frame.size.width, 10)];
        self.pageControl.userInteractionEnabled = NO;
        self.pageControl.numberOfPages = [self.imageItems count];
        self.pageControl.currentPage = 0;
        self.pageControl.hidden = self.isHiddenPageController;
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        [self scrollviewInit];
    }
    return self;
}

- (void)setImageItems:(NSArray*)items
        selectedBlock:(FEScrollPageSelectedBlock)selectedBlock
           isAutoPlay:(BOOL)isAutoPlay{
    //_itemWidth =  [[UIScreen mainScreen] bounds].size.width;
    self.isHiddenPageController = NO;
    self.imageItems    = items;
    self.selectedBlock = selectedBlock;
    self.isAutoPlay = isAutoPlay;
    //self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-10, self.frame.size.width, 10)];
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.numberOfPages = [self.imageItems count];
    self.pageControl.currentPage = 0;
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    [self scrollviewInit];
}

- (void)stopAutoPlay{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateLayout{
    [self scrollviewInit];
}

- (UITapGestureRecognizer *)tapGesture
{
    if (_tapGesture == nil) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [_tapGesture setNumberOfTapsRequired:1];
    }
    return _tapGesture;
}

- (void)setItemWidth:(NSInteger)itemWidth{
    if (_itemWidth != itemWidth) {
        _itemWidth = itemWidth;
//        [self scrollviewInit];
    }
}

- (void)setIsHiddenPageController:(BOOL)isHiddenPageController{
    if (_isHiddenPageController != isHiddenPageController) {
        self.pageControl.hidden = _isHiddenPageController;
    }
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets{
    CGRect rect = self.bounds;
    self.scrollView.frame = CGRectMake(self.edgeInsets.left, 0, rect.size.width - self.edgeInsets.left - self.edgeInsets.right, rect.size.height);
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    }
    return _scrollView;
}

    
#pragma mark - Private Method
- (void)scrollviewInit{
    if (self.scrollView == nil) {
        return;
    }
    //reset state
    [[self.scrollView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIView class]]) {
            [obj removeFromSuperview];
        }
    }];

    [self.scrollView removeGestureRecognizer:self.tapGesture];
    
    //create scrollView
    self.scrollView.contentSize = CGSizeMake(self.itemWidth * [self.imageItems count] + self.margin * ([self.imageItems count] -1), self.frame.size.height);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = (self.itemWidth == [UIScreen mainScreen].bounds.size.width);
    self.scrollView.delegate = self;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    //init image items
    NSInteger originX = 0 ;
    //for (FEImageItem *imageItem in self.imageItems){
    //    if ([imageItem isKindOfClass:[FEImageItem class]]) {
    for (id<FEImageItemProtocol> imageItem in self.imageItems){
        if ([imageItem conformsToProtocol:@protocol(FEImageItemProtocol)]) {
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            imageView.frame = CGRectMake(originX , 0, self.itemWidth , self.frame.size.height);
            //if (imageItem.imageURL)
            {
                NSString *placeHolder = [imageItem respondsToSelector:@selector(placeholderImage)]?[imageItem placeholderImage]:nil;
                [imageView setImageWithURL:[NSURL URLWithString:imageItem.imageURL] placeholderImage:[UIImage imageNamed:placeHolder]];
            }
            if ([[imageItem title] length] >0) {
               UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.titleLabelRect];
                titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                titleLabel.text = imageItem.title;
                titleLabel.font = [UIFont systemFontOfSize:10];
                titleLabel.textColor = [UIColor whiteColor];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                [imageView addSubview:titleLabel];
            }
            [self.scrollView addSubview:imageView];
            originX =  originX + self.itemWidth + self.margin;
            imageView.backgroundColor = [UIColor clearColor];//originX/imageView.frame.size.width ?  [UIColor blueColor] : [UIColor orangeColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
        }else {
            NSLog(@">>>Error:FEScrollPageView.imageItems is not kind of class FEImageItem.");
        }
    }
    
    //set default image when none image
    if ([self.imageItems count] == 0 && [self.palceHoldImage length] > 0) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.frame = CGRectMake(originX , 0, self.itemWidth , self.frame.size.height);
        [imageView setImage:[UIImage imageNamed:self.palceHoldImage]];
        [self.scrollView addSubview:imageView];
    }
    //auto play
    [self updateAutoPlayTimer];
    
    //tap gestrue
    [self.scrollView addGestureRecognizer:self.tapGesture];
    
    //width
    if (_itemWidth != [[UIScreen mainScreen] bounds].size.width) {
        [self.pageControl removeFromSuperview];
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)updateAutoPlayTimer{
    if (self.isAutoPlay && self.itemWidth == [UIScreen mainScreen].bounds.size.width) {
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoSwitchToNextPage) userInfo:nil repeats:YES];
    }
}

- (void)autoSwitchToNextPage{
    if (!self.scrollView.isDragging && !self.scrollView.isDecelerating){
        NSInteger targetX  = self.scrollView.contentOffset.x + self.itemWidth;//self.scrollView.frame.size.width;
        NSInteger maxWidth = (NSInteger)roundf(self.scrollView.contentSize.width);
        maxWidth = maxWidth == 0 ? 1 : maxWidth;
        targetX = targetX % maxWidth;
        [self.scrollView setContentOffset:CGPointMake(targetX, self.scrollView.contentOffset.y) animated:YES];
        NSInteger index  = floor(targetX / self.itemWidth/*self.bounds.size.width*/) ;
        self.pageControl.currentPage = index;
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateAutoPlayTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@">>>%@",NSStringFromCGPoint(scrollView.contentOffset));
    CGFloat targetX = scrollView.contentOffset.x;
    if (targetX >=0 && targetX <= (scrollView.contentSize.width - self.itemWidth/*self.bounds.size.width*/) ) {
        NSInteger index  = floor(targetX / self.itemWidth/*self.bounds.size.width*/) ;
        self.pageControl.currentPage = index;
    }
    
    //禁止上下移动
    if (scrollView.contentOffset.y <0 || scrollView.contentOffset.y >0) {
        [scrollView setContentOffset:CGPointMake(targetX,  0 )];
    }
}

/*
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    self.timer = nil;
    self.directionOffset = 0;
    self.isInvalidate   = NO;
    self.startPoint = scrollView.contentOffset;
    NSLog(@">>>start");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //if (abs(self.directionOffset) > self.bounds.size.width/2)
    {
        NSInteger add = self.directionOffset >0 ? 1 : -1;
        NSInteger index = (self.pageControl.currentPage + add) % self.pageControl.numberOfPages;
        NSLog(@">>> %f before = %d add %d after = %d",scrollView.contentOffset.x,self.pageControl.currentPage, add, index);
        //处理正常相关
        if (!self.isInvalidate){
            self.pageControl.currentPage = index;
            [self.scrollView setContentOffset:CGPointMake(index * self.bounds.size.width, self.scrollView.contentOffset.y)];
        }
    }
    [self updateAutoPlayTimer];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //if (self.directionOffset==0)
    {
        //NSLog(@">>>%f",scrollView.contentOffset.x);
        if (abs(scrollView.contentOffset.x - self.startPoint.x) > abs(self.directionOffset)) {
            self.directionOffset = scrollView.contentOffset.x - self.startPoint.x;
        }
        //处理循环滚动相关
        if (!self.isInvalidate && (scrollView.contentOffset.x <0 || scrollView.contentOffset.x > (self.scrollView.contentSize.width-self.bounds.size.width))) {
            CGFloat targetX = scrollView.contentOffset.x < 0 ? self.scrollView.contentSize.width -self.bounds.size.width : 0;
            [self.scrollView setContentOffset:CGPointMake(targetX, self.scrollView.contentOffset.y)];
            NSInteger index  = floor(targetX / self.bounds.size.width) ;
            self.pageControl.currentPage = index;
            self.isInvalidate = YES;
        }
    }
}
*/
#pragma mark - GestureRecognizer

- (void) handleSingleTap:(UITapGestureRecognizer *) gestureRecognizer
{
	CGFloat pageWith = self.itemWidth;//self.frame.size.width;
    CGPoint location = [gestureRecognizer locationInView:self.scrollView];
    NSInteger touchIndex = floor(location.x / pageWith) ;
    NSLog(@">>>FEScrollPageView touch index %d",touchIndex);
	if (touchIndex>=0 && touchIndex<[self.imageItems count]){
        if (self.selectedBlock) {
            self.selectedBlock([self.imageItems objectAtIndex:touchIndex]);
        }
	}
}


@end
