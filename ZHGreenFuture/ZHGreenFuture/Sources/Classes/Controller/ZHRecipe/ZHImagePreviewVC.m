//
//  ZHImagePreviewVC.m
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHImagePreviewVC.h"

@interface ZHImagePreviewVC ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView*      contentView;
@property (nonatomic,strong) NSMutableArray*    imageViews;
@end

@implementation ZHImagePreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view removeGestureRecognizer:self.swipeBack];
    
    [self loadContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIScrollView *)contentView{
    
    if (!_contentView){
        _contentView = [[UIScrollView alloc]initWithFrame:self.contentBounds];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.pagingEnabled = YES;
        _contentView.delegate = self;
    }
    
    return _contentView;
}

-(NSMutableArray *)imageViews{
    if (!_imageViews){
        _imageViews = [[NSMutableArray alloc]initWithCapacity:1];
    }
    return _imageViews;
}

-(void)layoutContentView{
    
    [self.contentView removeAllSubviews];
    
    CGFloat xOffset = 0;
    
    for (int i = 0; i < self.images.count; ++i){
        UIImageView* imageView = nil;
        if (self.imageViews.count > i){
            imageView = self.imageViews[i];
        }
        else{
            imageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.imageViews addObject:imageView];
        }
        
        imageView.left = xOffset;
        imageView.image = self.images[i];
        xOffset += imageView.width;
        
        [self.contentView addSubview:imageView];
    }
    
    self.contentView.contentSize = CGSizeMake(xOffset, self.contentView.height);
    
    xOffset = self.curIndex*self.contentView.width;
    if (xOffset > self.contentView.contentSize.width){
        self.curIndex = 1;
        xOffset = 0;
    }
    
    xOffset -= self.contentView.width;
    
    [self.contentView setContentOffset:CGPointMake(xOffset, 0) animated:YES];
    
    if (self.images.count){
        self.navigationBar.title = [NSString stringWithFormat:@"%d/%d",self.curIndex,self.images.count];
    }
    else{
        self.navigationBar.title = @"";
    }

}

-(void)loadContent{
    if (self.userInfo[@"images"] && !self.images){
        self.images = self.userInfo[@"images"];
    }
    
    if (self.userInfo[@"selectIndex"]){
        self.curIndex = [self.userInfo[@"selectIndex"] integerValue]+1;
        if (self.curIndex > self.images.count){
            self.curIndex = 1;
        }
        
    }
    
    self.navigationBar.title = @"";
    
    [self whithNavigationBarStyle];
    
    self.view.backgroundColor = BLACK_TEXT;
    
    self.navigationBar.rightBarItem = [UIButton barItemWithTitle:@"" image:[UIImage themeImageNamed:@"btn_delete"] action:self selector:@selector(deleteAction)];
    
    [self.view addSubview:self.contentView];
    
    [self layoutContentView];
}

#pragma -mark deleteAction
-(void)deleteAction{
    NSInteger index = self.curIndex-1;
    if (self.images.count <= index || index < 0){
        return;
    }
    
    self.curIndex = (index==0)?1:index;
    [self.images removeObjectAtIndex:index];

    if ( 0 == self.images.count){
        [self.navigationCtl pop];
    }
    
    [self layoutContentView];
}

#pragma -mark UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    int index = offset/scrollView.width;
    self.curIndex = index+1;
    
    self.navigationBar.title = [NSString stringWithFormat:@"%d/%d",self.curIndex,self.images.count];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self scrollViewDidEndDecelerating:scrollView];
}
@end
