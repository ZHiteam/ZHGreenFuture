//
//  ZHProductComment.m
//  ZHGreenFuture
//
//  Created by admin on 14-12-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHProductComment.h"

@implementation ZHCommentItem

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.userAvatarURL = [dict objectForKey:@"userAvatarURL"];
            self.userName      = [dict objectForKey:@"nickName"];
            self.content       = VALIDATE_VALUE([dict objectForKey:@"content"]);
            self.date          = VALIDATE_VALUE([dict objectForKey:@"commentDate"]);
            NSString *type     =  VALIDATE_VALUE([dict objectForKey:@"evaluateState"]);
            if ([type integerValue] == 1) {
                type = @"好评";
            } else if ([type integerValue] == 2) {
                type = @"中评";
            } else if ([type integerValue] == 3) {
                type = @"差评";
            }
            self.type = type;
        }
    }
    return self;
}
@end

@implementation ZHProductComment

#pragma mark - Public Method
- (void)loadCommentWithProductId:(NSString*)productId completionBlock:(ZHCompletionBlock)block{
    __weak __typeof(self) weakSelf = self;
    /*NSDictionary* dic = @{@"productId": productId};
    NSString* jsonStr = [dic JSONFragment];
    dic = @{@"json":jsonStr,@"scene":@"35"};
    [HttpClient requestDataWithParamers:dic success:^(id responseObject) {
        BOOL result = NO;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            result =[[responseObject objectForKey:@"result"] isEqualToString:@"true"];
        }
        if (block) {
            block(result);
        }
    } failure:^(NSError *error) {
        if (block){
            block(NO);
        }
    }];
    
    return;
    */
    
    [HttpClient requestDataWithParamers:@{@"scene": @"36",@"productId":productId} success:^(id responseObject) {
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


- (void)parserJsonDict:(NSDictionary*)jsonDict{
    NSArray *srcArray = nil;
    NSMutableArray *dstArray = [NSMutableArray arrayWithCapacity:10];
    srcArray = [jsonDict objectForKey:@"commentList"];
    for (NSDictionary *dict in srcArray) {
        ZHCommentItem *obj = [[ZHCommentItem alloc] initWithDictionary:dict];
        [dstArray addObject:obj];
    }
    self.commentArray = [dstArray copy];
}

@end
