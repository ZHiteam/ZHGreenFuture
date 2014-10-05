//
//  ShoppingChartModel.h
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "BaseModel.h"

@interface ShoppingChartModel : BaseModel

@property (nonatomic,strong) NSString*  shoppingChartId;
@property (nonatomic,strong) NSString*  imageURL;
@property (nonatomic,strong) NSString*  title;      /// 商品名称
@property (nonatomic,strong) NSString*  skuInfo;    /// 商品描述
@property (nonatomic,strong) NSString*  marketPrice;
@property (nonatomic,strong) NSString*  promotionPrice;
@property (nonatomic,strong) NSString*  buyCout;
@property (nonatomic,strong) NSString*  productId;
@property (nonatomic,strong) NSString*  validate;

@property (nonatomic,assign)    BOOL    checked;
@property (nonatomic,strong)    NSString*   oldCount;
@end
