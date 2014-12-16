//
//  ZHCommentDetailCell.m
//  ZHGreenFuture
//
//  Created by admin on 14-12-16.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHCommentDetailCell.h"

@implementation ZHCommentDetailCell

- (void)awakeFromNib {
    // Initialization code
    self.inputTextView.layer.cornerRadius = 6.0;
    self.inputTextView.layer.masksToBounds = YES;
    self.goodButton.selected = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Public Method
- (IBAction)goodCommentPressed:(id)sender {
    self.commentType = 1;
    self.goodButton.selected = YES;
    self.badButton.selected = NO;
    self.midButton.selected = NO;
}

- (IBAction)midCommentPressed:(id)sender {
    self.commentType = 2;
    self.goodButton.selected = NO;
    self.badButton.selected = NO;
    self.midButton.selected = YES;
}

- (IBAction)badCommentPressed:(id)sender {
    self.commentType = 3;
    self.goodButton.selected = NO;
    self.badButton.selected = YES;
    self.midButton.selected = NO;
}

+ (instancetype)tableViewCell{
    id obj =  [self instanceWithNibName:@"ZHCommentDetailCell" bundle:nil owner:nil];
    if ([obj isKindOfClass:[ZHCommentDetailCell class]]) {
        ZHCommentDetailCell *cell = obj;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, cell.bounds.size.height-0.5, [UIScreen mainScreen].bounds.size.width -24, 0.5)];
        view.backgroundColor = RGB(204, 204, 204);
        [cell.contentView addSubview:view];
        return cell;
    }
    return nil;
}

+ (CGFloat)height{
    return 77.0f;
}

@end
