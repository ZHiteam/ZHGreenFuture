//
//  ZHProfileModel.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHProfileModel.h"

@implementation ZHProfileModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMockData];
    }
    return self;
}

#pragma mark - Public Method
- (void)loadDataWithCompletion:(ZHCompletionBlock)block{
    __weak __typeof(self) weakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//这里设置是因为服务端返回的类型是text/html，不在AF默认设置之列
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    [manager GET:BASE_URL parameters:@{@"scene": @"8"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [weakSelf parserJsonDict:responseObject];
        }
        if (block) {
            block(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(NO);
        }
    }];

}

#pragma mark - Privte Method
- (void)initMockData{
    self.waitPayCount = @"45";
    self.waitCommentCount = @"0";
    self.deliverCount = @"8";
}


- (void)parserJsonDict:(NSDictionary*)jsonDict{
    if ([jsonDict isKindOfClass:[NSDictionary class]]) {
        self.backgoundImageUrl = [jsonDict objectForKey:@"backgoundImageUrl"];
        self.userAvatar        = [jsonDict objectForKey:@"userAvatar"];
        self.userName          = [jsonDict objectForKey:@"userNickName"];
        NSDictionary *orderDict = [jsonDict objectForKey:@"order"];
        if ([orderDict isKindOfClass:[NSDictionary class]]) {
            self.waitPayCount       = [NSString stringWithFormat:@"%d",[[orderDict objectForKey:@"waitPayCount"] integerValue]];
            self.deliverCount       = [NSString stringWithFormat:@"%d",[[orderDict objectForKey:@"deliverCount"] integerValue]];
            self.comfirmShoppingCount = [NSString stringWithFormat:@"%d",[[orderDict objectForKey:@"comfirmShoppingCount"] integerValue]];
            self.waitCommentCount     = [NSString stringWithFormat:@"%d",[[orderDict objectForKey:@"waitCommentCount"] integerValue]];
        }
    }
}

@end
