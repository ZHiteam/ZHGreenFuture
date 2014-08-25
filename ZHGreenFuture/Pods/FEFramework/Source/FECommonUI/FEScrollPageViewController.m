//
//  FEScrollPageViewController.m
//  xxx
//
//  Created by xx on 14-6-1.
//  Copyright (c) 2014年 All rights reserved.
//

#import "FEScrollPageViewController.h"



#define  kIndicateViewTag  0x35
@interface FEScrollPageViewController ()
@property(nonatomic, strong)NSMutableArray *tabsViews;//UIScrollView
@property(nonatomic, strong)UIView  *tabView;      //包含所有tab section的view
@property(nonatomic, strong)UIView  *contentView;  //内容view
@property(nonatomic, strong)NSMutableDictionary *tabsDict;
@property(nonatomic, strong)NSMutableDictionary *contents;

@property(nonatomic, assign)NSUInteger sectionCount;
@property(nonatomic, strong)NSMutableArray *currentIndex;

@property(nonatomic, strong)UISwipeGestureRecognizer    *rightSwipeGestureRecognizer;
@property(nonatomic, strong)UISwipeGestureRecognizer    *leftSwipeGestureRecognizer;
@property(nonatomic, assign)BOOL isSingletonContentVC;

@property(nonatomic, strong)UIViewController *currentViewController;
@end

@implementation FEScrollPageViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self baseInit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    [self.view addSubview:self.tabView];
    [self.view addSubview:self.contentView];
    
    //[self reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Method
- (void)baseInit{
    self.tabHeight = 40.0;
    self.tabItemWidth = 100.0;
    self.tabsViews = [NSMutableArray arrayWithCapacity:0];
    self.tabsDict = [NSMutableDictionary dictionaryWithCapacity:0];
    self.contents = [NSMutableDictionary dictionaryWithCapacity:0];
    self.tabView = [[UIView alloc] initWithFrame:CGRectZero];
    self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.currentIndex = [NSMutableArray arrayWithCapacity:0];
    
    
    // To capture tap events
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.tabView addGestureRecognizer:tapGestureRecognizer];
    
    // Swipe
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlerSwipeGesture:)];
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlerSwipeGesture:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.contentView addGestureRecognizer:self.rightSwipeGestureRecognizer];
    [self.contentView addGestureRecognizer:self.leftSwipeGestureRecognizer];
    
}

#pragma mark - Public  Method
- (void)reloadData{
    [self.tabsViews removeAllObjects];
    [self.tabsDict  removeAllObjects];
    [self.contents  removeAllObjects];
    UIView *subView = [[self.tabView subviews] count] >0 ? [[self.tabView subviews] objectAtIndex:0] : nil;
    [subView removeFromSuperview];
    subView = nil;
    
    self.sectionCount = [self.dataSource numberOfSections];
    self.isSingletonContentVC = self.sectionCount > 1;
    
    //对于多section 只支持单VC
    if (self.isSingletonContentVC) {
        [self.contentView removeGestureRecognizer:self.rightSwipeGestureRecognizer];
        [self.contentView removeGestureRecognizer:self.leftSwipeGestureRecognizer];
    }
    
    for (NSUInteger section = 0 ; section < self.sectionCount; section++) {
        //add section scrollview
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, section*self.tabHeight, self.view.frame.size.width, self.tabHeight)];
        scrollView.backgroundColor = [UIColor whiteColor];//section %2 ? [[UIColor orangeColor] colorWithAlphaComponent:0.3] : [[UIColor blueColor] colorWithAlphaComponent:0.3];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator   = NO;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        scrollView.userInteractionEnabled = YES;
        UIView *indicateView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabHeight -2, self.tabItemWidth, 2)];
        indicateView.backgroundColor = [UIColor redColor];
        indicateView.tag = kIndicateViewTag;
        [scrollView addSubview:indicateView];
        [self.tabsViews addObject:scrollView];
        
        NSUInteger tabsCount = [self.dataSource numberOfTabsInSection:section];
        //add tab view at [section, index]
        NSMutableArray *tabViews = [NSMutableArray arrayWithCapacity:tabsCount];
        NSMutableArray *contents = [NSMutableArray arrayWithCapacity:tabsCount];
        for (NSUInteger index =0 ; index < tabsCount; index ++) {
            UIView *tabView = [self.dataSource tabViewAtSection:section tabIndex:index];
            NSAssert(tabView != nil, @"Error:tabView should not be nil");
            [tabViews addObject:tabView];
            
            if (!self.isSingletonContentVC) {
                if ([self.dataSource respondsToSelector:@selector(contentViewControllerForTabAtSection:index:)]) {
                    UIViewController *vc = [self.dataSource contentViewControllerForTabAtSection:section index:index];
                    //NSAssert(vc != nil, @"Error:contentVC should not be nil");
                    if (vc) {
                        [contents addObject:vc];
                    }
                }
            }
        }
        [self.tabsDict setObject:tabViews forKey:[NSNumber numberWithInteger:section]];
        [self.contents setObject:contents forKey:[NSNumber numberWithInteger:section]];
    }
    
    //Layout tabview and contentView
    [self.tabView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.tabHeight * self.sectionCount)];
    [self.contentView setFrame:CGRectMake(0, self.tabView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.tabView.frame.size.height)];

    
    //Layout tab views
    for (NSNumber *key in self.tabsDict.allKeys) {
        UIScrollView *scrollView = [self.tabsViews objectAtIndex:[key integerValue]];
        NSArray *tabViews = [self.tabsDict objectForKey:key];
        CGFloat tabSizeWidth = 0;
        for (UIView *tabView in tabViews) {
            [tabView setFrame:CGRectMake(tabSizeWidth, 0, self.tabItemWidth, self.tabHeight)];
            [scrollView addSubview:tabView];
            tabSizeWidth += self.tabItemWidth;
        }
        scrollView.contentSize = CGSizeMake(MAX(tabSizeWidth, [UIScreen mainScreen].bounds.size.width +20), self.tabHeight);
        [self.tabView addSubview:scrollView];
    }
    
    if (!self.isSingletonContentVC) {
        NSArray *contentArray = [self.contents objectForKey:[NSNumber numberWithInteger:0]];
        UIViewController *vc0 = [contentArray objectAtIndex:0];
        [self.contentView addSubview:vc0.view];
        [self addChildViewController:vc0];//first set
        self.currentViewController = vc0;
    }
    
    //Default Selected index
    if ( self.sectionCount > [self.currentIndex count]) {
        [self.currentIndex removeAllObjects];
        for (NSInteger index = 0; index < self.sectionCount; index++) {
            [self.currentIndex addObject:[NSNumber numberWithInteger:0]];
            [self setTabViewHighlighted:YES indexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
            UIScrollView *scrollView = [self.tabsViews objectAtIndex:index];
            UIView * indicateView = [scrollView viewWithTag:kIndicateViewTag];
            indicateView.frame = CGRectMake(0, indicateView.frame.origin.y, indicateView.frame.size.width, indicateView.frame.size.height);
        }
    }
    //update selected index
    for (NSInteger index = 0; index < [self.currentIndex count]; index ++ ) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[self.currentIndex objectAtIndex:index] integerValue] inSection:index];
        [self transitionFrom:[NSIndexPath indexPathForRow:0 inSection:index] toIndexPath:indexPath animation:NO];
        //[self setCurrentSelectedIndexPath:indexPath];
    }

}

- (void)setCurrentSelectedIndexPath:(NSIndexPath *)selectedIndexPath{
    if (selectedIndexPath.section < [self.currentIndex count]) {
        NSInteger originIndex =  [[self.currentIndex objectAtIndex:selectedIndexPath.section] integerValue];
        if (selectedIndexPath.row != originIndex) {
            [self setTabViewHighlighted:NO indexPath:[NSIndexPath indexPathForRow:originIndex inSection:selectedIndexPath.section]];
            [self.currentIndex replaceObjectAtIndex:selectedIndexPath.section withObject:[NSNumber numberWithInteger:selectedIndexPath.row]];
            [self setTabViewHighlighted:YES indexPath:selectedIndexPath];
            
            UIScrollView *scrollView = [self.tabsViews objectAtIndex:selectedIndexPath.section];
            UIView * indicateView = [scrollView viewWithTag:kIndicateViewTag];
            [UIView animateWithDuration:0.25 animations:^{
                indicateView.frame = CGRectMake(selectedIndexPath.row * self.tabItemWidth,  indicateView.frame.origin.y, indicateView.frame.size.width, indicateView.frame.size.height);
            } completion:^(BOOL finished) {
            }];
            
            if (!self.isSingletonContentVC) {
                [self transitionFrom:[NSIndexPath indexPathForRow:originIndex inSection:selectedIndexPath.section] toIndexPath:selectedIndexPath animation:YES];
            } else {
                [self.delegate viewPage:self didChangeTabToSection:selectedIndexPath.section index:selectedIndexPath.row contentVC:nil];
            }
        }
    }

}

- (void)setTabViewHighlighted:(BOOL)isHighlighted indexPath:(NSIndexPath*)indexPath{
    NSArray * array = [self.tabsDict objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    UIView *view = [array objectAtIndex:indexPath.row];
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel*)view;
        label.textColor = isHighlighted ? [UIColor redColor] : [UIColor blackColor];
    }
}

- (UIViewController*)viewControllerWithIndexPath:(NSIndexPath*)indexPath{
    NSArray *contentArray = [self.contents objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    UIViewController *vc  = [contentArray objectAtIndex:indexPath.row];
    return vc;
}

- (void)transitionFrom:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath animation:(BOOL)animated{
    
    UIViewController *fromVC = [self viewControllerWithIndexPath:fromIndexPath];
    UIViewController *toVC   = [self viewControllerWithIndexPath:toIndexPath];
    UIView *fromWrapperView = nil;
    
    //NSLog(@">>>fromVC[%@] toView[%@]",fromVC.view,toVC.view);
    if (fromVC && toVC && (fromVC != toVC)){
        [self.contentView insertSubview:toVC.view belowSubview:fromVC.view];
        fromWrapperView = fromVC.view;
    } else {
        //截屏，做个动画
        UIImageView *fromView = [[UIImageView alloc] initWithFrame:fromVC.view.frame];
        fromView.backgroundColor = [UIColor clearColor];
        
        UIGraphicsBeginImageContextWithOptions(fromVC.view.frame.size, NO, [UIScreen mainScreen].scale);
        [fromVC.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image = [UIImage imageWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        [fromView setImage:image];
        [self.contentView addSubview:fromView];
        fromWrapperView = fromView;
    }
    
    if (animated) {
        CGFloat directionWidth = fromIndexPath.row < toIndexPath.row ? 320 : -320;
        CGRect rect = toVC.view.frame;
        toVC.view.frame = CGRectMake(directionWidth, rect.origin.y, rect.size.width, rect.size.height);
        [UIView transitionWithView:fromWrapperView
                          duration:0.3
                           options:UIViewAnimationOptionCurveEaseInOut animations:^{
                               CGRect rect = fromWrapperView.frame;
                               rect.origin.x = -directionWidth;
                               [fromWrapperView setFrame:rect];
                               [toVC.view setFrame:toVC.view.bounds];
                           }
                        completion:^(BOOL finished){
                            [fromWrapperView removeFromSuperview];
                            [self.contentView addSubview:toVC.view];
                            [self.delegate viewPage:self didChangeTabToSection:toIndexPath.section index:toIndexPath.row contentVC:toVC];
                            
                            //Reset contentOffset when scrollview
                            if ([fromVC.view isKindOfClass:[UIScrollView class]]) {
                                ((UIScrollView*)fromVC.view).contentOffset = CGPointZero;
                            }
                        }];

        //tab view transition
        if (fromIndexPath.section == toIndexPath.section) {
            [self setTabViewHighlighted:NO indexPath:fromIndexPath];
            [self setTabViewHighlighted:YES indexPath:toIndexPath];
            UIScrollView *scrollView = [self.tabsViews objectAtIndex:toIndexPath.section];
            UIView * indicateView = [scrollView viewWithTag:kIndicateViewTag];
            [UIView animateWithDuration:0.25 animations:^{
                indicateView.frame = CGRectMake(toIndexPath.row * self.tabItemWidth,  indicateView.frame.origin.y, indicateView.frame.size.width, indicateView.frame.size.height);
            } completion:^(BOOL finished) {
            }];
            
           //tab个数小时不做滚动
            //NSInteger count =  [[UIScreen mainScreen] bounds].size.width /self.tabItemWidth;
            //if ([self.tabsDict count] > count)
            {
                //UIScrollView *scrollView = [self.tabsViews objectAtIndex:fromIndexPath.section];
                CGFloat offsetX = toIndexPath.row * self.tabItemWidth - roundf((self.view.bounds.size.width - self.tabItemWidth)/2.0);
                offsetX  = offsetX < 0 ? 0.0 : offsetX;
                [scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
                //[scrollView scrollRectToVisible:CGRectMake(roundf((self.view.bounds.size.width - self.tabItemWidth)/2.0), 0, self.tabItemWidth, self.tabHeight) animated:YES];
            }
        }
    } else {
        
        [fromWrapperView removeFromSuperview];
        [self.contentView addSubview:toVC.view];
        [self.delegate viewPage:self didChangeTabToSection:toIndexPath.section index:toIndexPath.row contentVC:toVC];
        
        //Reset contentOffset when scrollview
        if ([fromVC.view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView*)fromVC.view).contentOffset = CGPointZero;
        }
        
        [self setTabViewHighlighted:NO indexPath:fromIndexPath];
        [self setTabViewHighlighted:YES indexPath:toIndexPath];
        UIScrollView *scrollView = [self.tabsViews objectAtIndex:toIndexPath.section];
        UIView * indicateView = [scrollView viewWithTag:kIndicateViewTag];
        indicateView.frame = CGRectMake(toIndexPath.row * self.tabItemWidth,  indicateView.frame.origin.y, indicateView.frame.size.width, indicateView.frame.size.height);
        
        CGFloat offsetX = toIndexPath.row * self.tabItemWidth - roundf((self.view.bounds.size.width - self.tabItemWidth)/2.0);
        offsetX  = offsetX < 0 ? 0.0 : offsetX;
        [scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
    [fromVC removeFromParentViewController];
    [self addChildViewController:toVC];
    self.currentViewController = toVC;

}

- (UIViewController *)visibleViewController{
    return self.currentViewController;
}

#pragma mark - handleTapGesture
- (void)handleTapGesture:(id)sender {
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *)sender;
    CGPoint point = [tapGestureRecognizer locationInView:self.tabView];
    NSInteger section = point.y / self.tabHeight;
    point = [tapGestureRecognizer locationInView:[[self.tabView subviews] objectAtIndex:section]];
    NSInteger index   = point.x  / self.tabItemWidth;
    
    NSInteger maxCount = [[self.tabsDict objectForKey:[NSNumber numberWithInteger:section]] count];
    index = index < 0 ? 0 : index;
    index = index >= maxCount ? maxCount -1 : index;
    NSLog(@">>>tap in [sec=%d index=%d]",section,index);
    [self setCurrentSelectedIndexPath:[NSIndexPath indexPathForRow:index inSection:section]];

}

#pragma mark - handlerSwipeGesture
- (void)handlerSwipeGesture:(id)sender{
    UISwipeGestureRecognizer *swipeGestureRecognizer = (UISwipeGestureRecognizer *)sender;
    //对于swipe手势只滑动section 0
    NSInteger index =  [[self.currentIndex objectAtIndex:0] integerValue];
    NSInteger toIndex =  swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft ? index + 1 : index -1;
    //toIndex = toIndex < 0 ? [[self.tabsDict objectForKey:[NSNumber numberWithInteger:0]] count] -1 : toIndex;
    NSLog(@">>>swipe from %d to %d",index, toIndex);
    if (toIndex >= 0 && toIndex < [[self.tabsDict objectForKey:[NSNumber numberWithInteger:0]] count] ) {
        [self.currentIndex replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:toIndex]];
        [self transitionFrom:[NSIndexPath indexPathForRow:index inSection:0] toIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0] animation:YES];
    }
}

@end
