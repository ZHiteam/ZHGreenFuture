//
//  ZHMyProductDetailVC.h
//  ZHGreenFuture
//
//  Created by admin on 14-9-27.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHMyProductModel.h"
@interface ZHMyProductDetailVC : ZHViewController
@property(nonatomic, strong)ZHMyProductItem  * myProductItem;
@property(nonatomic, strong)ZHMyProductModel * myProductModel;
@end
