//
//  ZHShoppingChartCell.h
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingChartModel.h"

@interface ZHShoppingChartCell : UITableViewCell

@property (nonatomic,strong) ShoppingChartModel* model;
@property (nonatomic,assign) BOOL chartEditing;

@property (nonatomic,assign) BOOL checked;

+(CGFloat)cellHeight;
@end
