//
//  ZHHomePageModel.h
//  ZHGreenFuture
//
//  Created by admin on 14-8-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHProductItem.h"


@interface ZHBannerItem : NSObject <FEImageItemProtocol>
@property(nonatomic, strong)NSString *imageURL;
@property(nonatomic, strong)NSString *clickImageURL;
@property(nonatomic, strong)NSString *placeholderImage;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, assign)NSInteger tag;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end

@interface ZHCategoryItem : NSObject
@property(nonatomic ,strong)NSString *categoryId;
@property(nonatomic ,strong)NSString *iconURL;
@property(nonatomic ,strong)NSString *title;
@property(nonatomic ,strong)NSString *innerURL;
@property(nonatomic ,strong)NSString *imageName;//only use for more
- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end

@interface ZHCalenderItem : NSObject
@property(nonatomic ,strong)NSString *date;
@property(nonatomic ,strong)NSString *title;
@property(nonatomic ,strong)NSString *subTitle;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end

@interface ZHCreditsItem : NSObject
@property(nonatomic ,strong)NSString *imageURL;
@property(nonatomic ,strong)NSString *clickImageURL;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end

@interface ZHSurpriseItem : NSObject
@property(nonatomic ,strong)NSString *imageURL;
@property(nonatomic ,strong)NSString *clickImageURL;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end

@interface ZHHomePageModel : NSObject
@property(nonatomic, strong)NSArray *bannerItems;   //ZHBannerItem
@property(nonatomic, strong)NSArray *categoryItems; //ZHCategoryItem
@property(nonatomic, strong)ZHCalenderItem *calenderItem;
@property(nonatomic, strong)ZHCreditsItem  *creditsItem;
@property(nonatomic, strong)ZHSurpriseItem *surpriseItem;
@property(nonatomic, strong)NSArray *productItems;  //
@property(nonatomic, assign)NSInteger productCounts;
@property(nonatomic, assign)BOOL      isHaveMore;

- (void)loadDataWithCompletion:(ZHCompletionBlock)block;
- (void)loadMoreWithCompletion:(ZHCompletionBlock)block;
@end


