//
//  ZHMyProductModel.h
//  ZHGreenFuture
//
//  Created by admin on 14-9-27.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHMyProductItem : NSObject
@property(nonatomic, strong)NSString *workId;
@property(nonatomic, strong)NSString *publishDate;
@property(nonatomic, strong)NSString *workImageURL;
@property(nonatomic, strong)NSArray  *workImageURLArray;
@property(nonatomic, strong)NSString *followName;
@property(nonatomic, strong)NSString *content;
- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end

@interface ZHMyProductModel : NSObject
@property(nonatomic, strong)NSArray         *myProductList;
@property(nonatomic, strong)ZHMyProductItem *productDetail;
- (void)loadDataWithUserId:(NSString*)userId completionBlock:(ZHCompletionBlock)block;
- (void)loadDetailWithId:(NSString*)workId completionBlock:(ZHCompletionBlock)block;

@end
