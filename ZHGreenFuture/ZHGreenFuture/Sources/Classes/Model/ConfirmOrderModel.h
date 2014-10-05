//
//  ConfirmOrderModel.h
//  ZHGreenFuture
//
//  Created by elvis on 10/5/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "BaseModel.h"
#import "ShoppingChartModel.h"

@interface ConfirmOrderModel : BaseModel

@property (nonatomic,strong) NSString* productTotalPrice;   /// 商品总价
@property (nonatomic,strong) NSString* reducePrice;         /// 优惠
@property (nonatomic,strong) NSString* express;             /// 运费
@property (nonatomic,strong) NSString* totalPrice;          /// 总计
@property (nonatomic,strong) NSString* shoppingCartIdList;  /// 购物车串
@property (nonatomic,strong) NSArray*  shoppingList;        /// 商品列表
@property (nonatomic,strong) AddressModel* receiveInfo;     /// 收货地址

@end
