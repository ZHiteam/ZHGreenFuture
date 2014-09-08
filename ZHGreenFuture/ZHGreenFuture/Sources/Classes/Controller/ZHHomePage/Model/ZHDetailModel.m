//
//  ZHDetailModel.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-6.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHDetailModel.h"
#import "ZHHomePageModel.h"

@implementation recommendRecipeItem

@end


@implementation otherBuyItem

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
    
    recommendRecipeItem * recipeItem = [[recommendRecipeItem alloc] init];
    recipeItem.title = @"豌豆糯米饭";
    recipeItem.imageURL = @"";
    recipeItem.placeholderImage = @"detailRecipe.png";
    self.recommendRecipeList = @[recipeItem , recipeItem, recipeItem, recipeItem, recipeItem,recipeItem,recipeItem,recipeItem];
    
    //other buy products list
    otherBuyItem *buyItem = [[otherBuyItem alloc] init];
    buyItem.imageURL = @"";
    buyItem.title    = @"东北农家五常大米吉林长春香米 新米不断";
    buyItem.price    = @"29.80";
    self.otherBuyList= @[buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem,buyItem];
}

- (void)loadDataWithCompletion:(ZHCompletionBlock)block{
    return;
    [HttpClient requestDataWithURL:@"xxx" paramers:nil success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

@end
