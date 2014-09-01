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
    [HttpClient requestDataWithURL:@"xxx" paramers:nil success:^(id responseObject) {
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
    self.waitPayCount = @"45";
    self.waitCommentCount = @"0";
    self.deliverCount = @"8";
}

@end
