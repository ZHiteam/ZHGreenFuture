//
//  ZHAddressCell.h
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface ZHAddressCell : UITableViewCell

@property (nonatomic,strong) AddressModel*  model;

+(CGFloat)cellHeight;
@end
