//
//  ZHProductItem.h
//  ZHGreenFuture
//
//  Created by elvis on 9/1/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "BaseModel.h"

@interface ZHProductItem : BaseModel
@property(nonatomic ,strong)NSString *imageURL;
@property(nonatomic ,strong)NSString *title;
@property(nonatomic ,strong)NSString *subTitle;
@property(nonatomic ,strong)NSString *price;
@property(nonatomic ,strong)NSString *buyCount;
@property(nonatomic ,strong)NSString *productId;

@end
