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

@interface ZHCatagoryCell : UITableViewCell

@property(nonatomic,strong) CatagoryModel*  catagory;

+(CGFloat)getCellHeightWithCatagoryCount:(NSInteger)catagoryCount;

@end
