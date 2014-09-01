//
//  ZHCatagoryCell.m
//  ZHGreenFuture
//
//  Created by elvis on 8/31/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHCatagoryCell.h"

@interface ZHCatagoryCell()

@end

@implementation ZHCatagoryCell

-(void)prepareForReuse{
    
}

+(CGFloat)getCellHeightWithCatagoryCount:(NSInteger)catagoryCount{
    
    return CELL_BOTTOM_SPAN + catagoryCount/3*CELL_PER_HEIGHT + ((catagoryCount%3 == 0)?0:CELL_PER_HEIGHT);
}

@end
