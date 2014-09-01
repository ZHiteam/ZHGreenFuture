//
//  ZHCatagoryCell.h
//  ZHGreenFuture
//
//  Created by elvis on 8/31/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatagoryModel.h"

#define CELL_BOTTOM_SPAN    12
#define CELL_PER_HEIGHT     50
#define CELL_HEIGHT_SPAN    8

@protocol ZHCatagoryCellDelegate;

@interface ZHCatagoryCell : UITableViewCell

@property (nonatomic,assign) NSInteger          cellIndex;
@property (nonatomic,strong) CatagoryModel*     catagory;
@property (nonatomic,assign) id                 cellDelegate;

+(CGFloat)getCellHeightWithCatagoryCount:(NSInteger)catagoryCount;

-(void)reloadData;
@end

@protocol ZHCatagoryCellDelegate
@optional

/**
 * @brief   点击Cell回调
 * @param   -index cell的索引
 * @param   -catagoryIndex : -1 点击总类别 ; 0--count:点击子类别（从0开始）
 */
-(void)catagorySelectedAtIndex:(NSIndexPath*)index;
@end