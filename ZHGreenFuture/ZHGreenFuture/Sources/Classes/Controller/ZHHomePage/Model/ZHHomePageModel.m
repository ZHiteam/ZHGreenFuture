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
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.imageURL = [dict objectForKey:@"imageURL"];
            self.clickImageURL = [dict objectForKey:@"clickImageURL"];
        }
    }
    return self;
}

- (NSString*)title{
    return nil;
}
@end

@implementation ZHCategoryItem
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.categoryId = [dict objectForKey:@"categoryId"];
            self.iconURL    = [dict objectForKey:@"iconURL"];
            self.title      = [dict objectForKey:@"title"];
            self.innerURL   = [dict objectForKey:@"innerURL"];
        }
    }
    return self;
}
@end

@implementation ZHCalenderItem
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.title    = [dict objectForKey:@"title"];
            self.subTitle = [dict objectForKey:@"subTitle"];
            self.date     = [dict objectForKey:@"time"];
        }
    }
    return self;
}
@end

@implementation ZHCreditsItem
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.imageURL      = [dict objectForKey:@"imageURL"];
            self.clickImageURL = [dict objectForKey:@"clickImageURL"];
        }
    }
    return self;
}
@end

@implementation ZHSurpriseItem
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.imageURL      = [dict objectForKey:@"imageURL"];
            self.clickImageURL = [dict objectForKey:@"clickImageURL"];
        }
    }
    return self;
}
@end

@interface ZHHomePageModel ()
@property(nonatomic, assign)NSInteger pageNumber;
@end


@implementation ZHHomePageModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        //[self initMockData];
        self.pageNumber = 0;
        self.isHaveMore = YES;
    }
    return self;
}

#pragma mark - Public Method
- (void)loadDataWithCompletion:(ZHCompletionBlock)block{
    __weak __typeof(self) weakSelf = self;

    [HttpClient requestDataWithParamers:@{@"scene": @"1"} success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [weakSelf parserJsonDict:responseObject];
        }
        if (block) {
            block(YES);
        }
    } failure:^(NSError *error) {
        if (block){
            block(NO);
        }
    }];
}

- (void)loadMoreWithCompletion:(ZHCompletionBlock)block{
    if (!self.isHaveMore) {
        block(NO);
        return;
    }
    
    self.pageNumber++;
    __weak __typeof(self) weakSelf = self;
    
    [HttpClient requestDataWithParamers:@{@"scene": @"2",@"gotoPage":[NSString stringWithFormat:@"%d",self.pageNumber]} success:^(id responseObject) {
        if ([[responseObject objectForKey:@"lastPage"] boolValue]) {
            weakSelf.isHaveMore = NO;
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *dstArray = [NSMutableArray arrayWithArray:self.productItems];
            NSArray *srcArray = [responseObject objectForKey:@"freshList"];
            if ([srcArray count] >0) {
                for (NSDictionary *banner in srcArray) {
                    ZHProductItem * obj = [[ZHProductItem alloc] initWithDictionary:banner];
                    [dstArray addObject:obj];
                }
                self.productItems = [dstArray copy];
            }
        }
        if (block) {
            block(YES);
        }
    } failure:^(NSError *error) {
        if (block){
            block(NO);
        }
    }];
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

- (void)parserJsonDict:(NSDictionary*)jsonDict{

    NSArray *srcArray = nil;
    NSMutableArray *dstArray = [NSMutableArray arrayWithCapacity:10];
    //banner
    srcArray = [jsonDict objectForKey:@"banners"];
    for (NSDictionary *banner in srcArray) {
        ZHBannerItem * obj = [[ZHBannerItem alloc] initWithDictionary:banner];
        [dstArray addObject:obj];
    }
    self.bannerItems = [dstArray copy];
    
    //category
    [dstArray removeAllObjects];
    srcArray = [jsonDict objectForKey:@"category"];
    for (NSDictionary *banner in srcArray) {
        ZHCategoryItem * obj = [[ZHCategoryItem alloc] initWithDictionary:banner];
        [dstArray addObject:obj];
    }
    //add more
    ZHCategoryItem * obj = [[ZHCategoryItem alloc] init];
    obj.title     = @"更多";
    obj.innerURL  = ZHCategoryMoreUrl;
    obj.imageName = @"category_more";
    [dstArray addObject:obj];
    self.categoryItems = [dstArray copy];
    
    //calender
    self.calenderItem = [[ZHCalenderItem alloc] initWithDictionary:[jsonDict objectForKey:@"calender"]];
    
    //creditsImage
    self.creditsItem = [[ZHCreditsItem alloc] initWithDictionary:[jsonDict objectForKey:@"creditsImage"]];
    
    //surpriseImage
    self.surpriseItem = [[ZHSurpriseItem alloc] initWithDictionary:[jsonDict objectForKey:@"surpriseImage"]];

    //freshTotal
    self.productCounts = [[jsonDict objectForKey:@"freshTotal"] integerValue];
    
    //freshList
    [dstArray removeAllObjects];
    srcArray = [jsonDict objectForKey:@"freshList"];
    for (NSDictionary *banner in srcArray) {
        ZHProductItem * obj = [[ZHProductItem alloc] initWithDictionary:banner];
        [dstArray addObject:obj];
    }
    self.productItems = [dstArray copy];
}

@end
