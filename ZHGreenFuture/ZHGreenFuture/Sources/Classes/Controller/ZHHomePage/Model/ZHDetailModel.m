//
//  ZHDetailModel.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-6.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHDetailModel.h"
#import "ZHHomePageModel.h"

@implementation ZHRecommendRecipeItem
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.imageURL = [dict objectForKey:@"imageURL"];
            self.title    = [dict objectForKey:@"title"];
        }
    }
    return self;
}
@end


@implementation ZHOtherBuyItem
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.imageURL = [dict objectForKey:@"imageURL"];
            self.title    = [dict objectForKey:@"title"];
            self.price    = [dict objectForKey:@"price"];
        }
    }
    return self;
}
@end



@implementation ZHDetailModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMockData];
    }
    return self;
}

#pragma mark - Public Method
- (void)loadDataWithProductId:(NSString*)productId completionBlock:(ZHCompletionBlock)block{
    __weak __typeof(self) weakSelf = self;
    
    [HttpClient requestDataWithParamers:@{@"scene": @"10",@"productId":productId} success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [weakSelf parserJsonDict:responseObject];
        }
        if (block) {
            block(YES);
        }
    } failure:^(NSError *error) {
        if (block) {
            block(NO);
        }
    }];
}


#pragma mark - Privte Method
- (void)initMockData{
    //1.banner
    //ZHBannerItem *bannerItem = [[ZHBannerItem alloc] init];
    //bannerItem.imageURL = @"http://gw2.alicdn.com/bao/uploaded/i3/T1QPnBFmleXXXXXXXX_!!0-item_pic.jpg";
    ZHBannerItem *bannerItem1 = [[ZHBannerItem alloc] init];
    bannerItem1.placeholderImage = @"detailBanner.png";
    self.bannerImages = @[bannerItem1,bannerItem1,bannerItem1,bannerItem1];
    self.title        = @"【三千禾】 东北特产燕麦米 粗粮五谷农家杂粮金胚芽燕麦仁420g*2";
    self.promotionPrice = @"29.80";
    self.marketPirce    = @"38.90";
    
    self.salesCount     = @"2000";
    self.fromPlace      = @"产地通榆";
    
    self.introduceImageList = @[@"", @"",@""];
    
    ZHRecommendRecipeItem * recipeItem = [[ZHRecommendRecipeItem alloc] init];
    recipeItem.title = @"豌豆糯米饭";
    recipeItem.imageURL = @"";
    recipeItem.placeholderImage = @"detailRecipe.png";
    self.recommendRecipeList = @[recipeItem , recipeItem, recipeItem, recipeItem, recipeItem,recipeItem,recipeItem,recipeItem];
    
    //other buy products list
    ZHOtherBuyItem *buyItem = [[ZHOtherBuyItem alloc] init];
    buyItem.imageURL = @"";
    buyItem.title    = @"东北农家五常大米吉林长春香米 新米不断";
    buyItem.price    = @"29.80";
    self.otherBuyList= @[buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem];
}

- (void)parserJsonDict:(NSDictionary*)jsonDict{
    
    NSArray *srcArray = nil;
    NSMutableArray *dstArray = [NSMutableArray arrayWithCapacity:10];
    //banner
    srcArray = [jsonDict objectForKey:@"bannerImageList"];
    for (NSString *imageUrl in srcArray) {
        if ([imageUrl length] >0) {
            ZHBannerItem *item = [[ZHBannerItem alloc] init];
            item.imageURL = imageUrl;
            [dstArray addObject:item];
        }
    }
//    for (NSDictionary *banner in srcArray) {
//        ZHBannerItem  *obj = [[ZHBannerItem alloc] initWithDictionary:banner];
//        [dstArray addObject:obj];
//    }
    self.bannerImages = [dstArray copy];
    
    //introduceImageList
    [dstArray removeAllObjects];
    srcArray = [jsonDict objectForKey:@"introduceImageList"];
    for (NSString *imageURL in srcArray) {
        [dstArray addObject:imageURL];
    }
    self.introduceImageList = [dstArray copy];
    
    //recommendRecipeList
    [dstArray removeAllObjects];
    srcArray = [jsonDict objectForKey:@"recommendRecipeList"];
    for (NSDictionary *dict in srcArray) {
        ZHRecommendRecipeItem *obj = [[ZHRecommendRecipeItem alloc] initWithDictionary:dict];
        [dstArray addObject:obj];
    }
    self.recommendRecipeList = [dstArray copy];
    
    //otherBuyList
    [dstArray removeAllObjects];
    srcArray = [jsonDict objectForKey:@"otherBuyList"];
    for (NSDictionary *dict in srcArray) {
        ZHOtherBuyItem *obj = [[ZHOtherBuyItem alloc] initWithDictionary:dict];
        [dstArray addObject:obj];
    }
    self.otherBuyList = [dstArray copy];
    
    
    self.title          = [jsonDict objectForKey:@"title"];
    self.productId      = [NSString stringWithFormat:@"%d",[[jsonDict objectForKey:@"productId"] integerValue]];
    self.marketPirce    = [NSString stringWithFormat:@"%.2f",[[jsonDict objectForKey:@"marketPirce"] floatValue]];
    self.promotionPrice = [NSString stringWithFormat:@"%.2f",[[jsonDict objectForKey:@"promotionPrice"] floatValue]];
    self.fromPlace      = [NSString stringWithFormat:@"%.2f",[[jsonDict objectForKey:@"fromPlace"] floatValue]];
    self.skuInfo        = [jsonDict objectForKey:@"skuInfo"];
    if ([[jsonDict objectForKey:@"salesCount"] isKindOfClass:[NSNumber class]]) {
        self.salesCount = [NSString stringWithFormat:@"%d",[[jsonDict objectForKey:@"salesCount"] integerValue]];
    } else {
        self.salesCount = [jsonDict objectForKey:@"salesCount"];
    }
}

@end
