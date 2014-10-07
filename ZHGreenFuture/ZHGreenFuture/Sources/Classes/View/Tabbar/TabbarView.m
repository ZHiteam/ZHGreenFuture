//
//  TabbarView.m
//  Stock4HKWF
//
//  Created by elvis on 13-9-4.
//  Copyright (c) 2013年 HKWF. All rights reserved.
//

#import "TabbarView.h"

@interface TabbarView(){
    NSUInteger      _selectedIndex;
    
    NSMutableArray* _barItems;
    
    UIImageView*    _selectedView;
}

-(void)intTabbar;
@end

@implementation TabbarView

-(id)init{
    self = [super init];
    if (self) {
        [self intTabbar];
        
        [self reloadData];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self intTabbar];
        
        [self reloadData];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma -mark
#pragma -mark init baritems
-(void)intTabbar{
    _selectedIndex = 0;
    _barItems = [[NSMutableArray alloc]init];
    _selectedView = [[UIImageView alloc]init];

}

-(void)reloadData{
    if (!_dataSource || ![_dataSource respondsToSelector:@selector(tabbar:itemAtIndex:)]) {
        return;
    }
    NSUInteger count = 0;
    if ([_dataSource respondsToSelector:@selector(numberOfItems)]){
        count = [_dataSource numberOfItems];
    }
    
    if (0 == count) {
        return;
    }
    
    /// 清除之前数据
    [self removeAllSubviews];
    [_barItems removeAllObjects];
    
    /// 设置背景图片
    BOOL deal = NO;
    if ([_dataSource respondsToSelector:@selector(backgroundImage)]) {
        
        UIImage* image= [_dataSource backgroundImage];
        if (image) {
            deal = YES;
        }
        self.backgroundColor = [UIColor colorWithPatternImage:[_dataSource backgroundImage]];
    }
    
    if (!deal && [_dataSource respondsToSelector:@selector(backgroundView)]) {
        UIView* bgView = [_dataSource backgroundView];
        if (bgView){
            bgView.frame = self.bounds;
            [self addSubview:bgView];
            
            deal = YES;
        }
    }
    
    if (!deal) {
        self.backgroundColor = RGBA(0xff, 0xff, 0xff, 0.8);
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 1)];
        line.backgroundColor = RGB(176, 176, 176);
        [self addSubview:line];
    }
    
    /// 设置选中背景
    if ([_dataSource respondsToSelector:@selector(selectedImage)]) {
        _selectedView.image = [_dataSource selectedImage];
    }
    
    /// 设置初始值
    if (_selectedIndex >= count) {
        _selectedIndex = 0;
    }
    
    /// 设置bar item
    CGFloat width = self.width/count;
    CGFloat height = TAB_BAR_HEIGHT;
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    
    for (NSUInteger index = 0; index < count; ++index) {
        TabbarItem* item = [_dataSource tabbar:self itemAtIndex:index];
        
        if (!item) {
            continue;
        }
        /// 设置选中事件
        [item addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        
        item.frame = CGRectMake(xOffset, yOffset, width, height);
        xOffset += width;
        
        [_barItems addObject:item];
        
        [self addSubview:item];
    }
    
#pragma -mark 根据不同展示类型
    /// 设置选中View
//    _selectedView.frame = ((UIView*)_barItems[_selectedIndex]).frame;
//    [self addSubview:_selectedView];
//    [self sendSubviewToBack:_selectedView];
    
    TabbarItem* selectItem = [_barItems objectAtIndex:_selectedIndex];
    selectItem.selected = YES;
}

-(void)selectItem:(TabbarItem*)item{
    
    /// 越界判断
    NSUInteger index = [_barItems indexOfObject:item];
    if (index >= [_barItems count]) {
        return;
    }
    
    if (index == _selectedIndex) {
        return;
    }
    
    /// 是否能够被选中
    if ([_delegate respondsToSelector:@selector(tabbar:shouldSelectedAtIndex:)]) {
        if (![_delegate tabbar:self shouldSelectedAtIndex:index]) {
            return;
        }
    }
    
    /// 做动画前，通知将要选中
    if ([_delegate respondsToSelector:@selector(tabbar:willSelectedAtIndex:)]) {
        [_delegate tabbar:self willSelectedAtIndex:index];
    }
    
    /// 做动画
    [self _animationToIndex:index];
}

-(void)_animationToIndex:(NSUInteger)toIndex{
    @try {
//        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
//            _selectedView.frame = ((UIView*)[_barItems objectAtIndex:toIndex]).frame;
//        } completion:^(BOOL finished) {
//            
//            [self _selectToIndexDone:toIndex];
//        }];
        
//        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
//
//            
//            TabbarItem* curItem = [_barItems objectAtIndex:_selectedIndex];
//            curItem.alpha = 0.5;
//            
//        } completion:^(BOOL finished) {
            TabbarItem* curItem = [_barItems objectAtIndex:_selectedIndex];
            TabbarItem* nextItem = [_barItems objectAtIndex:toIndex];
            
//            curItem.alpha = 1.0;
            curItem.selected = NO;
            nextItem.selected  =YES;
            
            [self _selectToIndexDone:toIndex];
//        }];
    }
    @catch (NSException *exception) {
        FELOG(@"%@",exception);
    }
    @finally {
        
    }

}

-(void)_selectToIndexDone:(NSUInteger)aIndex{
    _selectedIndex = aIndex;
    /// 选中通知
    if ([_delegate respondsToSelector:@selector(tabbar:didSelectedAtIndex:)]) {
        [_delegate tabbar:self didSelectedAtIndex:_selectedIndex];
    }
    
//    [NSObject showNotice:[NSString stringWithFormat:@"当前选中tabbar item 变为：%d",_selectedIndex]];
}

-(void)selectAtIndex:(NSUInteger)aIndex animation:(BOOL)animation{
    if (aIndex >= [_barItems count]) {
        return;
    }
    
    if (!animation) {
        _selectedView.frame = ((UIView*)[_barItems objectAtIndex:aIndex]).frame;
        
        [self _selectToIndexDone:aIndex];
        
    }else{
        [self _animationToIndex:aIndex];
    }
}

-(NSUInteger)selectedIndex{
    return _selectedIndex;
}

@end
