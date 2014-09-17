//
//  CommentModel.h
//  ZHGreenFuture
//
//  Created by elvis on 9/17/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "BaseModel.h"

@interface CommentModel : BaseModel

@property (nonatomic,strong) NSString*  userId;
@property (nonatomic,strong) NSString*  userName;
@property (nonatomic,strong) NSString*  userAvatarURL;
@property (nonatomic,strong) NSString*  comment_date;
@property (nonatomic,strong) NSString*  contenet;
@property (nonatomic,strong) NSString*  commentId;

@end
