//
//  ZHHomePageModel.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHHomePageModel.h"
#import "HttpClient.h"


@implementation ZHBannerItem
- (NSString*)title{
    return nil;
}
@end

@implementation ZHCategoryItem

@end

@implementation ZHCalenderItem

@end

@implementation ZHCreditsItem

@end

@implementation ZHSurpriseItem

@end

@implementation ZHProductItem


@end

@implementation ZHHomePageModel
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
    ZHBannerItem *bannerItem = [[ZHBannerItem alloc] init];
    bannerItem.imageURL = @"http://gw2.alicdn.com/bao/uploaded/i3/T1QPnBFmleXXXXXXXX_!!0-item_pic.jpg";
    ZHBannerItem *bannerItem1 = [[ZHBannerItem alloc] init];
    bannerItem1.placeholderImage = @"bannerPlaceholder.png";
    self.bannerItems = @[bannerItem1,bannerItem,bannerItem1,bannerItem];
    //2.catetory
    ZHCategoryItem *item = [[ZHCategoryItem alloc] init];
    item.title = @"大米";
    self.categoryItems = @[item,item,item,item,item,item,item,item];
    //3.recommend
    ZHCalenderItem *calenderItem = [[ZHCalenderItem alloc] init];
    calenderItem.date = @"辰时";
    calenderItem.title= @"气血经胃，宜早饭";
    calenderItem.subTitle = @"看看大家的早饭食谱";
    self.calenderItem = calenderItem;
    
    ZHSurpriseItem *surpriseItem = [[ZHSurpriseItem alloc] init];
    self.surpriseItem = surpriseItem;
    
    self.creditsItem = [[ZHCreditsItem alloc] init];
    //4.product
    ZHProductItem *productItem = [[ZHProductItem alloc] init];
    productItem.title = @"东北特产全胚芽燕麦850g";
    productItem.subTitle = @"它的营养价值很高，其脂肪含量是大米的4倍";
    productItem.price = @"288.81";
    productItem.buyCount = @"435";
    self.productItems = @[productItem, productItem, productItem, productItem,productItem,productItem,productItem,productItem,productItem,productItem];
}

- (void)loadDataWithCompletion:(ZHCompletionBlock)block{
    return;
    [HttpClient requestDataWithURL:@"xxx" paramers:nil success:^(id responseObject) {
         
     } failure:^(NSError *error) {
         
     }];
}

@end
