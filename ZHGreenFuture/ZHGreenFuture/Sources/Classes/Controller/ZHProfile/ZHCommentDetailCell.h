//
//  ZHCommentDetailCell.h
//  ZHGreenFuture
//
//  Created by admin on 14-12-16.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHCommentDetailCell : UITableViewCell
- (IBAction)goodCommentPressed:(id)sender;
- (IBAction)midCommentPressed:(id)sender;
- (IBAction)badCommentPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property(nonatomic, assign)NSInteger commentType;

+ (instancetype)tableViewCell;
+ (CGFloat)height;
@end
