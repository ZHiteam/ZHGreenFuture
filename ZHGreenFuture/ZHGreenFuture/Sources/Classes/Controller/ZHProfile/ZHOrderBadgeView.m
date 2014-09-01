//
//  ZHOrderBadgeView.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHOrderBadgeView.h"

@interface ZHOrderBadgeView()
@property(nonatomic, strong)UILabel  *badgeLabel;
@property(nonatomic, strong)UILabel  *countLabel;

@end

#define kBadgeRect         CGRectMake(0, 0, 28, 28)

@implementation ZHOrderBadgeView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.badgeLabel];
        [self addSubview:self.countLabel];
        [self setBadegeCount:nil];
    }
    return self;
}

- (void)awakeFromNib{
    [self addSubview:self.badgeLabel];
    [self addSubview:self.countLabel];
    [self setBadegeCount:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}
#pragma mark - Public Method
- (void)setBadegeCount:(NSString*)count{
    if ([count integerValue] >0) {
        [self setBadgeTitle:count];
    }else {
        self.countLabel.hidden = NO;
        self.badgeLabel.hidden = YES;
        self.countLabel.text = @"0";
    }
}

#pragma mark - Privte Method
- (void)setBadgeTitle:(NSString*)title{
    self.countLabel.hidden = YES;
    self.badgeLabel.hidden = NO;
    self.badgeLabel.layer.cornerRadius  = kBadgeRect.size.height/2.0;
    self.badgeLabel.layer.masksToBounds = YES;
    self.badgeLabel.layer.frame = kBadgeRect;
    self.badgeLabel.text = title;
}

- (UILabel*)badgeLabel{
    if (_badgeLabel == nil) {
        _badgeLabel = [[UILabel alloc] initWithFrame:kBadgeRect];
        _badgeLabel.backgroundColor = RGB(86, 157, 8);
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.font  = [UIFont systemFontOfSize:14];
        _badgeLabel.hidden = YES;
    }
    return _badgeLabel;
}

- (UILabel *)countLabel{
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.textColor = [UIColor blackColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font  = [UIFont systemFontOfSize:22];
    }
    return _countLabel;
}

@end
