//
//  ZHAddressCell.h
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@protocol ZHAddressCellDelegate

-(void)setDefaultWithModel:(AddressModel*)model index:(NSInteger)index isDefault:(BOOL)isDefault;

-(void)editWithModel:(AddressModel*)model index:(NSInteger)index;

-(void)deleteWithModel:(AddressModel*)model index:(NSInteger)index;
@end

@interface ZHAddressCell : UITableViewCell

@property (nonatomic,strong) AddressModel*  model;
@property (nonatomic,assign) NSInteger      index;
@property (nonatomic,assign) id<ZHAddressCellDelegate>  delegate;

+(CGFloat)cellHeight;
@end
