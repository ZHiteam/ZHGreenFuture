//
//  ZHProfileModel.h
//  ZHGreenFuture
//
//  Created by admin on 14-8-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHProfileModel : NSObject
@property(nonatomic, strong)NSString* backgoundImageUrl;
@property(nonatomic, strong)NSString* userAvatar;
@property(nonatomic, strong)NSString* userName;
@property(nonatomic, strong)NSString* waitPayCount;
@property(nonatomic, strong)NSString* deliverCount;
@property(nonatomic, strong)NSString* comfirmShoppingCount;
@property(nonatomic, strong)NSString* waitCommentCount;
@property(nonatomic, strong)UIImage* userAvatarImage;
- (void)loadDataWithUserId:(NSString*)userId completionBlock:(ZHCompletionBlock)block;
- (void)modifyProfileInfo:(UIImage *)avatarImage progressBlock:(ZHProgressBlock)progressBlock completionBlock:(ZHCompletionBlock)completeBlock;
- (void)modifyProfileInfo:(UIImage *)avatarImage userName:(NSString *)userName progressBlock:(ZHProgressBlock)progressBlock completionBlock:(ZHCompletionBlock)completeBlock;
@end
