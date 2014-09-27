//
//  ZHShoppingChartCell.h
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingChartModel.h"

@protocol ZHShoppingChartDelegate<NSObject>
-(void)selectChartWithModel:(ShoppingChartModel*)model;
-(void)deSelectChartWithModel:(ShoppingChartModel*)model;
-(void)countChangeAtIndex:(NSInteger)index count:(NSString*)count;
@end

@interface ZHShoppingChartCell : UITableViewCell

@property (nonatomic,strong) id delegate;
@property (nonatomic,strong) ShoppingChartModel* model;
@property (nonatomic,assign) BOOL chartEditing;
@property (nonatomic,assign) BOOL checked;
@property (nonatomic,assign) NSInteger index;

@property (nonatomic,assign) BOOL showCheckBox;
+(CGFloat)cellHeight;
@end
