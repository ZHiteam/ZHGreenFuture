//
//  CommentModel.m
//  ZHGreenFuture
//
//  Created by elvis on 9/17/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

+(id)praserModelWithInfo:(id)info{
    CommentModel* model = [[CommentModel alloc]init];
    if (![info isKindOfClass:[NSDictionary class]]){
        return model;
    }
    
    NSDictionary* dic = (NSDictionary*)info;
    
    model.contenet          = VALIDATE_VALUE(dic[@"content"]);
    model.comment_date      = VALIDATE_VALUE(dic[@"commentDate"]);
    model.userName          = VALIDATE_VALUE(dic[@"nickName"]);
    model.userId            = VALIDATE_VALUE(dic[@"userId"]);
    model.userAvatarURL     = VALIDATE_VALUE(dic[@"userAvatarURL"]);
    model.commentId         = VALIDATE_VALUE(dic[@"commentId"]);
    
    return model;
}

@end