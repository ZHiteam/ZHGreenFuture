//
//  ZHDetailModel.h
//  ZHGreenFuture
//
//  Created by admin on 14-9-6.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface recommendRecipeItem : NSObject <FEImageItemProtocol>
@property(nonatomic, strong)NSString *imageURL;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, assign)NSInteger tag;
@property(nonatomic, strong)NSString *placeholderImage;

@end


@interface otherBuyItem : NSObject
@property(nonatomic, strong)NSString *imageURL;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *price;
@property(nonatomic ,strong)NSString *productId;
@end

@interface ZHDetailModel : NSObject
@property(nonatomic, strong)NSArray  *bannerImages;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *marketPirce;
@property(nonatomic, strong)NSString *promotionPrice;
@property(nonatomic, strong)NSString *salesCount;
@property(nonatomic, strong)NSString *fromPlace;
@property(nonatomic, strong)NSString *skuInfo;
@property(nonatomic, strong)NSArray  *introduceImageList;
@property(nonatomic, strong)NSArray  *recommendRecipeList;   //recommendRecipeItem
@property(nonatomic, strong)NSArray  *otherBuyList;          //otherBuyItem

- (void)loadDataWithCompletion:(ZHCompletionBlock)block;
@end
