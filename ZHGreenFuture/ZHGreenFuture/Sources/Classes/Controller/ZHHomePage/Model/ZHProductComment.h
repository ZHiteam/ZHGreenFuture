//
//  ZHProductComment.h
//  ZHGreenFuture
//
//  Created by admin on 14-12-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHCommentItem : NSObject
@property(nonatomic, strong)NSString *userAvatarURL;
@property(nonatomic, strong)NSString *userName;
@property(nonatomic, strong)NSString *content;
@property(nonatomic ,strong)NSString *type;//1,2,3
@property(nonatomic ,strong)NSString *date;

- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end

@interface ZHProductComment : NSObject
@property(nonatomic, strong)NSArray  *commentArray;   

- (void)loadCommentWithProductId:(NSString*)productId completionBlock:(ZHCompletionBlock)block;

@end
